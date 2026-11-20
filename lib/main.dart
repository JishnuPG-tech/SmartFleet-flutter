import "dart:async";
import "package:flutter/material.dart";
import "package:flutter_localizations/flutter_localizations.dart";
import "core/design/theme/app_theme_v2.dart";
import "core/design/theme/theme_controller.dart";
import "core/data/fleet_repository.dart";
import "core/data/config_manager.dart";
import "core/data/fleet_websocket_service.dart";
import "l10n/app_localizations.dart";
import "screens/splash/splash_screen.dart";

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LocalFleetRepository.instance.getTrips();
  unawaited(ConfigManager.instance.syncFromRemote());
  FleetWebSocketService.instance.connect();
  runApp(const SmartFleetApp());
}

class SmartFleetApp extends StatefulWidget {
  const SmartFleetApp({super.key});

  @override
  State<SmartFleetApp> createState() => _SmartFleetAppState();
}

class _SmartFleetAppState extends State<SmartFleetApp> {
  Locale _locale = const Locale("en");

  void _toggleLanguage() {
    setState(() {
      _locale = _locale.languageCode == "en" ? const Locale("ml") : const Locale("en");
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: ThemeController.instance,
      builder: (context, _) {
        return MaterialApp(
          title: "SmartFleet",
          debugShowCheckedModeBanner: false,
          theme: AppThemeV2.buildTheme(
            Brightness.light,
            canvas: ThemeController.instance.canvasTheme,
            palette: ThemeController.instance.palette,
          ),
          darkTheme: AppThemeV2.buildTheme(
            Brightness.dark,
            canvas: ThemeController.instance.canvasTheme,
            palette: ThemeController.instance.palette,
          ),
          themeMode: ThemeController.instance.mode,
          locale: _locale,
          supportedLocales: const [
            Locale("en"),
            Locale("ml"),
          ],
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          home: SplashScreen(onToggleLanguage: _toggleLanguage),
        );
      },
    );
  }
}
