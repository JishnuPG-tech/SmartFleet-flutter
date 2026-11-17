import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../models/fleet_models.dart';
import '../theme/app_colors.dart';
import '../../screens/driver/live_tracking_screen.dart';

class ShipmentTrackingDetailSheet extends StatelessWidget {
  final Trip trip;

  const ShipmentTrackingDetailSheet({super.key, required this.trip});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(20, 16, 20, MediaQuery.of(context).viewInsets.bottom + 24),
      decoration: const BoxDecoration(
        color: AppColors.cardCharcoal,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Center Drag Handle
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.hairline,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Header: ID + Status Pill
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Shipment #${trip.tripNumber}',
                      style: const TextStyle(
                        color: AppColors.mutedGray,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'monospace',
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${trip.originCity} → ${trip.destCity}',
                      style: const TextStyle(
                        color: AppColors.pureWhite,
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                        letterSpacing: -0.5,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: AppColors.accent.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppColors.accent.withOpacity(0.4)),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(LucideIcons.truck, size: 12, color: AppColors.accent),
                      SizedBox(width: 4),
                      Text(
                        'IN TRANSIT',
                        style: TextStyle(
                          color: AppColors.accent,
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              '${trip.vehiclePlate} · ${trip.cargoWeight} · ${trip.cargoTitle}',
              style: const TextStyle(
                color: AppColors.mutedGray,
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 18),

            // Metrics Summary Ribbon
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.midnightBlack,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.hairline),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      const Text(
                        '2h 45m',
                        style: TextStyle(
                          color: AppColors.accent,
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
                          fontFamily: 'monospace',
                        ),
                      ),
                      const SizedBox(height: 2),
                      const Text(
                        'Estimated arrival',
                        style: TextStyle(color: AppColors.mutedGray, fontSize: 10),
                      ),
                    ],
                  ),
                  Container(width: 1, height: 32, color: AppColors.border),
                  Column(
                    children: [
                      const Text(
                        '65%',
                        style: TextStyle(
                          color: AppColors.pureWhite,
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
                          fontFamily: 'monospace',
                        ),
                      ),
                      const SizedBox(height: 2),
                      const Text(
                        'Trip completed',
                        style: TextStyle(color: AppColors.mutedGray, fontSize: 10),
                      ),
                    ],
                  ),
                  Container(width: 1, height: 32, color: AppColors.border),
                  Column(
                    children: [
                      const Text(
                        '68 km/h',
                        style: TextStyle(
                          color: AppColors.blue,
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
                          fontFamily: 'monospace',
                        ),
                      ),
                      const SizedBox(height: 2),
                      const Text(
                        'Live speed',
                        style: TextStyle(color: AppColors.mutedGray, fontSize: 10),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Tracking Timeline Section
            const Text(
              'TRACKING TIMELINE',
              style: TextStyle(
                color: AppColors.darkSubtext,
                fontSize: 11,
                fontWeight: FontWeight.w800,
                letterSpacing: 1.0,
              ),
            ),
            const SizedBox(height: 12),

            _buildTimelineStep(
              title: 'Shipment created',
              timestamp: '17 Nov · 08:00 AM',
              location: 'Kochi Port SEZ Logistics Yard',
              isCompleted: true,
            ),
            _buildTimelineStep(
              title: 'Vehicle departed',
              timestamp: '17 Nov · 08:30 AM',
              location: 'Driver Suresh Kumar checked out at gate 2',
              isCompleted: true,
            ),
            _buildTimelineStep(
              title: 'In transit',
              timestamp: 'Current status · 12:45 PM',
              location: 'Approaching Thrissur Bypass along NH-66 corridor',
              isCurrent: true,
              isCompleted: true,
            ),
            _buildTimelineStep(
              title: 'Out for delivery',
              timestamp: 'Expected 03:45 PM',
              location: 'Final delivery run to Kozhikode Industrial SEZ',
              isCompleted: false,
            ),
            _buildTimelineStep(
              title: 'Delivered',
              timestamp: 'Expected 04:30 PM',
              location: 'Synthite Marine Ltd Unloading Bay',
              isCompleted: false,
              isLast: true,
            ),
            const SizedBox(height: 18),

            // Quick Actions: Customer Link & Live GPS
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: AppColors.hairline),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Customer tracking link copied to clipboard!'),
                        ),
                      );
                    },
                    icon: const Icon(LucideIcons.share2, size: 16, color: AppColors.accent),
                    label: const Text(
                      'SHARE LINK',
                      style: TextStyle(color: AppColors.pureWhite, fontSize: 12, fontWeight: FontWeight.w800),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  flex: 2,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.accent,
                      foregroundColor: AppColors.midnightBlack,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      elevation: 0,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => LiveTrackingScreen(trip: trip),
                        ),
                      );
                    },
                    icon: const Icon(LucideIcons.navigation2, size: 18),
                    label: const Text(
                      'LIVE GPS TRACKING',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 0.6,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimelineStep({
    required String title,
    required String timestamp,
    required String location,
    bool isCompleted = false,
    bool isCurrent = false,
    bool isLast = false,
  }) {
    Color dotColor = AppColors.hairline;
    if (isCurrent) {
      dotColor = AppColors.accent;
    } else if (isCompleted) {
      dotColor = AppColors.green;
    }

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Step Node & Line
          Column(
            children: [
              Container(
                width: 16,
                height: 16,
                decoration: BoxDecoration(
                  color: isCurrent
                      ? AppColors.accent.withOpacity(0.2)
                      : isCompleted
                          ? AppColors.green.withOpacity(0.15)
                          : AppColors.midnightBlack,
                  shape: BoxShape.circle,
                  border: Border.all(color: dotColor, width: 2),
                ),
                child: Center(
                  child: isCurrent
                      ? Container(width: 6, height: 6, decoration: const BoxDecoration(color: AppColors.accent, shape: BoxShape.circle))
                      : isCompleted
                          ? const Icon(LucideIcons.check, size: 9, color: AppColors.green)
                          : null,
                ),
              ),
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 2,
                    color: isCompleted ? AppColors.green.withOpacity(0.5) : AppColors.hairline,
                  ),
                ),
            ],
          ),
          const SizedBox(width: 12),
          // Content
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: isLast ? 0 : 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          color: isCurrent ? AppColors.accent : (isCompleted ? AppColors.pureWhite : AppColors.mutedGray),
                          fontSize: 13,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      Text(
                        timestamp,
                        style: const TextStyle(
                          color: AppColors.darkSubtext,
                          fontSize: 10,
                          fontFamily: 'monospace',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    location,
                    style: const TextStyle(
                      color: AppColors.mutedGray,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
