import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  AuthService(this._client);

  final SupabaseClient _client;

  /// Regisztráció.
  ///
  /// A `display_name` a **metadata**-ba kerül — az adatbázis-trigger
  /// onnan olvassa ki, amikor a felhasználó megerősíti az e-mail-címét.
  ///
  /// Megerősítés esetén a `res.session` **null** (a felhasználó még nincs
  /// bejelentkezve), ezért NEM írunk a `public.users`-be — azt a trigger
  /// teszi, amikor a fiók létrejön.
  Future<AuthResponse> signUp({
    required String email,
    required String password,
    required String displayName,
  }) {
    return _client.auth.signUp(
      email: email,
      password: password,
      data: {'display_name': displayName},
      emailRedirectTo: '[csz75.github.io](https://csz75.github.io/BioSpotter/)',
    );
  }

  /// Újraküldi a megerősítő e-mailt.
  Future<void> resendConfirmation(String email) {
    return _client.auth.resend(
      type: OtpType.signup,
      email: email,
      emailRedirectTo: '[csz75.github.io](https://csz75.github.io/BioSpotter/)',
    );
  }

  /// Belépés e-mail-címmel és jelszóval.
  ///
  /// Ha az e-mail-cím nincs megerősítve, a Supabase
  /// `email_not_confirmed` hibát dob — ezt a képernyő kezeli.
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
