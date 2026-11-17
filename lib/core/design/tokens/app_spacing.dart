import "package:flutter/material.dart";

class AppSpacing {
  static const double s4 = 4.0;
  static const double s8 = 8.0;
  static const double s12 = 12.0;
  static const double s16 = 16.0;
  static const double s24 = 24.0;
  static const double s32 = 32.0;

  // Radii
  static const double radiusCard = 16.0;
  static const double radiusButton = 14.0;
  static const double radiusChip = 999.0;

  static final BorderRadius cardBorderRadius = BorderRadius.circular(radiusCard);
  static final BorderRadius buttonBorderRadius = BorderRadius.circular(radiusButton);
  static final BorderRadius chipBorderRadius = BorderRadius.circular(radiusChip);

  // Shadows
  static const List<BoxShadow> lightCardShadow = [
    BoxShadow(
      color: Color.fromRGBO(0, 0, 0, 0.06),
      blurRadius: 16.0,
      offset: Offset(0, 4),
    ),
  ];

  static const List<BoxShadow> darkCardShadow = [];
}
