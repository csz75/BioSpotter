import 'package:supabase_flutter/supabase_flutter.dart';

/// A megfigyelések kedvelése (like).
///
/// A `observation_likes` tábla a Supabase-ben már létezik
/// (`user_id` + `observation_id`, egyedi páronként).
class LikeRepository {
  LikeRepository(this._client);

  final SupabaseClient _client;

  /// Egy megfigyelés like-száma és hogy a bejelentkezett felhasználó
  /// kedvelte-e. Visszaad: (count, likedByMe).
  Future<({int count, bool likedByMe})> stats(String observationId) async {
    final user = _client.auth.currentUser;
    if (user == null) return (count: 0, likedByMe: false);

    try {
      final res = await _client.rpc(
        'observation_like_counts',
        params: {
          'p_ids': [observationId],
        },
      );
      final rows = (res as List).cast<Map<String, dynamic>>();
      if (rows.isEmpty) return (count: 0, likedByMe: false);

      final row = rows.first;
      return (
        count: (row['like_count'] as num?)?.toInt() ?? 0,
        likedByMe: (row['liked_by_me'] as bool?) ?? false,
      );
    } catch (_) {
      return (count: 0, likedByMe: false);
    }
  }

  /// Like vagy unlike — ha már kedvelte, elveszi; ha nem, hozzáadja.
  /// Visszaadja az új állapotot: (count, likedByMe).
  Future<({int count, bool likedByMe})> toggle(String observationId) async {
    final user = _client.auth.currentUser;
    if (user == null) throw Exception('Nincs bejelentkezett felhasználó');

    // 1. Megvan-e már a like?
    final existing = await _client
        .from('observation_likes')
        .select('id')
        .eq('observation_id', observationId)
        .eq('user_id', user.id)
        .maybeSingle();

    if (existing != null) {
      await _client
          .from('observation_likes')
          .delete()
          .eq('observation_id', observationId)
          .eq('user_id', user.id);
    } else {
      await _client.from('observation_likes').insert({
        'observation_id': observationId,
        'user_id': user.id,
      });
    }

    return stats(observationId);
  }
}
