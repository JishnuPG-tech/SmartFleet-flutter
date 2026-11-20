import "package:flutter/material.dart";
import "../tokens/app_colors.dart";
import "../tokens/app_typography.dart";

class SmartFleetLogo extends StatelessWidget {
  final double size;
  final bool showText;

  const SmartFleetLogo({
    super.key,
    this.size = 56.0,
    this.showText = false,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    final emblem = Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(size * 0.28),
        border: Border.all(color: colors.border, width: 1.0),
      ),
      child: Center(
        child: Text(
          "S",
          style: TextStyle(
            fontFamily: "Inter",
            fontSize: size * 0.50,
            fontWeight: FontWeight.w800,
            color: colors.brand,
            letterSpacing: -0.5,
          ),
        ),
      ),
    );

    if (!showText) return emblem;

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        emblem,
        const SizedBox(width: 12),
        Text(
          "SmartFleet",
          style: AppTypography.title(colors.text, fontSize: 20).copyWith(
            fontWeight: FontWeight.w700,
            letterSpacing: -0.6,
          ),
        ),
      ],
    );
  }
}
