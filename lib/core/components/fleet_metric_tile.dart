import "package:flutter/material.dart";
import "../design/tokens/app_colors.dart";
import "../design/tokens/app_typography.dart";
import "../design/tokens/app_spacing.dart";

class FleetMetricTile extends StatelessWidget {
  final String label;
  final String value;
  final String? unit;
  final IconData? icon;
  final Color? accentColor;

  const FleetMetricTile({
    super.key,
    required this.label,
    required this.value,
    this.unit,
    this.icon,
    this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final accent = accentColor ?? colors.brand;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: AppSpacing.cardBorderRadius,
        border: Border.all(color: colors.border, width: 1.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label, style: AppTypography.caption(colors.textSecondary)),
              if (icon != null) Icon(icon, size: 18, color: accent),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(value, style: AppTypography.number(colors.text, fontSize: 26)),
              if (unit != null) ...[
                const SizedBox(width: 4),
                Text(unit!, style: AppTypography.caption(colors.textSecondary)),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
