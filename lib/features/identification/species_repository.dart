import 'package:supabase_flutter/supabase_flutter.dart';

import 'col_match.dart';

/// A fajkereső a SAJÁT adatbázisból.
///
/// A `species` tábla ~1,13 millió fajt tartalmaz, mind a hét nyelven
/// népies nevekkel — ezért nincs szükség külső API-hívásra.
/// A keresés a `scientific_name`, a `common_name_hu`, a `common_name_en`
/// és a `vernacular_names` (JSONB) mezőket fedi le.
class SpeciesRepository {
  SpeciesRepository(this._client);

  final SupabaseClient _client;

  /// Keresés fajnévre — bármelyik nyelven.
  ///
  /// [query]  a keresett szöveg (legalább 2 karakter)
  /// [language] ISO 639-3 kód ('hun', 'eng', …) — csak a megjelenítéshez
  /// [limit]  a találatok maximuma
  Future<List<ColMatch>> search({
    required String query,
    String language = 'eng',
    int limit = 25,
  }) async {
    final q = query.trim();
    if (q.length < 2) return const [];

    final res = await _client
        .from('species')
        .select(
          'id, scientific_name, common_name_hu, common_name_en, '
          'vernacular_names, taxonomy_json, col_id',
        )
        .or(
          'scientific_name.ilike.%$q%,'
          'common_name_hu.ilike.%$q%,'
          'common_name_en.ilike.%$q%',
        )
        .limit(limit);

    final rows = (res as List).cast<Map<String, dynamic>>();

    // A JSONB népies nevekben is keresünk, ha a fenti nem adott elég találatot.
    if (rows.length < limit) {
      final extra = await _searchVernacular(q, limit);
      for (final e in extra) {
        final sci = e['scientific_name'] as String?;
        if (sci != null && rows.every((r) => r['scientific_name'] != sci)) {
          rows.add(e);
        }
        if (rows.length >= limit) break;
      }
    }

    return rows.map(_toColMatch).toList();
  }

  /// A `vernacular_names` JSONB-ben keres (a nyelvtől függetlenül).
  Future<List<Map<String, dynamic>>> _searchVernacular(
    String q,
    int limit,
  ) async {
    final res = await _client.rpc(
      'search_species_by_vernacular',
      params: {'p_query': q, 'p_limit': limit},
    );
    return (res as List).cast<Map<String, dynamic>>();
  }

  /// Az adatbázis sorát a `ColMatch` modellre alakítja.
  ColMatch _toColMatch(Map<String, dynamic> row) {
    final vernacular = <String, String>{};
    final raw = row['vernacular_names'];
    if (raw is Map) {
      raw.forEach((k, v) {
        if (v is String && v.isNotEmpty) vernacular[k.toString()] = v;
      });
    }

    final tax = row['taxonomy_json'];
    String? iconic;
    String? family;
    if (tax is Map) {
      final i = tax['iconic_taxon'];
      if (i is String && i.isNotEmpty) iconic = i;
      final f = tax['family'];
      if (f is String && f.isNotEmpty) family = f;
    }

    // A `col_id` az iNaturalist taxon-szám — a `ColMatch.gbifKey` int mezőbe
    // csak akkor tesszük, ha szám.
    final colId = row['col_id'] as String?;
    final key = colId != null ? int.tryParse(colId) : null;

    return ColMatch(
      id: row['id'] as String?,          // ← a saját species.id (uuid)
      gbifKey: key,
      scientificName: row['scientific_name'] as String?,
      family: family,
      commonName: row['common_name_hu'] as String? ??
          row['common_name_en'] as String?,
      // Az `iconic_taxon` (Aves, Plantae, …) → a ColMatch `kingdom` mezője
      kingdom: _kingdomFromIconic(iconic),
      vernacularNames: vernacular,
    );
  }

  /// Az `iconic_taxon`-ból „királyságot” csinál (a ColMatch `kingdom` mezője).
  String? _kingdomFromIconic(String? iconic) {
    if (iconic == null) return null;
    final i = iconic.toLowerCase();
    if (i.contains('plant')) return 'Plantae';
    if (i.contains('fung')) return 'Fungi';
    if (i.contains('animal') ||
        i.contains('aves') ||
        i.contains('mammal') ||
        i.contains('insect') ||
        i.contains('amphib') ||
        i.contains('reptil') ||
        i.contains('fish') ||
        i.contains('arachnid') ||
        i.contains('mollusc')) {
      return 'Animalia';
    }
    return null;
  }
}
