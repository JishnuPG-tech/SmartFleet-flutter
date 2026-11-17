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
        chip = StatusChipV2.danger(label: "In workshop");
        break;
    }

    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: AppSpacing.cardBorderRadius,
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Plate + Status Chip
              Wrap(
                alignment: WrapAlignment.spaceBetween,
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: 8,
                runSpacing: 8,
                children: [
                  Text(
                    plate,
                    style: AppTypography.heading(colors.text, isNumber: true),
                  ),
                  chip,
                ],
              ),
              const SizedBox(height: 12),

              // Model & Capacity
              Text(
                "$model · ${capacityTons.toStringAsFixed(0)}T Capacity",
                style: AppTypography.heading(colors.text),
              ),
              const SizedBox(height: 6),

              // Driver Name
              Row(
                children: [
                  Icon(
                    Icons.person_outline_rounded,
                    size: 20,
                    color: driverName != null ? colors.brand : colors.textSecondary,
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      driverName != null && driverName!.isNotEmpty
                          ? "Driver: $driverName"
                          : "No driver currently assigned",
                      style: AppTypography.body(
                        driverName != null ? colors.text : colors.textSecondary,
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
