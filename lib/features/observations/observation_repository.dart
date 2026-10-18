import 'dart:io';

import 'package:supabase_flutter/supabase_flutter.dart';

import 'observation.dart';

class ObservationRepository {
  ObservationRepository(this._client);

  final SupabaseClient _client;

  /// A bejelentkezett felhasználó SAJÁT megfigyelései.
  /// Az RLS policy is a saját sorokra szűr, ez az explicit .eq() a biztonsági öv.
  Future<List<Observation>> fetchMine() async {
    final user = _client.auth.currentUser;
    if (user == null) throw Exception('Nincs bejelentkezett felhasználó');

    final res = await _client
        .from('observations_with_coords')
        .select(
          'id, user_id, species_id, observed_at, latitude, longitude, '
          'moderation_status, '
          'photos(storage_path, thumbnail_path), '
          'species(scientific_name, common_name_hu, vernacular_names)',
        )
        .eq('user_id', user.id)
        .order('observed_at', ascending: false);

    return (res as List)
        .map((e) => Observation.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<Observation> create({
    required double latitude,
    required double longitude,
    required File photo,
    String? speciesId,
  }) async {
    final user = _client.auth.currentUser;
    if (user == null) throw Exception('Nincs bejelentkezett felhasználó');

    // A PostGIS geography mező WKT (Well-Known Text) formátumot vár.
    // Sorrend: POINT(hosszúság szélesség) — lon az első!
    final wkt = 'SRID=4326;POINT($longitude $latitude)';

    // 1. Megfigyelés létrehozása.
    //    Alapállapot: 'pending' — csak azonosítás után lesz közösségi.
    final res = await _client
        .from('observations')
        .insert({
          'user_id': user.id,
          'species_id': speciesId,
          'location': wkt,
          'observed_at': DateTime.now().toUtc().toIso8601String(),
          'moderation_status': 'pending',
        })
        .select()
        .single();

    final observationId = res['id'] as String;

    // 2. Fotó feltöltése a Storage-ba
    final fileName =
        '${user.id}/$observationId-${DateTime.now().millisecondsSinceEpoch}.jpg';

    await _client.storage.from('photos').upload(fileName, photo);

    // 3. Fotó sor rögzítése a photos táblában
    await _client.from('photos').insert({
      'observation_id': observationId,
      'storage_path': fileName,
    });

    return Observation.fromJson(res);
  }

  /// Az azonosított faj rögzítése egy megfigyelésen.
  /// Ha a faj még nincs a species táblában, létrehozza.
  ///
  /// [vernacularNames] nyelvenkénti nevek GBIF-kóddal kulcsolva
  /// (pl. {"hun": "...", "eng": "...", ...}).
  ///
  /// Az azonosítás egyben KÖZZÉTÉTEL is: a 'pending' állapotú megfigyelés
  /// 'published' lesz. A 'flagged' / 'rejected' állapotot NEM írja felül —
  /// azt csak moderátor oldhatja fel.
  Future<void> setSpeciesFromName({
    required String observationId,
    required String scientificName,
    String? commonName,
    String? iconicTaxon,
    Map<String, String> vernacularNames = const {},
    int? gbifKey,
  }) async {
    // 1. Megvan-e már a faj?
    final existing = await _client
        .from('species')
        .select('id, vernacular_names')
        .eq('scientific_name', scientificName)
        .maybeSingle();

    String speciesId;

    if (existing != null) {
      speciesId = existing['id'] as String;

      // Ha eddig nem voltak népies nevek, de most kaptunk, frissítjük.
      final existingNames = existing['vernacular_names'];
      final hadNone = existingNames is! Map || existingNames.isEmpty;
      if (hadNone && vernacularNames.isNotEmpty) {
        await _client.from('species').update({
          'vernacular_names': vernacularNames,
          'common_name_hu': vernacularNames['hun'] ?? commonName,
          'common_name_en': vernacularNames['eng'] ?? commonName,
        }).eq('id', speciesId);
      }
    } else {
      // 2. Új faj létrehozása
      try {
        final inserted = await _client
            .from('species')
            .insert({
              'scientific_name': scientificName,
              'common_name_en': vernacularNames['eng'] ?? commonName,
              'common_name_hu': vernacularNames['hun'] ?? commonName,
              'vernacular_names': vernacularNames,
              'taxonomy_json': {
                'iconic_taxon': iconicTaxon,
                if (gbifKey != null) 'gbif_key': gbifKey,
              },
              'is_verified': false,
            })
            .select('id')
            .single();
        speciesId = inserted['id'] as String;
      } catch (e) {
        // Ha az INSERT elhasal (pl. versenyhelyzet), próbáljuk újra lekérdezni.
        final retry = await _client
            .from('species')
            .select('id')
            .eq('scientific_name', scientificName)
            .maybeSingle();
        if (retry == null) {
          rethrow;
        }
        speciesId = retry['id'] as String;
      }
    }

    // 3. A megfigyeléshez rendelés + közzététel.
    //    A 'flagged' / 'rejected' állapotot NEM írjuk felül — azt csak
    //    moderátor oldhatja fel. A 'pending' viszont 'published' lesz,
    //    mert az azonosítás szándékos aktus volt.
    final current = await _client
        .from('observations')
        .select('moderation_status')
        .eq('id', observationId)
        .maybeSingle();

    final status = (current?['moderation_status'] as String?) ?? 'pending';
    final canPublish = status == 'pending';

    await _client.from('observations').update({
      'species_id': speciesId,
      if (canPublish) 'moderation_status': 'published',
    }).eq('id', observationId);
  }

  /// Egy megfigyelés törlése (a fotóval együtt).
  Future<void> delete(String observationId) async {
    final user = _client.auth.currentUser;
    if (user == null) throw Exception('Nincs bejelentkezett felhasználó');

    // A fotók útvonalát előbb kiolvassuk, hogy a Storage-ból is törölhessük.
    final photos = await _client
        .from('photos')
        .select('storage_path')
        .eq('observation_id', observationId);

    final paths = (photos as List)
        .map((p) => (p as Map)['storage_path'] as String?)
        .whereType<String>()
        .toList();

    if (paths.isNotEmpty) {
      try {
        await _client.storage.from('photos').remove(paths);
      } catch (_) {
        // Ha a Storage-törlés nem sikerül, a DB sor akkor is menjen.
      }
    }

    // A photos sorokat a CASCADE viszi, de explicit is töröljük.
    await _client.from('photos').delete().eq('observation_id', observationId);
    await _client.from('observations').delete().eq('id', observationId);
  }

/// A [setSpeciesFromName] régi neve — a megfigyeléslistából hívjuk.
  /// Ugyanaz, mint a [setSpeciesFromName]; közzététel a szabály szerint.
  Future<void> updateSpecies({
    required String observationId,
    required String scientificName,
    String? commonName,
    String? iconicTaxon,
    Map<String, String> vernacularNames = const {},
    int? gbifKey,
  }) {
    return setSpeciesFromName(
      observationId: observationId,
      scientificName: scientificName,
      commonName: commonName,
      iconicTaxon: iconicTaxon,
      vernacularNames: vernacularNames,
      gbifKey: gbifKey,
    );
  }

  /// A [delete] régi neve — a megfigyeléslistából hívjuk.
  Future<void> deleteObservation(String observationId) => delete(observationId);

  /// A Storage-ból letölti a fotót egy helyi fájlba
  /// (az újra-azonosításhoz kell, mert az iNaturalist fájlt vár).
  Future<File> downloadPhoto(String storagePath) async {
    final bytes = await _client.storage.from('photos').download(storagePath);
    final dir = Directory.systemTemp;
    final file = File(
      '${dir.path}/biospotter_${DateTime.now().millisecondsSinceEpoch}.jpg',
    );
    await file.writeAsBytes(bytes);
    return file;
  }

  /// A Storage-ban tárolt kép publikus URL-je.
  String photoUrl(String storagePath) {
    return _client.storage.from('photos').getPublicUrl(storagePath);
  }
}
