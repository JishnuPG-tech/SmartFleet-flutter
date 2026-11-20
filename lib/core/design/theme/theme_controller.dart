import "package:flutter/material.dart";

enum AppAccentPalette {
  limeGreen,
  skyBlue,
  claudeOrange,
}

class ThemeController extends ChangeNotifier {
  static final ThemeController instance = ThemeController._();
  ThemeController._();

  ThemeMode _mode = ThemeMode.system;
  ThemeMode get mode => _mode;

  AppAccentPalette _palette = AppAccentPalette.limeGreen;
  AppAccentPalette get palette => _palette;

  void setThemeMode(ThemeMode newMode) {
    if (_mode == newMode) return;
    _mode = newMode;
    notifyListeners();
  }

  void setPalette(AppAccentPalette newPalette) {
    if (_palette == newPalette) return;
    _palette = newPalette;
    notifyListeners();
  }

  bool isDark(BuildContext context) {
    if (_mode == ThemeMode.dark) return true;
    if (_mode == ThemeMode.light) return false;
    return MediaQuery.platformBrightnessOf(context) == Brightness.dark;
  }
}
