import 'package:flutter/material.dart';
import 'package:smartfleet_flutter/core/components/lucide_compat.dart';
import '../models/fleet_models.dart';
import '../theme/app_colors.dart';
import 'status_badge.dart';

class CompactShipmentCard extends StatelessWidget {
  final Trip trip;
  final VoidCallback? onTap;

  const CompactShipmentCard({
    super.key,
    required this.trip,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Color statusColor;
    String statusLabel;
    switch (trip.status) {
      case TripStatus.active:
        statusColor = AppColors.accent;
        statusLabel = 'In Transit';
        break;
      case TripStatus.assigned:
        statusColor = AppColors.blue;
        statusLabel = 'Assigned';
        break;
      case TripStatus.completed:
        statusColor = AppColors.green;
        statusLabel = 'Delivered';
        break;
      case TripStatus.pending:
        statusColor = AppColors.orange;
        statusLabel = 'Pending';
        break;
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.cardCharcoal,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.hairline, width: 0.8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top ID & Status
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(LucideIcons.package, size: 14, color: AppColors.mutedGray),
                    const SizedBox(width: 6),
                    Text(
                      'Shipment #${trip.tripNumber}',
                      style: const TextStyle(
                        color: AppColors.mutedGray,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'monospace',
                      ),
                    ),
                  ],
                ),
                StatusBadge(label: statusLabel, color: statusColor),
              ],
            ),
            const SizedBox(height: 10),

            // Route Destination
            Row(
              children: [
                Expanded(
                  child: Text(
                    '${trip.originCity} → ${trip.destCity}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: AppColors.pureWhite,
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -0.3,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  trip.eta,
                  style: TextStyle(
                    color: statusColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),

            // Truck & Payload details
            Text(
              '${trip.vehiclePlate} · ${trip.cargoWeight} · ${trip.cargoTitle}',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: AppColors.mutedGray,
                fontSize: 11,
              ),
            ),
            const SizedBox(height: 10),

            // Progress bar
            Row(
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(3),
                    child: LinearProgressIndicator(
                      value: trip.progress,
                      minHeight: 4,
                      backgroundColor: Colors.white.withOpacity(0.08),
                      valueColor: AlwaysStoppedAnimation<Color>(statusColor),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  '${(trip.progress * 100).toInt()}%',
                  style: const TextStyle(
                    color: AppColors.mutedGray,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'monospace',
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
