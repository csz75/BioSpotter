import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/services.dart';

import '../core/providers.dart';
import '../l10n/app_localizations.dart';
import 'home_screen.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  final _name = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();

  final _nameFocus = FocusNode();
  final _emailFocus = FocusNode();
  final _passwordFocus = FocusNode();

  bool _isSignUp = false;
  bool _loading = false;
  bool _obscure = true;

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _password.dispose();
    _nameFocus.dispose();
    _emailFocus.dispose();
    _passwordFocus.dispose();
    super.dispose();
  }

  /// iOS-en ez kényszeríti ki a szoftveres billentyűzetet.
  void _focus(FocusNode node) {
    FocusScope.of(context).requestFocus(node);
    SystemChannels.textInput.invokeMethod<void>('TextInput.show');
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    FocusScope.of(context).unfocus();
    setState(() => _loading = true);

    try {
      final auth = ref.read(authServiceProvider);
      if (_isSignUp) {
        await auth.signUp(
          email: _email.text.trim(),
          password: _password.text,
          displayName: _name.text.trim(),
        );
      } else {
        await auth.signIn(
          email: _email.text.trim(),
          password: _password.text,
        );
      }
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    } catch (e) {
      if (!mounted) return;
      final l = AppLocalizations.of(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l.loginError('$e'))),
      );
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => FocusScope.of(context).unfocus(),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              keyboardDismissBehavior:
                  ScrollViewKeyboardDismissBehavior.onDrag,
              padding: const EdgeInsets.all(24),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 420),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Icon(Icons.park, size: 64, color: Color(0xFF2E7D32)),
                      const SizedBox(height: 12),
                      Text(
                        l.loginTitle,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      const SizedBox(height: 32),
                      if (_isSignUp) ...[
                        TextFormField(
                          controller: _name,
                          focusNode: _nameFocus,
                          textInputAction: TextInputAction.next,
                          autocorrect: false,
                          enableSuggestions: false,
                          onTap: () => _focus(_nameFocus),
                          onFieldSubmitted: (_) => _focus(_emailFocus),
                          decoration: InputDecoration(
                            labelText: l.loginDisplayName,
                            border: const OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],
                      TextFormField(
                        controller: _email,
                        focusNode: _emailFocus,
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        autocorrect: false,
                        enableSuggestions: false,
                        onTap: () => _focus(_emailFocus),
                        onFieldSubmitted: (_) => _focus(_passwordFocus),
                        decoration: InputDecoration(
                          labelText: l.loginEmail,
                          border: const OutlineInputBorder(),
                        ),
                        validator: (v) {
                          final s = v?.trim() ?? '';
                          if (s.isEmpty) return l.loginEmailRequired;
                          if (!s.contains('@')) return l.loginEmailInvalid;
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _password,
                        focusNode: _passwordFocus,
                        obscureText: _obscure,
                        autocorrect: false,
                        enableSuggestions: false,
                        textInputAction: TextInputAction.done,
                        onTap: () => _focus(_passwordFocus),
                        onFieldSubmitted: (_) => _submit(),
                        decoration: InputDecoration(
                          labelText: l.loginPassword,
                          border: const OutlineInputBorder(),
                          suffixIcon: IconButton(
                            icon: Icon(_obscure
                                ? Icons.visibility_off
                                : Icons.visibility),
                            onPressed: () =>
                                setState(() => _obscure = !_obscure),
                          ),
                        ),
                        validator: (v) {
                          if ((v ?? '').length < 6) {
                            return l.loginPasswordTooShort;
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 24),
                      FilledButton(
                        onPressed: _loading ? null : _submit,
                        child: _loading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child:
                                    CircularProgressIndicator(strokeWidth: 2),
                              )
                            : Text(_isSignUp ? l.loginSignUp : l.loginSignIn),
                      ),
                      TextButton(
                        onPressed: () {
                          FocusScope.of(context).unfocus();
                          setState(() => _isSignUp = !_isSignUp);
                        },
                        child: Text(_isSignUp
                            ? l.loginSwitchToSignIn
                            : l.loginSwitchToSignUp),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
