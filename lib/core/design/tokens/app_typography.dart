import "package:flutter/material.dart";

class AppTypography {
  static const String fontInter = "Inter";
  static const String fontMalayalam = "NotoSansMalayalam";

  static TextStyle _baseStyle({
    required double fontSize,
    required FontWeight fontWeight,
    required Color color,
    double height = 1.35,
    bool isMalayalam = false,
    bool isNumber = false,
  }) {
    return TextStyle(
      fontFamily: isMalayalam ? fontMalayalam : fontInter,
      fontFamilyFallback: isMalayalam ? const [fontInter] : const [fontMalayalam],
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      height: isMalayalam ? (height < 1.5 ? 1.5 : height) : height,
      fontFeatures: isNumber ? const [FontFeature.tabularFigures()] : null,
    );
  }

  // Operational Main Values: 28-32 sp (Bold)
  static TextStyle value(Color color, {double fontSize = 28, bool isMalayalam = false, bool isNumber = true}) =>
      _baseStyle(
        fontSize: fontSize,
        fontWeight: FontWeight.w700,
        color: color,
        height: 1.2,
        isMalayalam: isMalayalam,
        isNumber: isNumber,
      );

  // Tabular Numbers for Speedometer, Telemetry, and Counters
  static TextStyle number(Color color, {double fontSize = 16, FontWeight fontWeight = FontWeight.w700}) =>
      _baseStyle(
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: color,
        isNumber: true,
      );

  // Screen Title: 24-28 sp (Bold)
  static TextStyle title(Color color, {double fontSize = 24, bool isMalayalam = false, bool isNumber = false}) =>
      _baseStyle(
        fontSize: fontSize,
        fontWeight: FontWeight.w700,
        color: color,
        height: 1.25,
        isMalayalam: isMalayalam,
        isNumber: isNumber,
      );

  // Section Headings: 16-18 sp (SemiBold)
  static TextStyle section(Color color, {double fontSize = 16, bool isMalayalam = false, bool isNumber = false}) =>
      _baseStyle(
        fontSize: fontSize,
        fontWeight: FontWeight.w600,
        color: color,
        height: 1.3,
        isMalayalam: isMalayalam,
        isNumber: isNumber,
      );

  // Heading alias for backward-compatibility
  static TextStyle heading(Color color, {bool isMalayalam = false, bool isNumber = false}) =>
      section(color, fontSize: 18, isMalayalam: isMalayalam, isNumber: isNumber);

  // Display alias
  static TextStyle display(Color color, {bool isMalayalam = false, bool isNumber = false}) =>
      value(color, fontSize: 28, isMalayalam: isMalayalam, isNumber: isNumber);

  // Primary Body: 16-18 sp (Medium/Regular)
  static TextStyle body(Color color, {double fontSize = 16, bool isMalayalam = false, bool isNumber = false}) =>
      _baseStyle(
        fontSize: fontSize,
        fontWeight: FontWeight.w400,
        color: color,
        height: 1.4,
        isMalayalam: isMalayalam,
        isNumber: isNumber,
      );

  // Supporting / Meta Text: 14-16 sp (Regular)
  static TextStyle supporting(Color color, {double fontSize = 14, bool isMalayalam = false, bool isNumber = false}) =>
      _baseStyle(
        fontSize: fontSize,
        fontWeight: FontWeight.w400,
        color: color,
        height: 1.35,
        isMalayalam: isMalayalam,
        isNumber: isNumber,
      );

  // Label: 14-16 sp (SemiBold)
  static TextStyle label(Color color, {double fontSize = 14, bool isMalayalam = false, bool isNumber = false}) =>
      _baseStyle(
        fontSize: fontSize,
        fontWeight: FontWeight.w600,
        color: color,
        height: 1.3,
        isMalayalam: isMalayalam,
        isNumber: isNumber,
      );

  // Buttons: 16-18 sp (SemiBold)
  static TextStyle button(Color color, {double fontSize = 16, bool isMalayalam = false}) =>
      _baseStyle(
        fontSize: fontSize,
        fontWeight: FontWeight.w600,
        color: color,
        height: 1.25,
        isMalayalam: isMalayalam,
      );
}
