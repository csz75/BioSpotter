import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../core/providers.dart';
import '../l10n/app_localizations.dart';
import 'home_screen.dart';

/// „Erősítsd meg az e-mail-címed" — regisztráció után.
///
/// Két módon lép tovább:
///  • automatikusan, ha a fiók aktívvá válik (háttérben figyeli)
///  • a „Már megerősítettem" gombbal, azonnal
class VerifyEmailScreen extends ConsumerStatefulWidget {
  const VerifyEmailScreen({
    super.key,
    required this.email,
    required this.password,
  });

  final String email;
  final String password;

  @override
  ConsumerState<VerifyEmailScreen> createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends ConsumerState<VerifyEmailScreen> {
  bool _sending = false;
  bool _checking = false;

  Timer? _poll;
  int _attempts = 0;

  /// Legfeljebb ennyi ideig figyelünk (3 mp-enként, ~5 perc).
  static const _maxAttempts = 100;

  @override
  void initState() {
    super.initState();
    // A háttérben figyeljük, mikor válik aktívvá a fiók.
    _poll = Timer.periodic(const Duration(seconds: 3), (_) => _tryEnter());
  }

  @override
  void dispose() {
    _poll?.cancel();
    super.dispose();
  }

  /// Megpróbál belépni. Ha a fiók aktív, belép és továbblép.
  /// Ha még nem erősítették meg, csendben tovább vár.
  Future<void> _tryEnter({bool silent = true}) async {
    if (_checking) return;
    if (_attempts >= _maxAttempts) {
      _poll?.cancel();
      return;
    }
    _attempts++;

    if (!silent) setState(() => _checking = true);
    try {
      await ref.read(authServiceProvider).signIn(
            email: widget.email,
            password: widget.password,
          );
      if (!mounted) return;
      _poll?.cancel();
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    } on AuthException catch (e) {
      // Ha még nincs megerősítve, várunk tovább (csendes módban).
      final notConfirmed =
          e.code == 'email_not_confirmed' || '${e.message}'.contains('not confirmed');
      if (!silent && !notConfirmed) {
        final l = AppLocalizations.of(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l.loginError(e.message))),
        );
      }
      if (!silent && notConfirmed) {
        final l = AppLocalizations.of(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l.verifyEmailNotYet)),
        );
      }
    } catch (_) {
      // Hálózati hiba — csendben tovább várunk.
    } finally {
      if (mounted && !silent) setState(() => _checking = false);
    }
  }

  Future<void> _resend() async {
    final l = AppLocalizations.of(context);
    setState(() => _sending = true);
    try {
      await ref.read(authServiceProvider).resendConfirmation(widget.email);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l.verifyEmailResent)),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l.loginError('$e'))),
      );
    } finally {
      if (mounted) setState(() => _sending = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(l.verifyEmailTitle)),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Icon(Icons.mark_email_unread_outlined,
                    size: 64, color: Color(0xFF2E7D32)),
                const SizedBox(height: 16),
                Text(
                  l.verifyEmailHeading,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 12),
                Text(
                  l.verifyEmailBody(widget.email),
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 24),

                // Azonnali ellenőrzés — ha már megerősítetted
                FilledButton.icon(
                  icon: _checking
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.check),
                  label: Text(l.verifyEmailImDone),
                  onPressed: _checking ? null : () => _tryEnter(silent: false),
                ),
                const SizedBox(height: 8),

                OutlinedButton.icon(
                  icon: _sending
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.refresh),
                  label: Text(l.verifyEmailResend),
                  onPressed: _sending ? null : _resend,
                ),
                const SizedBox(height: 8),

                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(l.verifyEmailBack),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
