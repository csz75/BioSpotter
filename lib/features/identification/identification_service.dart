import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/config/env.dart';
import 'species_suggestion.dart';

/// A fajazonosítást végző szolgáltatás.
/// A kliens a Supabase Edge Functiont hívja — az iNaturalist API kulcs
/// a szerveroldalon marad.
class IdentificationService {
  IdentificationService(this._client);

  final SupabaseClient _client;

  Future<List<SpeciesSuggestion>> identify(File image) async {
    try {
      // Fix, stabil URL — nem függ az SDK belső rest.url értékétől.
      final uri = Uri.parse(
        '${Env.supabaseUrl}/functions/v1/identify-species',
      );

      final anonKey = _client.headers['apikey']?.toString() ?? '';
      final accessToken = _client.auth.currentSession?.accessToken ?? anonKey;

      debugPrint('identify-species → POST $uri');

      final request = http.MultipartRequest('POST', uri);
      request.headers['Authorization'] = 'Bearer $accessToken';
      request.headers['apikey'] = anonKey;
      request.files.add(
        await http.MultipartFile.fromPath('image', image.path),
      );

      final streamed = await request.send().timeout(
            const Duration(seconds: 45),
          );
      final response = await http.Response.fromStream(streamed);

      debugPrint('identify-species status: ${response.statusCode}');
      debugPrint('identify-species body: ${response.body}');

      if (response.statusCode != 200) {
        return const [];
      }

      final body = jsonDecode(response.body) as Map<String, dynamic>;
      final list = body['suggestions'] as List? ?? [];

      return list
          .map((e) => SpeciesSuggestion.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      debugPrint('identify-species error: $e');
      return const [];
    }
  }
}
