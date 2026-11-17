import "package:flutter/material.dart";

class AppTypography {
  static const String fontInter = "Inter";
  static const String fontMalayalam = "NotoSansMalayalam";

  static TextStyle _baseStyle({
    required double fontSize,
    required FontWeight fontWeight,
    required Color color,
    double height = 1.4,
    bool isMalayalam = false,
    bool isNumber = false,
  }) {
    return TextStyle(
      fontFamily: isMalayalam ? fontMalayalam : fontInter,
      fontFamilyFallback: isMalayalam ? const [fontInter] : const [fontMalayalam],
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      height: isMalayalam ? (height < 1.55 ? 1.55 : height) : height,
      fontFeatures: isNumber ? const [FontFeature.tabularFigures()] : null,
    );
  }

  // Display 32/700
  static TextStyle display(Color color, {bool isMalayalam = false, bool isNumber = false}) =>
      _baseStyle(
        fontSize: 32,
        fontWeight: FontWeight.w700,
        color: color,
        height: 1.25,
        isMalayalam: isMalayalam,
        isNumber: isNumber,
      );

  // Title 24/700
  static TextStyle title(Color color, {bool isMalayalam = false, bool isNumber = false}) =>
      _baseStyle(
        fontSize: 24,
        fontWeight: FontWeight.w700,
        color: color,
        height: 1.3,
        isMalayalam: isMalayalam,
        isNumber: isNumber,
      );

  // Heading 20/600
  static TextStyle heading(Color color, {bool isMalayalam = false, bool isNumber = false}) =>
      _baseStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: color,
        height: 1.35,
        isMalayalam: isMalayalam,
        isNumber: isNumber,
      );

  // Body 18/400 (Minimum body size)
  static TextStyle body(Color color, {bool isMalayalam = false, bool isNumber = false}) =>
      _baseStyle(
        fontSize: 18,
        fontWeight: FontWeight.w400,
        color: color,
        height: 1.45,
        isMalayalam: isMalayalam,
        isNumber: isNumber,
      );

  // Label 16/600 (Absolute minimum size in the app)
  static TextStyle label(Color color, {bool isMalayalam = false, bool isNumber = false}) =>
      _baseStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: color,
        height: 1.4,
        isMalayalam: isMalayalam,
        isNumber: isNumber,
      );
}
