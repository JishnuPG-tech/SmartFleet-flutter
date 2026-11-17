import 'package:flutter/material.dart';
import '../../../core/components/stat_card.dart';
import '../../../core/components/telemetry_radar_map.dart';
import '../../../core/components/telemetry_gauge.dart';
import '../../../core/models/fleet_models.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/state/fleet_state.dart';
import '../dialogs/create_dispatch_dialog.dart';

class OverviewTab extends StatelessWidget {
  final VoidCallback? onCreateTrip;

  const OverviewTab({super.key, this.onCreateTrip});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: FleetState.instance,
      builder: (context, _) {
        final state = FleetState.instance;
        final activeTripsCount = state.trips.where((t) => t.status == TripStatus.active).length;
        final completedToday = state.trips.where((t) => t.status == TripStatus.completed).length;

        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Date & Subtitle
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'OVERVIEW',
                        style: TextStyle(
                          color: AppColors.acidLime,
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1.2,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'Tuesday, 17 November',
                        style: TextStyle(
                          color: AppColors.pureWhite,
                          fontSize: 22,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.notifications_outlined, color: AppColors.pureWhite),
                  ),
                ],
              ),
              const SizedBox(height: 18),

              // 4-Card Stats Grid
              Row(
                children: [
                  Expanded(
                    child: StatCard(
                      title: 'Vehicles',
                      value: '${state.vehicles.length}',
                      subtitle: '${state.vehicles.length - 2} in service',
                      icon: Icons.local_shipping_outlined,
                      accentColor: AppColors.acidLime,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: StatCard(
                      title: 'Active Trips',
                      value: '$activeTripsCount',
                      subtitle: '$activeTripsCount in transit',
                      icon: Icons.route_outlined,
                      accentColor: AppColors.skyInfo,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: StatCard(
                      title: 'Drivers',
                      value: '${state.drivers.length}',
                      subtitle: '${state.drivers.where((d) => d.status != DriverStatus.offDuty).length} on duty',
                      icon: Icons.people_outline,
                      accentColor: AppColors.emeraldActive,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: StatCard(
                      title: 'Deliveries',
                      value: '$completedToday',
                      subtitle: 'Completed today',
                      icon: Icons.task_alt_outlined,
                      accentColor: AppColors.amberWarning,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Create Trip Button
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton.icon(
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (_) => const CreateDispatchDialog(),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.acidLime,
                    foregroundColor: AppColors.midnightBlack,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 0,
                  ),
                  icon: const Icon(Icons.add_circle_outline, size: 20),
                  label: const Text(
                    'CREATE NEW FREIGHT TRIP',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 0.8,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Radar Highway Telemetry Map
              const TelemetryRadarMap(),
              const SizedBox(height: 16),

              // Fleet Capacity Gauge
              const TelemetryGauge(
                percentage: 0.82,
                title: 'FLEET CAPACITY LOAD',
                sublabel: '18 of 22 active haulers deployed',
              ),
              const SizedBox(height: 24),

              // Recent Activities Section
              const Text(
                'RECENT ACTIVITY',
                style: TextStyle(
                  color: AppColors.mutedGray,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.0,
                ),
              ),
              const SizedBox(height: 12),

              ...state.activities.map((act) => _buildActivityTile(act)),
              const SizedBox(height: 90),
            ],
          ),
        );
      },
    );
  }

  Widget _buildActivityTile(FleetActivity act) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.cardCharcoal,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.hairline, width: 0.8),
      ),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: act.statusColor,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  act.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: AppColors.pureWhite,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  act.subtitle,
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
          Text(
            act.timestamp,
            style: const TextStyle(
              color: AppColors.darkSubtext,
              fontSize: 10,
              fontFamily: 'monospace',
            ),
          ),
        ],
      ),
    );
  }
}
