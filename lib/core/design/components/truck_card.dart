import "package:flutter/material.dart";
import "../tokens/app_colors.dart";
import "../tokens/app_typography.dart";
import "../tokens/app_spacing.dart";
import "status_chip.dart";

enum TruckStatusType { available, onTrip, inWorkshop }

class TruckCard extends StatelessWidget {
  final String plate;
  final String model;
  final double capacityTons;
  final TruckStatusType status;
  final String? driverName;
  final VoidCallback? onTap;

  const TruckCard({
    super.key,
    required this.plate,
    required this.model,
    required this.capacityTons,
    required this.status,
    this.driverName,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    Widget chip;
    switch (status) {
      case TruckStatusType.available:
        chip = StatusChipV2.success(label: "Available");
        break;
      case TruckStatusType.onTrip:
        chip = StatusChipV2.running(label: "On trip");
        break;
      case TruckStatusType.inWorkshop:
        chip = StatusChipV2.danger(label: "Service");
        break;
    }

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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    plate,
                    style: AppTypography.section(colors.text, fontSize: 16, isNumber: true),
                  ),
                  chip,
                ],
              ),
              const SizedBox(height: 6),
              Text(
                "$model · ${capacityTons.toStringAsFixed(0)}T",
                style: AppTypography.supporting(colors.textSecondary, fontSize: 13),
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  Icon(
                    Icons.person_outline_rounded,
                    size: 16,
                    color: driverName != null ? colors.brand : colors.textSecondary,
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      driverName != null && driverName!.isNotEmpty
                          ? "Driver: $driverName"
                          : "Unassigned",
                      style: AppTypography.supporting(
                        driverName != null ? colors.text : colors.textSecondary,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
