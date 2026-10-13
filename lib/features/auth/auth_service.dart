import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  AuthService(this._client);

  final SupabaseClient _client;

Future<AuthResponse> signUp({
    required String email,
    required String password,
    required String displayName,
  }) async {
    final res = await _client.auth.signUp(
      email: email,
      password: password,
    );

    final user = res.user;
    if (user != null) {
      // A public.users sor beszúrása — ez kell az idegen kulcshoz.
      // upsert: ha már létezik (pl. trigger), ne dobjon hibát.
      await _client.from('users').upsert({
        'id': user.id,
        'email': email,
        'display_name': displayName,
      });
    }

    return res;
  }

  Future<AuthResponse> signIn({
    required String email,
    required String password,
  }) {
    return _client.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  Future<void> signOut() => _client.auth.signOut();
}
