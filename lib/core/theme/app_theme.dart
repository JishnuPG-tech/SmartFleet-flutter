import 'package:flutter/material.dart';

class AppColors {
  // Base light surfaces
  static const Color background = Color(0xFFFFFFFF);
  static const Color surfaceCard = Color(0xFFF4F5F3);
  static const Color border = Color(0xFFD9DCD8);

  // High-contrast text
  static const Color textPrimary = Color(0xFF111111);
  static const Color textSecondary = Color(0xFF3F4541); // Never lighter than this

  // Primary accent (Deep Kerala green)
  static const Color accent = Color(0xFF0B6B3A);
  static const Color textOnAccent = Color(0xFFFFFFFF);

  // Status chip token pairs (Icon + Word, WCAG AA verified >= 4.5:1)
  // Done (Green)
  static const Color statusDoneText = Color(0xFF0B6B3A);
  static const Color statusDoneBg = Color(0xFFE7F5ED);

  // Running (Blue)
  static const Color statusRunningText = Color(0xFF0B5CAD);
  static const Color statusRunningBg = Color(0xFFE6F0FA);

  // Waiting (Amber)
  static const Color statusWaitingText = Color(0xFF8A5A00);
  static const Color statusWaitingBg = Color(0xFFFFF1D6);

  // Problem / In Workshop (Red)
  static const Color statusProblemText = Color(0xFFB3261E);
  static const Color statusProblemBg = Color(0xFFFCEBEA);
}

class AppTheme {
  static const String fontPrimary = 'NotoSans';
  static const String fontMalayalam = 'NotoSansMalayalam';

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: AppColors.background,
      fontFamily: fontPrimary,
      fontFamilyFallback: const [fontMalayalam],
      
      colorScheme: const ColorScheme.light(
        surface: AppColors.background,
        primary: AppColors.accent,
        onPrimary: AppColors.textOnAccent,
        onSurface: AppColors.textPrimary,
        outline: AppColors.border,
      ),

      // Card theme with no shadows, clean borders, minimal design
      cardTheme: CardThemeData(
        color: AppColors.surfaceCard,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: const BorderSide(color: AppColors.border, width: 1.5),
        ),
      ),

      // App bar theme
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          color: AppColors.textPrimary,
          fontSize: 24,
          fontWeight: FontWeight.w700,
          fontFamily: fontPrimary,
          fontFamilyFallback: [fontMalayalam],
        ),
      ),

      // Standard buttons: minimum 56dp high, full width, radius 14
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.accent,
          foregroundColor: AppColors.textOnAccent,
          minimumSize: const Size.fromHeight(56),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            fontFamily: fontPrimary,
            fontFamilyFallback: [fontMalayalam],
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        ),
      ),

      // Outlined buttons
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.textPrimary,
          minimumSize: const Size.fromHeight(56),
          side: const BorderSide(color: AppColors.border, width: 2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            fontFamily: fontPrimary,
            fontFamilyFallback: [fontMalayalam],
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        ),
      ),

      // Text Button
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.textSecondary,
          minimumSize: const Size(48, 48),
          textStyle: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            fontFamily: fontPrimary,
            fontFamilyFallback: [fontMalayalam],
          ),
        ),
      ),

      // Bottom Navigation: Always show icon + label on every tab
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.background,
        selectedItemColor: AppColors.accent,
        unselectedItemColor: AppColors.textSecondary,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        selectedLabelStyle: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w700,
          fontFamily: fontPrimary,
          fontFamilyFallback: [fontMalayalam],
        ),
        unselectedLabelStyle: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          fontFamily: fontPrimary,
          fontFamilyFallback: [fontMalayalam],
        ),
      ),

      // Text typography: Strictly no text below 16sp
      textTheme: const TextTheme(
        // Key numbers
        displayLarge: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.w800,
          color: AppColors.textPrimary,
          fontFamily: fontPrimary,
          fontFamilyFallback: [fontMalayalam],
        ),
        // Screen titles
        titleLarge: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w700,
          color: AppColors.textPrimary,
          fontFamily: fontPrimary,
          fontFamilyFallback: [fontMalayalam],
        ),
        // Section titles & card headers
        titleMedium: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: AppColors.textPrimary,
          fontFamily: fontPrimary,
          fontFamilyFallback: [fontMalayalam],
        ),
        // Primary body text (min 18sp)
        bodyLarge: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w500,
          color: AppColors.textPrimary,
          height: 1.4,
          fontFamily: fontPrimary,
          fontFamilyFallback: [fontMalayalam],
        ),
        // Secondary body text (min 16sp)
        bodyMedium: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: AppColors.textSecondary,
          height: 1.4,
          fontFamily: fontPrimary,
          fontFamilyFallback: [fontMalayalam],
        ),
        // Labels & chips (min 16sp)
        labelLarge: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w700,
          color: AppColors.textPrimary,
          fontFamily: fontPrimary,
          fontFamilyFallback: [fontMalayalam],
        ),
      ),
    );
  }
}
