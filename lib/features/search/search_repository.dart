import 'package:supabase_flutter/supabase_flutter.dart';

import '../observations/observation.dart';

/// A megfigyelés-keresés szolgáltatása.
///
/// Most a SAJÁT megfigyeléseken szűr (kliens-oldalon).
/// A prémium közösségi nézet ugyanezt a felületet használja majd,
/// csak szerveroldali szűréssel.
class SearchRepository {
  SearchRepository(this._client);

  final SupabaseClient _client;

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

  // ── A prémium (közösségi) keresés helye ─────────────────────────────
  //
  // Amikor a prémium nézet elkészül, ide kerül egy `loadCommunity()`
  // metódus, ami ugyanezt a listát adja, de az összes felhasználó
  // megfigyeléseiből — szerveroldali szűréssel (PostGIS).
  // Az RLS policy a subscriptions.plan-t ellenőrzi majd.
}
