import "package:flutter/material.dart";
import "../tokens/app_colors.dart";

class ThemeController extends ChangeNotifier {
  static final ThemeController instance = ThemeController._();
  ThemeController._();

  FleetPalette _fleetPalette = FleetPalette.sageLemon;
  FleetPalette get fleetPalette => _fleetPalette;

  AppCanvasTheme _canvasTheme = AppCanvasTheme.sageDark;
  AppCanvasTheme get canvasTheme => _canvasTheme;

  AppAccentPalette _palette = AppAccentPalette.lemon;
  AppAccentPalette get palette => _palette;

  bool _isDark = true;
  bool get isDarkMode => _isDark;

  bool _hasCompletedOnboarding = false;
  bool get hasCompletedOnboarding => _hasCompletedOnboarding;

  ThemeMode get mode => _isDark ? ThemeMode.dark : ThemeMode.light;

  void setFleetPalette(FleetPalette newPalette) {
    _fleetPalette = newPalette;
    switch (newPalette) {
      case FleetPalette.sageLemon:
        _canvasTheme = _isDark ? AppCanvasTheme.sageDark : AppCanvasTheme.sageLight;
        _palette = AppAccentPalette.lemon;
        break;
      case FleetPalette.blueTangerine:
        _canvasTheme = _isDark ? AppCanvasTheme.blueDark : AppCanvasTheme.blueLight;
        _palette = AppAccentPalette.tangerine;
        break;
      case FleetPalette.offWhiteCherry:
        _canvasTheme = _isDark ? AppCanvasTheme.offWhiteDark : AppCanvasTheme.offWhiteLight;
        _palette = AppAccentPalette.cherryRed;
        break;
    }
    notifyListeners();
  }

  void setCanvasTheme(AppCanvasTheme newCanvas) {
    _canvasTheme = newCanvas;
    _isDark = newCanvas == AppCanvasTheme.midnightBlack ||
        newCanvas == AppCanvasTheme.claudeWarm ||
        newCanvas == AppCanvasTheme.claudeDeep ||
        newCanvas == AppCanvasTheme.sageDark ||
        newCanvas == AppCanvasTheme.blueDark ||
        newCanvas == AppCanvasTheme.offWhiteDark;
    notifyListeners();
  }

  void setPalette(AppAccentPalette newPalette) {
    _palette = newPalette;
    notifyListeners();
  }

  void toggleTheme() {
    _isDark = !_isDark;
    setFleetPalette(_fleetPalette);
  }

  void setThemeMode(ThemeMode newMode) {
    _isDark = newMode == ThemeMode.dark;
    setFleetPalette(_fleetPalette);
  }

  void completeOnboarding() {
    _hasCompletedOnboarding = true;
    notifyListeners();
  }

  void resetOnboarding() {
    _hasCompletedOnboarding = false;
    notifyListeners();
  }

  bool isDark(BuildContext context) => _isDark;
}
