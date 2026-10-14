import 'package:supabase_flutter/supabase_flutter.dart';

import '../observations/observation.dart';
import 'observation_filter.dart';

/// A megfigyelés-keresés szolgáltatása.
///
/// Két mód:
///  • [loadMine]      — a SAJÁT megfigyelések (kliens-oldali szűrés)
///  • [loadCommunity] — MINDENKI megfigyelései (szerveroldali, prémium)
class SearchRepository {
  SearchRepository(this._client);

  final SupabaseClient _client;

  // ── 1. SAJÁT megfigyelések ──────────────────────────────────────────

  /// A saját megfigyelések betöltése (a szűrést a hívó végzi).
  Future<List<Observation>> loadMine() async {
    final user = _client.auth.currentUser;
    if (user == null) throw Exception('Nincs bejelentkezett felhasználó');

    final res = await _client
        .from('observations_with_coords')
        .select(
          'id, user_id, species_id, observed_at, latitude, longitude, '
          'photos(storage_path, thumbnail_path), '
          'species(scientific_name, common_name_hu, vernacular_names, '
          'taxonomy_json)',
        )
        .eq('user_id', user.id)
        .order('observed_at', ascending: false);

    return (res as List)
        .map((e) => Observation.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  // ── 2. KÖZÖSSÉGI megfigyelések (prémium) ────────────────────────────

  /// A KÖZÖSSÉGI megfigyelések — mindenki adatai, szerveroldali szűréssel.
  ///
  /// Prémium előfizetés kell hozzá: az RPC és az RLS is ellenőrzi.
  /// A szűrést a szerver végzi (szöveg, csoport, dátum, körzet).
  ///
  /// [lat], [lng], [radiusKm] — a térképes körzet-szűrőhöz.
  Future<List<Observation>> loadCommunity(
    ObservationFilter filter, {
    double? lat,
    double? lng,
    double? radiusKm,
    int limit = 100,
  }) async {
    final user = _client.auth.currentUser;
    if (user == null) throw Exception('Nincs bejelentkezett felhasználó');

    final res = await _client.rpc(
      'search_community_observations',
      params: {
        'p_text': filter.text.trim().isEmpty ? null : filter.text.trim(),
        'p_group': filter.group,
        'p_from': filter.from?.toUtc().toIso8601String(),
        'p_to': filter.to?.toUtc().toIso8601String(),
        'p_lat': lat,
        'p_lng': lng,
        'p_radius_km': radiusKm,
        'p_limit': limit,
      },
    );

    return (res as List)
        .map((e) => _observationFromRpc(e as Map<String, dynamic>))
        .toList();
  }

  /// Az RPC lapos válaszát alakítja a meglévő Observation modellre.
  Observation _observationFromRpc(Map<String, dynamic> row) {
    final vernacular = <String, String>{};
    final raw = row['vernacular_names'];
    if (raw is Map) {
      raw.forEach((k, v) {
        if (v is String && v.isNotEmpty) vernacular[k.toString()] = v;
      });
    }

    final observedRaw = row['observed_at'];
    DateTime? observedAt;
    if (observedRaw is String) {
      observedAt = DateTime.tryParse(observedRaw);
    }

    return Observation(
      id: row['id'] as String,
      userId: row['user_id'] as String,
      latitude: ((row['latitude'] ?? 0) as num).toDouble(),
      longitude: ((row['longitude'] ?? 0) as num).toDouble(),
      speciesId: row['species_id'] as String?,
      scientificName: row['scientific_name'] as String?,
      commonNameHu: row['common_name_hu'] as String?,
      vernacularNames: vernacular,
      iconicTaxon: row['iconic_taxon'] as String?,
      observedAt: observedAt,
      photoPath: row['photo_path'] as String?,
      photoThumbPath: row['thumb_path'] as String?,
    );
  }

  // ── 3. Előfizetés ──────────────────────────────────────────────────

  /// A bejelentkezett felhasználó előfizetési csomagja.
  Future<String> myPlan() async {
    final user = _client.auth.currentUser;
    if (user == null) return 'free';

    try {
      final row = await _client
          .from('subscriptions')
          .select('plan, valid_until')
          .eq('user_id', user.id)
          .maybeSingle();

      if (row == null) return 'free';

      final plan = (row['plan'] as String?) ?? 'free';
      final validUntil = row['valid_until'] as String?;

      if (validUntil != null) {
        final end = DateTime.tryParse(validUntil);
        if (end != null && end.isBefore(DateTime.now())) return 'free';
      }
      return plan;
    } catch (_) {
      return 'free';
    }
  }

  /// Prémium-e a felhasználó.
  Future<bool> isPremium() async {
    final plan = await myPlan();
    return plan == 'premium' || plan == 'pro' || plan == 'enterprise';
  }

  /// FEJLESZTŐI TESZT: prémium bekapcsolása fizetés nélkül.
  ///
  /// Visszatérés: null = siker, egyébként a hibaüzenet.
  Future<String?> activateTestPremium() async {
    final user = _client.auth.currentUser;
    if (user == null) return 'Nincs bejelentkezett felhasználó';

    try {
      final existing = await _client
          .from('subscriptions')
          .select('id')
          .eq('user_id', user.id)
          .maybeSingle();

      if (existing != null) {
        final updated = await _client
            .from('subscriptions')
            .update({
              'plan': 'premium',
              'valid_until': null,
              'auto_renew': false,
            })
            .eq('user_id', user.id)
            .select();

        if ((updated as List).isEmpty) {
          return 'A módosítás nem sikerült (RLS). '
              'Ellenőrizd a subscriptions update policy-t.';
        }
      } else {
        await _client.from('subscriptions').insert({
          'user_id': user.id,
          'plan': 'premium',
          'valid_until': null,
          'auto_renew': false,
        });
      }
      return null;
    } catch (e) {
      return '$e';
    }
  }

  /// FEJLESZTŐI TESZT: visszaállítás ingyenesre.
  ///
  /// Visszatérés: null = siker, egyébként a hibaüzenet.
  Future<String?> deactivatePremium() async {
    final user = _client.auth.currentUser;
    if (user == null) return 'Nincs bejelentkezett felhasználó';

    try {
      final updated = await _client
          .from('subscriptions')
          .update({
            'plan': 'free',
            'valid_until': null,
          })
          .eq('user_id', user.id)
          .select();

      if ((updated as List).isEmpty) {
        return 'A módosítás nem sikerült (RLS). '
            'Ellenőrizd a subscriptions update policy-t.';
      }
      return null;
    } catch (e) {
      return '$e';
    }
  }
}
