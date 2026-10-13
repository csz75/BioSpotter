import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/config/env.dart';
import 'col_match.dart';

/// Fajnév-keresés a GBIF Species API-n keresztül (Supabase Edge Function).
class ColSearchService {
  ColSearchService(this._client);

  final SupabaseClient _client;

  Future<List<ColMatch>> search({
    required String query,
    required String language,
    int limit = 20,
  }) async {
    try {
      final uri = Uri.parse('${Env.supabaseUrl}/functions/v1/col-search');

      final anonKey = _client.headers['apikey']?.toString() ?? '';
      final accessToken = _client.auth.currentSession?.accessToken ?? anonKey;

      final res = await http
          .post(
            uri,
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $accessToken',
              'apikey': anonKey,
            },
            body: jsonEncode({
              'query': query,
              'language': language,
              'limit': limit,
            }),
          )
          .timeout(const Duration(seconds: 30));

      debugPrint('col-search status: ${res.statusCode}');

      if (res.statusCode != 200) return const [];

      final body = jsonDecode(res.body) as Map<String, dynamic>;
      final list = body['matches'] as List? ?? [];

      return list
          .map((e) => ColMatch.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      debugPrint('col-search error: $e');
      return const [];
    }
  }
}
