import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'core/locale_controller.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_controller.dart';
import 'l10n/app_localizations.dart';
import 'screens/login_screen.dart';
import 'screens/main_shell.dart';

class BioSpotterApp extends StatefulWidget {
  const BioSpotterApp({super.key});

  @override
  State<BioSpotterApp> createState() => _BioSpotterAppState();
}

class _BioSpotterAppState extends State<BioSpotterApp> {
  @override
  void initState() {
    super.initState();
    // Nyelv- és témaváltáskor újraépítjük az egész appot
    localeController.addListener(_onChanged);
    themeController.addListener(_onChanged);
  }

  @override
  void dispose() {
    localeController.removeListener(_onChanged);
    themeController.removeListener(_onChanged);
    super.dispose();
  }

  void _onChanged() => setState(() {});

  @override
  Widget build(BuildContext context) {
    final loggedIn = Supabase.instance.client.auth.currentSession != null;

    return MaterialApp(
      onGenerateTitle: (context) => AppLocalizations.of(context).appTitle,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: themeController.mode,
      locale: localeController.locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLanguage.all
          .map((l) => Locale(l.code))
          .toList(growable: false),
      home: loggedIn ? const MainShell() : const LoginScreen(),
    );
  }
}
