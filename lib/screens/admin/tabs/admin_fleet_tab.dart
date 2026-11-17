import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/models/fleet_models.dart';
import '../../../core/state/fleet_state.dart';
import '../../../core/components/status_badge.dart';
import '../../driver/live_tracking_screen.dart';

class AdminFleetTab extends StatelessWidget {
  const AdminFleetTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: FleetState.instance,
      builder: (context, _) {
        final vehicles = FleetState.instance.vehicles;

        return Scaffold(
          backgroundColor: AppColors.midnightBlack,
          appBar: AppBar(
            backgroundColor: AppColors.midnightBlack,
            elevation: 0,
            title: const Text(
              'Fleet Lorries',
              style: TextStyle(
                color: AppColors.pureWhite,
                fontSize: 18,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          body: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            itemCount: vehicles.length,
            itemBuilder: (context, index) {
              final v = vehicles[index];
              return Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.cardCharcoal,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.hairline),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.05),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(LucideIcons.truck, size: 18, color: AppColors.accent),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                v.plateNumber,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: AppColors.pureWhite,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                              Text(
                                v.model,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: AppColors.mutedGray,
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        StatusBadge(
                          label: v.status == VehicleStatus.onTrip
                              ? 'On Trip'
                              : v.status == VehicleStatus.available
                                  ? 'Available'
                                  : 'Maintenance',
                          color: v.status == VehicleStatus.onTrip
                              ? AppColors.accent
                              : v.status == VehicleStatus.available
                                  ? AppColors.green
                                  : AppColors.orange,
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Pilot: ${v.assignedDriver}', style: const TextStyle(color: AppColors.mutedGray, fontSize: 11)),
                        Text('Cap: ${v.capacity}', style: const TextStyle(color: AppColors.mutedGray, fontSize: 11)),
                        Text('Diesel: ${(v.fuelLevel * 100).toInt()}%', style: const TextStyle(color: AppColors.pureWhite, fontSize: 11, fontWeight: FontWeight.w700)),
                      ],
                    ),
                    if (v.status == VehicleStatus.onTrip) ...[
                      const SizedBox(height: 10),
                      SizedBox(
                        width: double.infinity,
                        height: 36,
                        child: OutlinedButton.icon(
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: AppColors.hairline),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                          onPressed: () {
                            final activeTrip = FleetState.instance.trips.first;
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => LiveTrackingScreen(trip: activeTrip)),
                            );
                          },
                          icon: const Icon(LucideIcons.navigation, size: 14, color: AppColors.accent),
                          label: const Text(
                            'LIVE GPS TELEMETRY',
                            style: TextStyle(color: AppColors.pureWhite, fontSize: 11, fontWeight: FontWeight.w800),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }
}
