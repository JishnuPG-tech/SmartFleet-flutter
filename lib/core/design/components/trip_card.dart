import "package:flutter/material.dart";
import "../tokens/app_colors.dart";
import "../tokens/app_typography.dart";
import "../tokens/app_spacing.dart";
import "status_chip.dart";

class TripCard extends StatelessWidget {
  final String id;
  final String from;
  final String to;
  final String cargo;
  final double weightTons;
  final String truckPlate;
  final ChipStatusType statusType;
  final String statusLabel;
  final double progressPercent;
  final String distanceDoneText;
  final VoidCallback? onTap;

  const TripCard({
    super.key,
    required this.id,
    required this.from,
    required this.to,
    required this.cargo,
    required this.weightTons,
    required this.truckPlate,
    required this.statusType,
    required this.statusLabel,
    this.progressPercent = 0.0,
    this.distanceDoneText = "",
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Hero(
      tag: "trip_card_$id",
      child: Card(
        child: InkWell(
          onTap: onTap,
          borderRadius: AppSpacing.cardBorderRadius,
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Row: Trip ID + Status Chip
                Wrap(
                  alignment: WrapAlignment.spaceBetween,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    Text(
                      id,
                      style: AppTypography.heading(colors.text, isNumber: true),
                    ),
                    StatusChipV2(
                      label: statusLabel,
                      icon: statusType == ChipStatusType.success
                          ? Icons.check_circle_rounded
                          : statusType == ChipStatusType.running
                              ? Icons.navigation_rounded
                              : Icons.hourglass_empty_rounded,
                      type: statusType,
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Route
                Text(
                  "$from ➔ $to",
                  style: AppTypography.heading(colors.text),
                  maxLines: 2,
                  overflow: TextOverflow.visible,
                ),
                const SizedBox(height: 6),

                // Cargo + Plate
                Text(
                  "$cargo · ${weightTons.toStringAsFixed(1)}T · $truckPlate",
                  style: AppTypography.body(colors.textSecondary),
                ),

                // Animated Progress Bar if running or delivered
                if (progressPercent > 0) ...[
                  const SizedBox(height: 14),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: TweenAnimationBuilder<double>(
                      duration: const Duration(milliseconds: 400),
                      curve: Curves.easeOutCubic,
                      tween: Tween<double>(begin: 0, end: progressPercent.clamp(0.0, 1.0)),
                      builder: (context, value, _) {
                        return LinearProgressIndicator(
                          value: value,
                          backgroundColor: colors.surfaceAlt,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            statusType == ChipStatusType.success ? colors.statusSuccess : colors.brand,
                          ),
                          minHeight: 8,
                        );
                      },
                    ),
                  ),
                  if (distanceDoneText.isNotEmpty) ...[
                    const SizedBox(height: 6),
                    Text(
                      distanceDoneText,
                      style: AppTypography.label(colors.textSecondary, isNumber: true),
                    ),
                  ],
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
