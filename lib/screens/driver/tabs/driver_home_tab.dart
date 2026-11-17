import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/models/fleet_models.dart';
import '../../../core/state/fleet_state.dart';
import '../live_tracking_screen.dart';
import '../pod_completion_dialog.dart';

class DriverHomeTab extends StatelessWidget {
  const DriverHomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: FleetState.instance,
      builder: (context, _) {
        final state = FleetState.instance;
        final driver = state.loggedInDriver ?? MockData.drivers.first;
        final isDutyActive = driver.status != DriverStatus.offDuty;

        final activeTrip = state.trips.firstWhere(
          (t) => t.status == TripStatus.active || t.status == TripStatus.assigned,
          orElse: () => state.trips.first,
        );

        return Scaffold(
          backgroundColor: AppColors.midnightBlack,
          body: SafeArea(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              children: [
                // Top Header: Pilot Avatar + Duty Toggle
                Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: AppColors.cardCharcoal,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isDutyActive ? AppColors.accent : AppColors.hairline,
                          width: 2,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          driver.name.isNotEmpty ? driver.name.substring(0, 1) : 'D',
                          style: const TextStyle(
                            color: AppColors.accent,
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            driver.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: AppColors.pureWhite,
                              fontSize: 16,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          Text(
                            isDutyActive ? 'ON DUTY · ${driver.assignedVehicle}' : 'OFF DUTY',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: isDutyActive ? AppColors.green : AppColors.mutedGray,
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),

                    // Duty Toggle
                    GestureDetector(
                      onTap: () => state.setDriverDuty(!isDutyActive),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 180),
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: isDutyActive ? AppColors.accent.withOpacity(0.15) : AppColors.cardCharcoal,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: isDutyActive ? AppColors.accent : AppColors.hairline),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(LucideIcons.power, size: 12, color: isDutyActive ? AppColors.accent : AppColors.mutedGray),
                            const SizedBox(width: 4),
                            Text(
                              isDutyActive ? 'ACTIVE' : 'OFF DUTY',
                              style: TextStyle(
                                color: isDutyActive ? AppColors.accent : AppColors.mutedGray,
                                fontSize: 10,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),

                // One Primary Purpose Card: Current Assignment
                const Text(
                  'CURRENT DELIVERY MISSION',
                  style: TextStyle(
                    color: AppColors.darkSubtext,
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.0,
                  ),
                ),
                const SizedBox(height: 8),

                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.cardCharcoal,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppColors.accent.withOpacity(0.4)),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.accent.withOpacity(0.06),
                        blurRadius: 20,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Shipment ID & Status
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Shipment #${activeTrip.tripNumber}',
                            style: const TextStyle(
                              color: AppColors.accent,
                              fontSize: 13,
                              fontWeight: FontWeight.w800,
                              fontFamily: 'monospace',
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: AppColors.accent.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              _getWorkflowStepName(state.currentWorkflowStep),
                              style: const TextStyle(
                                color: AppColors.accent,
                                fontSize: 10,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      // Route
                      Text(
                        '${activeTrip.originCity} → ${activeTrip.destCity}',
                        style: const TextStyle(
                          color: AppColors.pureWhite,
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
                          letterSpacing: -0.4,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${activeTrip.cargoTitle} · ${activeTrip.cargoWeight}',
                        style: const TextStyle(
                          color: AppColors.mutedGray,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 14),

                      // Progress Bar
                      ClipRRect(
                        borderRadius: BorderRadius.circular(3),
                        child: LinearProgressIndicator(
                          value: state.liveProgress,
                          minHeight: 5,
                          backgroundColor: Colors.white.withOpacity(0.08),
                          valueColor: const AlwaysStoppedAnimation<Color>(AppColors.accent),
                        ),
                      ),
                      const SizedBox(height: 8),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              state.currentWaypoint,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(color: AppColors.mutedGray, fontSize: 11),
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            'ETA 4:30 PM',
                            style: TextStyle(
                              color: AppColors.accent,
                              fontSize: 11,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 18),

                      // THE ONE PRIMARY ACTION BUTTON
                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.accent,
                            foregroundColor: AppColors.midnightBlack,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                            elevation: 0,
                          ),
                          onPressed: () {
                            if (state.currentWorkflowStep == 1) {
                              // Open Live GPS Navigation
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => LiveTrackingScreen(trip: activeTrip),
                                ),
                              );
                            } else if (state.currentWorkflowStep == 2) {
                              // Open POD Upload
                              showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                backgroundColor: Colors.transparent,
                                builder: (_) => PodCompletionDialog(trip: activeTrip),
                              );
                            } else {
                              state.advanceDriverWorkflow();
                            }
                          },
                          icon: Icon(_getWorkflowIcon(state.currentWorkflowStep), size: 20),
                          label: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              _getPrimaryButtonText(state.currentWorkflowStep),
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 0.6,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Compact Telemetry Metrics
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  decoration: BoxDecoration(
                    color: AppColors.cardCharcoal,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.hairline),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildMetric('${state.liveSpeed.toInt()} km/h', 'Speed HUD', AppColors.accent),
                      Container(width: 1, height: 26, color: AppColors.border),
                      _buildMetric('${state.distanceRemainingKm} km', 'Remaining', AppColors.blue),
                      Container(width: 1, height: 26, color: AppColors.border),
                      _buildMetric('${state.dieselRangeKm} km', 'Diesel Range', AppColors.green),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Quick Support Shortcuts
                Row(
                  children: [
                    Expanded(
                      child: _buildSupportButton(
                        icon: LucideIcons.phoneCall,
                        label: 'Call Hub',
                        color: AppColors.blue,
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Dialing Fleet Dispatch Hub (+91 94471 23456)...')),
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _buildSupportButton(
                        icon: LucideIcons.alertTriangle,
                        label: 'SOS Breakdown',
                        color: AppColors.roseAlert,
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              backgroundColor: AppColors.roseAlert,
                              content: Text('SOS signal broadcasted with GPS coordinates!'),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 80),
              ],
            ),
          ),
        );
      },
    );
  }

  static Widget _buildMetric(String value, String label, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            color: color,
            fontSize: 16,
            fontWeight: FontWeight.w900,
            fontFamily: 'monospace',
          ),
        ),
        const SizedBox(height: 2),
        Text(label, style: const TextStyle(color: AppColors.mutedGray, fontSize: 10)),
      ],
    );
  }

  static Widget _buildSupportButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.cardCharcoal,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.hairline),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 16),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                color: AppColors.pureWhite,
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getWorkflowStepName(int step) {
    switch (step) {
      case 0:
        return 'Pickup Phase';
      case 1:
        return 'In Transit';
      case 2:
        return 'At Destination';
      case 3:
      default:
        return 'Completed';
    }
  }

  String _getPrimaryButtonText(int step) {
    switch (step) {
      case 0:
        return 'NAVIGATE TO PICKUP HUB';
      case 1:
        return 'OPEN LIVE GPS NAVIGATION';
      case 2:
        return 'ARRIVED AT DOCK · SUBMIT POD';
      case 3:
      default:
        return 'MISSION COMPLETED · READY FOR NEXT';
    }
  }

  IconData _getWorkflowIcon(int step) {
    switch (step) {
      case 0:
        return LucideIcons.mapPin;
      case 1:
        return LucideIcons.navigation2;
      case 2:
        return LucideIcons.packageCheck;
      case 3:
      default:
        return LucideIcons.checkCheck;
    }
  }
}
