import 'package:flutter/material.dart';

/// A kiválasztott megjelenés (világos / sötét / rendszer) tárolója.
class ThemeController extends ChangeNotifier {
  ThemeMode _mode = ThemeMode.system;

  ThemeMode get mode => _mode;

  void setMode(ThemeMode mode) {
    _mode = mode;
    notifyListeners();
  }
}

/// Globális hozzáférés a megjelenéshez (a localeController mintájára).
final themeController = ThemeController();
