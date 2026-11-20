import "package:flutter/material.dart";

enum AppCanvasTheme {
  midnightBlack,
  pureWhite,
  claudeWarm,
  claudeDeep,
}

enum AppAccentPalette {
  limeGreen,
  skyBlue,
  claudeOrange,
}

class ThemeController extends ChangeNotifier {
  static final ThemeController instance = ThemeController._();
  ThemeController._();

  AppCanvasTheme _canvasTheme = AppCanvasTheme.midnightBlack;
  AppCanvasTheme get canvasTheme => _canvasTheme;

  AppAccentPalette _palette = AppAccentPalette.claudeOrange;
  AppAccentPalette get palette => _palette;

  bool _hasCompletedOnboarding = false;
  bool get hasCompletedOnboarding => _hasCompletedOnboarding;

  ThemeMode get mode {
    if (_canvasTheme == AppCanvasTheme.pureWhite) return ThemeMode.light;
    return ThemeMode.dark;
  }

  void setCanvasTheme(AppCanvasTheme newCanvas) {
    if (_canvasTheme == newCanvas) return;
    _canvasTheme = newCanvas;
    notifyListeners();
  }

  void setThemeMode(ThemeMode mode) {
    if (mode == ThemeMode.light) {
      setCanvasTheme(AppCanvasTheme.pureWhite);
    } else {
      setCanvasTheme(AppCanvasTheme.midnightBlack);
    }
  }

  void toggleTheme() {
    if (_canvasTheme == AppCanvasTheme.pureWhite) {
      setCanvasTheme(AppCanvasTheme.midnightBlack);
    } else {
      setCanvasTheme(AppCanvasTheme.pureWhite);
    }
  }

  void setPalette(AppAccentPalette newPalette) {
    if (_palette == newPalette) return;
    _palette = newPalette;
    notifyListeners();
  }

  void completeOnboarding() {
    if (_hasCompletedOnboarding) return;
    _hasCompletedOnboarding = true;
    notifyListeners();
  }

  void resetOnboarding() {
    _hasCompletedOnboarding = false;
    notifyListeners();
  }

  bool isDark(BuildContext context) {
    return _canvasTheme != AppCanvasTheme.pureWhite;
  }
}
