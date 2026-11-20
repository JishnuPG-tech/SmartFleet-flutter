import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "../tokens/app_colors.dart";
import "../tokens/app_typography.dart";
import "../tokens/app_spacing.dart";
import "theme_controller.dart";

class AppThemeV2 {
  static ThemeData buildTheme(
    Brightness brightness, {
    AppCanvasTheme? canvas,
    AppAccentPalette palette = AppAccentPalette.limeGreen,
  }) {
    // If canvas is explicitly supplied, use it; otherwise deduce from brightness
    final effectiveCanvas = canvas ??
        (brightness == Brightness.light ? AppCanvasTheme.pureWhite : AppCanvasTheme.midnightBlack);

    final colors = AppColorsExtension.resolve(
      canvas: effectiveCanvas,
      accent: palette,
    );

    final isDark = effectiveCanvas != AppCanvasTheme.pureWhite;
    final resolvedBrightness = isDark ? Brightness.dark : Brightness.light;

    return ThemeData(
      useMaterial3: true,
      brightness: resolvedBrightness,
      scaffoldBackgroundColor: colors.bg,
      colorScheme: ColorScheme(
        brightness: resolvedBrightness,
        primary: colors.brand,
        onPrimary: colors.onBrand,
        secondary: colors.brand,
        onSecondary: colors.onBrand,
        error: colors.statusDanger,
        onError: Colors.white,
        surface: colors.surface,
        onSurface: colors.text,
      ),
      extensions: [colors],
      appBarTheme: AppBarTheme(
        backgroundColor: colors.bg,
        foregroundColor: colors.text,
        surfaceTintColor: Colors.transparent,
        scrolledUnderElevation: 0,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: AppTypography.title(colors.text, fontSize: 24),
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
          systemNavigationBarColor: colors.surface,
          systemNavigationBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
        ),
      ),
      cardTheme: CardThemeData(
        color: colors.surface,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: AppSpacing.cardBorderRadius,
          side: BorderSide(color: colors.border, width: 1.0),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colors.brand,
          foregroundColor: colors.onBrand,
          minimumSize: const Size.fromHeight(52),
          shape: RoundedRectangleBorder(
            borderRadius: AppSpacing.buttonBorderRadius,
          ),
          textStyle: AppTypography.button(colors.onBrand),
          elevation: 0,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: colors.text,
          minimumSize: const Size.fromHeight(52),
          side: BorderSide(color: colors.border, width: 1.0),
          shape: RoundedRectangleBorder(
            borderRadius: AppSpacing.buttonBorderRadius,
          ),
          textStyle: AppTypography.button(colors.text),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: colors.surface,
        indicatorColor: isDark ? colors.brand.withValues(alpha: 0.18) : colors.brand.withValues(alpha: 0.12),
        elevation: 0,
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return IconThemeData(color: colors.brand, size: 24);
          }
          return IconThemeData(color: colors.textSecondary, size: 24);
        }),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppTypography.supporting(colors.brand).copyWith(
              fontWeight: FontWeight.w700,
              fontSize: 12,
            );
          }
          return AppTypography.supporting(colors.textSecondary).copyWith(
            fontWeight: FontWeight.w500,
            fontSize: 12,
          );
        }),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: colors.surface,
        selectedItemColor: colors.brand,
        unselectedItemColor: colors.textSecondary,
        elevation: 0,
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle: AppTypography.supporting(colors.brand).copyWith(
          fontWeight: FontWeight.w700,
          fontSize: 12,
        ),
        unselectedLabelStyle: AppTypography.supporting(colors.textSecondary).copyWith(
          fontWeight: FontWeight.w500,
          fontSize: 12,
        ),
      ),
      dividerTheme: DividerThemeData(
        color: colors.border,
        thickness: 1.0,
        space: 1.0,
      ),
    );
  }
}
