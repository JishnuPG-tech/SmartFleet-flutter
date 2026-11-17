import "package:flutter/material.dart";

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

  static const light = AppColorsExtension(
    bg: Color(0xFFFFFFFF),
    surface: Color(0xFFF5F6F2),
    surfaceAlt: Color(0xFFEBEDE7),
    border: Color(0xFFE1E4DC),
    text: Color(0xFF111111),
    textSecondary: Color(0xFF555B52),
    brand: Color(0xFF526B00),
    onBrand: Color(0xFFFFFFFF),
    accent: Color(0xFFC6FF00),
    statusSuccess: Color(0xFF385800),
    statusSuccessContainer: Color(0xFFEBF5D8),
    statusRunning: Color(0xFF526B00),
    statusRunningContainer: Color(0xFFEBF5D8),
    statusWaiting: Color(0xFF895000),
    statusWaitingContainer: Color(0xFFFDF1D8),
    statusDanger: Color(0xFFB42318),
    statusDangerContainer: Color(0xFFFEE4E2),
  );

  static const dark = AppColorsExtension(
    bg: Color(0xFF080A08),
    surface: Color(0xFF111411),
    surfaceAlt: Color(0xFF191D18),
    border: Color(0xFF292E28),
    text: Color(0xFFFFFFFF),
    textSecondary: Color(0xFFB4BBB0),
    brand: Color(0xFFC6FF00),
    onBrand: Color(0xFF080A08),
    accent: Color(0xFFC6FF00),
    statusSuccess: Color(0xFFC6FF00),
    statusSuccessContainer: Color(0xFF182604),
    statusRunning: Color(0xFFC6FF00),
    statusRunningContainer: Color(0xFF182604),
    statusWaiting: Color(0xFFFFB547),
    statusWaitingContainer: Color(0xFF2E1E05),
    statusDanger: Color(0xFFFF6565),
    statusDangerContainer: Color(0xFF2D0F0F),
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

extension AppColorsContext on BuildContext {
  AppColorsExtension get colors =>
      Theme.of(this).extension<AppColorsExtension>() ?? AppColorsExtension.light;
}
