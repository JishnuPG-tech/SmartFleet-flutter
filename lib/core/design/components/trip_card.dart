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

    return Container(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: AppSpacing.cardBorderRadius,
        border: Border.all(color: colors.border, width: 1.0),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: AppSpacing.cardBorderRadius,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Top Row: Trip ID + Status Chip
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      id,
                      style: AppTypography.section(colors.text, fontSize: 15, isNumber: true),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Flexible(
                    child: StatusChipV2(
                      label: statusLabel,
                    icon: statusType == ChipStatusType.success
                        ? Icons.check_circle_rounded
                        : statusType == ChipStatusType.running
                            ? Icons.navigation_rounded
                            : Icons.hourglass_empty_rounded,
                    type: statusType,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // Route: Compact 16-17sp
              Text(
                "$from ➔ $to",
                style: AppTypography.section(colors.text, fontSize: 16),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),

              // Cargo + Plate
              Text(
                "$cargo · ${weightTons.toStringAsFixed(1)}T · $truckPlate",
                style: AppTypography.supporting(colors.textSecondary, fontSize: 13),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),

              // Thin Progress Bar
              if (progressPercent > 0) ...[
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(2),
                  child: LinearProgressIndicator(
                    value: progressPercent.clamp(0.0, 1.0),
                    backgroundColor: colors.surfaceAlt,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      statusType == ChipStatusType.success ? colors.statusSuccess : colors.brand,
                    ),
                    minHeight: 3.5,
                  ),
                ),
                if (distanceDoneText.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    distanceDoneText,
                    style: AppTypography.supporting(colors.textSecondary, fontSize: 12, isNumber: true),
                  ),
                ],
              ],
            ],
          ),
        ),
      ),
    );
  }
}
