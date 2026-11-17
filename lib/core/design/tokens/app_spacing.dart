import "package:flutter/material.dart";

class AppSpacing {
  static const double s4 = 4.0;
  static const double s8 = 8.0;
  static const double s12 = 12.0;
  static const double s16 = 16.0;
  static const double s20 = 20.0;
  static const double s24 = 24.0;
  static const double s32 = 32.0;

  // Precision Radii (Minimalist Swiss / Clean Edge)
  static const double radiusCard = 8.0;
  static const double radiusButton = 8.0;
  static const double radiusChip = 6.0;

  static final BorderRadius cardBorderRadius = BorderRadius.circular(radiusCard);
  static final BorderRadius buttonBorderRadius = BorderRadius.circular(radiusButton);
  static final BorderRadius chipBorderRadius = BorderRadius.circular(radiusChip);

  // Shadows
  static const List<BoxShadow> lightCardShadow = [
    BoxShadow(
      color: Color.fromRGBO(0, 0, 0, 0.04),
      blurRadius: 8.0,
      offset: Offset(0, 2),
    ),
  ];

  static const List<BoxShadow> darkCardShadow = [];
}
