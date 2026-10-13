import 'package:flutter/material.dart';

/// A BioSpotter által támogatott nyelvek.
class AppLanguage {
  const AppLanguage(this.code, this.label, this.flag);

  final String code;   // ISO 639-1
  final String label;  // a nyelv saját neve
  final String flag;   // emoji zászló

  static const hu = AppLanguage('hu', 'Magyar', '🇭🇺');
  static const en = AppLanguage('en', 'English', '🇬🇧');
  static const es = AppLanguage('es', 'Español', '🇪🇸');
  static const de = AppLanguage('de', 'Deutsch', '🇩🇪');
  static const fr = AppLanguage('fr', 'Français', '🇫🇷');
  static const pl = AppLanguage('pl', 'Polski', '🇵🇱');
  static const it = AppLanguage('it', 'Italiano', '🇮🇹');

  static const all = <AppLanguage>[hu, en, es, de, fr, pl, it];

  /// A nyelvkód alapján visszaadja a nyelvet. Ha nem található, angolt ad.
  static AppLanguage fromCode(String? code) {
    if (code == null) return en;
    return all.firstWhere(
      (l) => l.code == code,
      orElse: () => en,
    );
  }
}

/// A kiválasztott nyelv tárolója.
/// `null` = kövesse a rendszer nyelvét.
class LocaleController extends ChangeNotifier {
  Locale? _locale;

  Locale? get locale => _locale;

  /// A jelenleg érvényes nyelv (a rendszer nyelvére visszaesve).
  AppLanguage current(String systemLocaleCode) {
    return AppLanguage.fromCode(_locale?.languageCode ?? systemLocaleCode);
  }

  void setLocale(String? languageCode) {
    _locale = languageCode == null ? null : Locale(languageCode);
    notifyListeners();
  }
}

/// Egyszerű, globális hozzáférés a kiválasztott nyelvhez,
/// provider-csomag nélkül (nem kell hozzá extra függőség).
final localeController = LocaleController();
