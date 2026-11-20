import "package:flutter/material.dart";
import "../theme/theme_controller.dart";

@immutable
class AppColorsExtension extends ThemeExtension<AppColorsExtension> {
  final Color bg;
  final Color surface;
  final Color surfaceAlt;
  final Color border;
  final Color text;
  final Color textSecondary;
  final Color brand;
  final Color onBrand;
  final Color accent;

  final Color statusSuccess;
  final Color statusSuccessContainer;
  final Color statusRunning;
  final Color statusRunningContainer;
  final Color statusWaiting;
  final Color statusWaitingContainer;
  final Color statusDanger;
  final Color statusDangerContainer;

  const AppColorsExtension({
    required this.bg,
    required this.surface,
    required this.surfaceAlt,
    required this.border,
    required this.text,
    required this.textSecondary,
    required this.brand,
    required this.onBrand,
    this.accent = const Color(0xFFC6FF00),
    required this.statusSuccess,
    required this.statusSuccessContainer,
    required this.statusRunning,
    required this.statusRunningContainer,
    required this.statusWaiting,
    required this.statusWaitingContainer,
    required this.statusDanger,
    required this.statusDangerContainer,
  });

  /// Decoupled Resolver:
  /// Canvas theme defines the background, surface, borders, and typography.
  /// Accent palette defines the brand buttons, highlights, active tabs, and badges ONLY.
  static AppColorsExtension resolve({
    required AppCanvasTheme canvas,
    required AppAccentPalette accent,
  }) {
    // 1. Resolve Canvas Background & Surface Tokens
    late final Color bg;
    late final Color surface;
    late final Color surfaceAlt;
    late final Color border;
    late final Color text;
    late final Color textSecondary;
    late final Color statusSuccessContainer;
    late final Color statusRunningContainer;
    late final Color statusWaitingContainer;
    late final Color statusDangerContainer;

    switch (canvas) {
      case AppCanvasTheme.pureWhite:
        bg = const Color(0xFFFFFFFF);
        surface = const Color(0xFFF4F4F5);
        surfaceAlt = const Color(0xFFE4E4E7);
        border = const Color(0xFFE4E4E7);
        text = const Color(0xFF09090B);
        textSecondary = const Color(0xFF71717A);
        statusSuccessContainer = const Color(0xFFDCFCE7);
        statusRunningContainer = const Color(0xFFE0F2FE);
        statusWaitingContainer = const Color(0xFFFEF3C7);
        statusDangerContainer = const Color(0xFFFEE2E2);
        break;

      case AppCanvasTheme.midnightBlack:
        bg = const Color(0xFF000000);
        surface = const Color(0xFF0D0E12);
        surfaceAlt = const Color(0xFF14161D);
        border = const Color(0xFF222328);
        text = const Color(0xFFF4EDE2);
        textSecondary = const Color(0xFFA1A1AA);
        statusSuccessContainer = const Color(0xFF052E16);
        statusRunningContainer = const Color(0xFF082F49);
        statusWaitingContainer = const Color(0xFF451A03);
        statusDangerContainer = const Color(0xFF450A0A);
        break;

      case AppCanvasTheme.claudeWarm:
        bg = const Color(0xFF181715);
        surface = const Color(0xFF22201D);
        surfaceAlt = const Color(0xFF2C2925);
        border = const Color(0xFF3D3832);
        text = const Color(0xFFF4EDE2);
        textSecondary = const Color(0xFFA89F91);
        statusSuccessContainer = const Color(0xFF1B3820);
        statusRunningContainer = const Color(0xFF1A3347);
        statusWaitingContainer = const Color(0xFF3D2A12);
        statusDangerContainer = const Color(0xFF421B1B);
        break;

      case AppCanvasTheme.claudeDeep:
        bg = const Color(0xFF141413);
        surface = const Color(0xFF1D1C1B);
        surfaceAlt = const Color(0xFF262523);
        border = const Color(0xFF33312E);
        text = const Color(0xFFF4EDE2);
        textSecondary = const Color(0xFF9E9689);
        statusSuccessContainer = const Color(0xFF16331A);
        statusRunningContainer = const Color(0xFF142E40);
        statusWaitingContainer = const Color(0xFF38250F);
        statusDangerContainer = const Color(0xFF3B1717);
        break;
    }

    // 2. Resolve Accent Palette Tokens (Buttons, Highlights, Badges ONLY)
    late final Color brand;
    late final Color onBrand;
    late final Color accentColor;
    late final Color statusSuccess;
    late final Color statusRunning;
    late final Color statusWaiting;
    late final Color statusDanger;

    switch (accent) {
      case AppAccentPalette.limeGreen:
        brand = canvas == AppCanvasTheme.pureWhite ? const Color(0xFF4D6600) : const Color(0xFFC6FF00);
        onBrand = canvas == AppCanvasTheme.pureWhite ? const Color(0xFFFFFFFF) : const Color(0xFF000000);
        accentColor = const Color(0xFFC6FF00);
        statusSuccess = const Color(0xFFC6FF00);
        statusRunning = const Color(0xFFC6FF00);
        statusWaiting = const Color(0xFFFFB547);
        statusDanger = const Color(0xFFFF6565);
        break;

      case AppAccentPalette.skyBlue:
        brand = const Color(0xFF38BDF8);
        onBrand = const Color(0xFF000000);
        accentColor = const Color(0xFF38BDF8);
        statusSuccess = const Color(0xFF34D399);
        statusRunning = const Color(0xFF38BDF8);
        statusWaiting = const Color(0xFFFBBF24);
        statusDanger = const Color(0xFFF87171);
        break;

      case AppAccentPalette.claudeOrange:
        brand = const Color(0xFFD97757); // Exact Terracotta Orange
        onBrand = const Color(0xFFFFFFFF);
        accentColor = const Color(0xFFD97757);
        statusSuccess = const Color(0xFF4ADE80);
        statusRunning = const Color(0xFFD97757);
        statusWaiting = const Color(0xFFFBBF24);
        statusDanger = const Color(0xFFF87171);
        break;
    }

    return AppColorsExtension(
      bg: bg,
      surface: surface,
      surfaceAlt: surfaceAlt,
      border: border,
      text: text,
      textSecondary: textSecondary,
      brand: brand,
      onBrand: onBrand,
      accent: accentColor,
      statusSuccess: statusSuccess,
      statusSuccessContainer: statusSuccessContainer,
      statusRunning: statusRunning,
      statusRunningContainer: statusRunningContainer,
      statusWaiting: statusWaiting,
      statusWaitingContainer: statusWaitingContainer,
      statusDanger: statusDanger,
      statusDangerContainer: statusDangerContainer,
    );
  }

  // Backward compatible presets
  static const light = AppColorsExtension(
    bg: Color(0xFFFFFFFF),
    surface: Color(0xFFF4F4F5),
    surfaceAlt: Color(0xFFE4E4E7),
    border: Color(0xFFE4E4E7),
    text: Color(0xFF09090B),
    textSecondary: Color(0xFF71717A),
    brand: Color(0xFF4D6600),
    onBrand: Color(0xFFFFFFFF),
    accent: Color(0xFFC6FF00),
    statusSuccess: Color(0xFF385800),
    statusSuccessContainer: Color(0xFFDCFCE7),
    statusRunning: Color(0xFF4D6600),
    statusRunningContainer: Color(0xFFE0F2FE),
    statusWaiting: Color(0xFFD97706),
    statusWaitingContainer: Color(0xFFFEF3C7),
    statusDanger: Color(0xFFDC2626),
    statusDangerContainer: Color(0xFFFEE2E2),
  );

  static const dark = AppColorsExtension(
    bg: Color(0xFF000000),
    surface: Color(0xFF09090B),
    surfaceAlt: Color(0xFF18181B),
    border: Color(0xFF27272A),
    text: Color(0xFFFFFFFF),
    textSecondary: Color(0xFFA1A1AA),
    brand: Color(0xFFC6FF00),
    onBrand: Color(0xFF000000),
    accent: Color(0xFFC6FF00),
    statusSuccess: Color(0xFFC6FF00),
    statusSuccessContainer: Color(0xFF052E16),
    statusRunning: Color(0xFFC6FF00),
    statusRunningContainer: Color(0xFF082F49),
    statusWaiting: Color(0xFFFFB547),
    statusWaitingContainer: Color(0xFF451A03),
    statusDanger: Color(0xFFFF6565),
    statusDangerContainer: Color(0xFF450A0A),
  );

  @override
  AppColorsExtension copyWith({
    Color? bg,
    Color? surface,
    Color? surfaceAlt,
    Color? border,
    Color? text,
    Color? textSecondary,
    Color? brand,
    Color? onBrand,
    Color? accent,
    Color? statusSuccess,
    Color? statusSuccessContainer,
    Color? statusRunning,
    Color? statusRunningContainer,
    Color? statusWaiting,
    Color? statusWaitingContainer,
    Color? statusDanger,
    Color? statusDangerContainer,
  }) {
    return AppColorsExtension(
      bg: bg ?? this.bg,
      surface: surface ?? this.surface,
      surfaceAlt: surfaceAlt ?? this.surfaceAlt,
      border: border ?? this.border,
      text: text ?? this.text,
      textSecondary: textSecondary ?? this.textSecondary,
      brand: brand ?? this.brand,
      onBrand: onBrand ?? this.onBrand,
      accent: accent ?? this.accent,
      statusSuccess: statusSuccess ?? this.statusSuccess,
      statusSuccessContainer: statusSuccessContainer ?? this.statusSuccessContainer,
      statusRunning: statusRunning ?? this.statusRunning,
      statusRunningContainer: statusRunningContainer ?? this.statusRunningContainer,
      statusWaiting: statusWaiting ?? this.statusWaiting,
      statusWaitingContainer: statusWaitingContainer ?? this.statusWaitingContainer,
      statusDanger: statusDanger ?? this.statusDanger,
      statusDangerContainer: statusDangerContainer ?? this.statusDangerContainer,
    );
  }

  @override
  AppColorsExtension lerp(ThemeExtension<AppColorsExtension>? other, double t) {
    if (other is! AppColorsExtension) return this;
    return AppColorsExtension(
      bg: Color.lerp(bg, other.bg, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      surfaceAlt: Color.lerp(surfaceAlt, other.surfaceAlt, t)!,
      border: Color.lerp(border, other.border, t)!,
      text: Color.lerp(text, other.text, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      brand: Color.lerp(brand, other.brand, t)!,
      onBrand: Color.lerp(onBrand, other.onBrand, t)!,
      accent: Color.lerp(accent, other.accent, t)!,
      statusSuccess: Color.lerp(statusSuccess, other.statusSuccess, t)!,
      statusSuccessContainer: Color.lerp(statusSuccessContainer, other.statusSuccessContainer, t)!,
      statusRunning: Color.lerp(statusRunning, other.statusRunning, t)!,
      statusRunningContainer: Color.lerp(statusRunningContainer, other.statusRunningContainer, t)!,
      statusWaiting: Color.lerp(statusWaiting, other.statusWaiting, t)!,
      statusWaitingContainer: Color.lerp(statusWaitingContainer, other.statusWaitingContainer, t)!,
      statusDanger: Color.lerp(statusDanger, other.statusDanger, t)!,
      statusDangerContainer: Color.lerp(statusDangerContainer, other.statusDangerContainer, t)!,
    );
  }
}

extension AppColorsExtensionHelper on BuildContext {
  AppColorsExtension get colors =>
      Theme.of(this).extension<AppColorsExtension>() ?? AppColorsExtension.dark;
}
