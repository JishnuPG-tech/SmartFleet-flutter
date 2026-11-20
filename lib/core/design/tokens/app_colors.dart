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

  // SKY BLUE PALETTE
  static const lightSky = AppColorsExtension(
    bg: Color(0xFFFFFFFF),
    surface: Color(0xFFF0F9FF),
    surfaceAlt: Color(0xFFE0F2FE),
    border: Color(0xFFBAE6FD),
    text: Color(0xFF0F172A),
    textSecondary: Color(0xFF475569),
    brand: Color(0xFF0284C7),
    onBrand: Color(0xFFFFFFFF),
    accent: Color(0xFF38BDF8),
    statusSuccess: Color(0xFF059669),
    statusSuccessContainer: Color(0xFFD1FAE5),
    statusRunning: Color(0xFF0284C7),
    statusRunningContainer: Color(0xFFE0F2FE),
    statusWaiting: Color(0xFFD97706),
    statusWaitingContainer: Color(0xFFFEF3C7),
    statusDanger: Color(0xFFDC2626),
    statusDangerContainer: Color(0xFFFEE2E2),
  );

  static const darkSky = AppColorsExtension(
    bg: Color(0xFF08090D),
    surface: Color(0xFF11131B),
    surfaceAlt: Color(0xFF171A23),
    border: Color(0xFF1E293B),
    text: Color(0xFFF8FAFC),
    textSecondary: Color(0xFF94A3B8),
    brand: Color(0xFF38BDF8),
    onBrand: Color(0xFF08090D),
    accent: Color(0xFF38BDF8),
    statusSuccess: Color(0xFF34D399),
    statusSuccessContainer: Color(0xFF064E3B),
    statusRunning: Color(0xFF38BDF8),
    statusRunningContainer: Color(0xFF0C4A6E),
    statusWaiting: Color(0xFFFBBF24),
    statusWaitingContainer: Color(0xFF78350F),
    statusDanger: Color(0xFFF87171),
    statusDangerContainer: Color(0xFF7F1D1D),
  );

  // CLAUDE ORANGE PALETTE
  static const lightClaude = AppColorsExtension(
    bg: Color(0xFFFAF9F6),
    surface: Color(0xFFF4EDE2),
    surfaceAlt: Color(0xFFEAE0D1),
    border: Color(0xFFDECFC0),
    text: Color(0xFF1F1A15),
    textSecondary: Color(0xFF6B5E52),
    brand: Color(0xFFC05621),
    onBrand: Color(0xFFFFFFFF),
    accent: Color(0xFFD97757),
    statusSuccess: Color(0xFF2E7D32),
    statusSuccessContainer: Color(0xFFE8F5E9),
    statusRunning: Color(0xFFC05621),
    statusRunningContainer: Color(0xFFFEEBC8),
    statusWaiting: Color(0xFFB7791F),
    statusWaitingContainer: Color(0xFFFEFCBF),
    statusDanger: Color(0xFFC53030),
    statusDangerContainer: Color(0xFFFED7D7),
  );

  static const darkClaude = AppColorsExtension(
    bg: Color(0xFF171512),
    surface: Color(0xFF24201B),
    surfaceAlt: Color(0xFF2B261F),
    border: Color(0xFF3D362C),
    text: Color(0xFFF4EDE2),
    textSecondary: Color(0xFFA99B8A),
    brand: Color(0xFFF2BA93),
    onBrand: Color(0xFF171512),
    accent: Color(0xFFD97757),
    statusSuccess: Color(0xFF81C784),
    statusSuccessContainer: Color(0xFF1B5E20),
    statusRunning: Color(0xFFF2BA93),
    statusRunningContainer: Color(0xFF44261B),
    statusWaiting: Color(0xFFFFD54F),
    statusWaitingContainer: Color(0xFF4A3800),
    statusDanger: Color(0xFFE57373),
    statusDangerContainer: Color(0xFF4C1D1D),
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
