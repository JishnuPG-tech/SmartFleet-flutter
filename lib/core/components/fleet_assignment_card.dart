import "package:flutter/material.dart";
import "../design/tokens/app_colors.dart";
import "../design/tokens/app_typography.dart";
import "../design/tokens/app_spacing.dart";
import "fleet_status_badge.dart";

class FleetAssignmentCard extends StatelessWidget {
  final String tripNumber;
  final String originCity;
  final String destCity;
  final String cargoTitle;
  final String cargoWeight;
  final String vehiclePlate;
  final String driverName;
  final String eta;
  final FleetOperationalStatus status;
  final VoidCallback? onTap;

  const FleetAssignmentCard({
    super.key,
    required this.tripNumber,
    required this.originCity,
    required this.destCity,
    required this.cargoTitle,
    required this.cargoWeight,
    required this.vehiclePlate,
    required this.driverName,
    required this.eta,
    this.status = FleetOperationalStatus.running,
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
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: AppSpacing.cardBorderRadius,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      tripNumber,
                      style: AppTypography.mono(colors.textSecondary, fontSize: 13, fontWeight: FontWeight.w700),
                    ),
                    FleetStatusBadge(status: status),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("FROM", style: AppTypography.caption(colors.textSecondary)),
                          Text(originCity, style: AppTypography.heading(colors.text)),
                        ],
                      ),
                    ),
                    Icon(Icons.arrow_forward_rounded, color: colors.brand, size: 22),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text("TO", style: AppTypography.caption(colors.textSecondary)),
                          Text(destCity, style: AppTypography.heading(colors.text)),
                        ],
                      ),
                    ),
                  ],
                ),
                const Divider(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.local_shipping_outlined, size: 16, color: colors.textSecondary),
                        const SizedBox(width: 6),
                        Text(vehiclePlate, style: AppTypography.mono(colors.text, fontSize: 13)),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(Icons.timer_outlined, size: 16, color: colors.brand),
                        const SizedBox(width: 6),
                        Text(eta, style: AppTypography.number(colors.brand, fontSize: 13)),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
