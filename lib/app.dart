import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'core/locale_controller.dart';
import 'core/theme/app_theme.dart';
import 'l10n/app_localizations.dart';
import 'screens/home_screen.dart';
import 'screens/login_screen.dart';

class BioSpotterApp extends StatefulWidget {
  const BioSpotterApp({super.key});

  @override
  State<BioSpotterApp> createState() => _BioSpotterAppState();
}

class _BioSpotterAppState extends State<BioSpotterApp> {
  @override
  void initState() {
    super.initState();
    // Nyelvváltáskor újraépítjük az egész appot
    localeController.addListener(_onLocaleChanged);
  }

  @override
  void dispose() {
    localeController.removeListener(_onLocaleChanged);
    super.dispose();
  }

  void _onLocaleChanged() => setState(() {});

  @override
  Widget build(BuildContext context) {
    final loggedIn = Supabase.instance.client.auth.currentSession != null;

    return MaterialApp(
      onGenerateTitle: (context) => AppLocalizations.of(context).appTitle,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      locale: localeController.locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLanguage.all
          .map((l) => Locale(l.code))
          .toList(growable: false),
      home: loggedIn ? const HomeScreen() : const LoginScreen(),
    );
  }
}
