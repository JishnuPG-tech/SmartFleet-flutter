import "package:flutter/material.dart";

class AppMotion {
  static const Duration fast = Duration(milliseconds: 150);
  static const Duration base = Duration(milliseconds: 250);
  static const Duration slow = Duration(milliseconds: 400);

  static const Curve enterCurve = Curves.easeOutCubic;
  static const Curve exitCurve = Curves.easeInCubic;

  static Duration getDuration(BuildContext context, Duration standard) {
    if (MediaQuery.of(context).disableAnimations) {
      return Duration.zero;
    }
    return standard;
  }
}
