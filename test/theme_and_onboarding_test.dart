import "package:flutter/material.dart";
import "package:flutter_localizations/flutter_localizations.dart";
import "package:flutter_test/flutter_test.dart";
import "package:smartfleet_flutter/core/design/theme/app_theme_v2.dart";
import "package:smartfleet_flutter/core/design/theme/theme_controller.dart";
import "package:smartfleet_flutter/core/design/tokens/app_colors.dart";
import "package:smartfleet_flutter/l10n/app_localizations.dart";
import "package:smartfleet_flutter/screens/auth/role_select_screen.dart";
import "package:smartfleet_flutter/screens/auth/admin_login_screen.dart";
import "package:smartfleet_flutter/screens/auth/driver_auth_screen.dart";
import "package:smartfleet_flutter/screens/onboarding/onboarding_screen.dart";
import "package:smartfleet_flutter/screens/splash/splash_screen.dart";

Widget _buildTestWrapper({required Widget child}) {
  return AnimatedBuilder(
    animation: ThemeController.instance,
    builder: (context, _) {
      return MaterialApp(
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
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [Locale('en'), Locale('ml')],
        home: child,
      );
    },
  );
}

void main() {
  group("Decoupled Theme Matrix Tests", () {
    test("Canvas themes maintain expected background colors", () {
      final whiteColors = AppColorsExtension.resolve(
        canvas: AppCanvasTheme.pureWhite,
        accent: AppAccentPalette.limeGreen,
      );
      expect(whiteColors.bg, const Color(0xFFFFFFFF));

      final midnightColors = AppColorsExtension.resolve(
        canvas: AppCanvasTheme.midnightBlack,
        accent: AppAccentPalette.limeGreen,
      );
      expect(midnightColors.bg, const Color(0xFF000000));

      final claudeWarmColors = AppColorsExtension.resolve(
        canvas: AppCanvasTheme.claudeWarm,
        accent: AppAccentPalette.limeGreen,
      );
      expect(claudeWarmColors.bg, const Color(0xFF181715));

      final claudeDeepColors = AppColorsExtension.resolve(
        canvas: AppCanvasTheme.claudeDeep,
        accent: AppAccentPalette.limeGreen,
      );
      expect(claudeDeepColors.bg, const Color(0xFF141413));
    });

    test("Changing accent palette NEVER alters the canvas background", () {
      final limeMidnight = AppColorsExtension.resolve(
        canvas: AppCanvasTheme.midnightBlack,
        accent: AppAccentPalette.limeGreen,
      );
      final skyMidnight = AppColorsExtension.resolve(
        canvas: AppCanvasTheme.midnightBlack,
        accent: AppAccentPalette.skyBlue,
      );
      final orangeMidnight = AppColorsExtension.resolve(
        canvas: AppCanvasTheme.midnightBlack,
        accent: AppAccentPalette.claudeOrange,
      );

      // Background MUST be strictly #000000 regardless of accent
      expect(limeMidnight.bg, const Color(0xFF000000));
      expect(skyMidnight.bg, const Color(0xFF000000));
      expect(orangeMidnight.bg, const Color(0xFF000000));

      // Brand accent colors MUST match exact specifications
      expect(limeMidnight.brand, const Color(0xFFC6FF00));
      expect(skyMidnight.brand, const Color(0xFF38BDF8));
      expect(orangeMidnight.brand, const Color(0xFFD97757)); // Exact Terracotta Orange
    });
  });

  group("Role Selection & Onboarding Widget Tests", () {
    testWidgets("RoleSelectScreen renders centered question and 2 role cards", (tester) async {
      await tester.pumpWidget(_buildTestWrapper(child: const RoleSelectScreen()));
      await tester.pumpAndSettle();

      expect(find.text("Are you an Admin or a Driver?"), findsOneWidget);
      expect(find.text("Fleet Administrator"), findsOneWidget);
      expect(find.text("Fleet Pilot / Driver"), findsOneWidget);
    });

    testWidgets("OnboardingScreen displays 3 slides and controls", (tester) async {
      await tester.pumpWidget(_buildTestWrapper(child: const OnboardingScreen()));
      await tester.pumpAndSettle();

      expect(find.text("Skip"), findsOneWidget);
      expect(find.text("Continue"), findsOneWidget);
      expect(find.text("Real-Time GPS Fleet Radar"), findsOneWidget);
    });

    testWidgets("AdminLoginScreen renders credentials form", (tester) async {
      await tester.pumpWidget(_buildTestWrapper(child: const AdminLoginScreen()));
      await tester.pumpAndSettle();

      expect(find.text("Admin Sign In"), findsOneWidget);
      expect(find.text("Fleet Administrator"), findsOneWidget);
      expect(find.text("Enter Command Portal"), findsOneWidget);
    });

    testWidgets("DriverAuthScreen renders Sign In and Register tabs", (tester) async {
      await tester.pumpWidget(_buildTestWrapper(child: const DriverAuthScreen()));
      await tester.pumpAndSettle();

      expect(find.text("Driver Portal"), findsOneWidget);
      expect(find.text("Sign In"), findsOneWidget);
      expect(find.text("New Pilot Registration"), findsOneWidget);
      expect(find.text("Launch Cockpit HUD"), findsOneWidget);
    });
  });
}
