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
    bg: Color(0xFFF6F7F9),
    surface: Color(0xFFFFFFFF),
    surfaceAlt: Color(0xFFEEF0F3),
    border: Color(0xFFDDE1E6),
    text: Color(0xFF0E1116),
    textSecondary: Color(0xFF46505C),
    brand: Color(0xFF1F4BDB),
    onBrand: Color(0xFFFFFFFF),
    statusSuccess: Color(0xFF0B6E3A),
    statusSuccessContainer: Color(0xFFE7F7EE),
    statusRunning: Color(0xFF1F4BDB),
    statusRunningContainer: Color(0xFFEDF2FE),
    statusWaiting: Color(0xFF8D5300),
    statusWaitingContainer: Color(0xFFFEF6E7),
    statusDanger: Color(0xFFC62828),
    statusDangerContainer: Color(0xFFFDE8E8),
  );

  static const dark = AppColorsExtension(
    bg: Color(0xFF0E1116),
    surface: Color(0xFF161B22),
    surfaceAlt: Color(0xFF1E252E),
    border: Color(0xFF2A323D),
    text: Color(0xFFF2F4F7),
    textSecondary: Color(0xFFAAB3BF),
    brand: Color(0xFF6C8DFF),
    onBrand: Color(0xFF0A0F1F),
    statusSuccess: Color(0xFF3DD68C),
    statusSuccessContainer: Color(0xFF0C2B1C),
    statusRunning: Color(0xFF6C8DFF),
    statusRunningContainer: Color(0xFF162244),
    statusWaiting: Color(0xFFFFB84D),
    statusWaitingContainer: Color(0xFF362100),
    statusDanger: Color(0xFFFF6B6B),
    statusDangerContainer: Color(0xFF3B0D0D),
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
