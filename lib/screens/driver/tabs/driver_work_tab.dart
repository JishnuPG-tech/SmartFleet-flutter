import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/models/fleet_models.dart';
import '../../../core/components/status_badge.dart';
import '../../../core/state/fleet_state.dart';
import '../live_tracking_screen.dart';

class DriverWorkTab extends StatefulWidget {
  const DriverWorkTab({super.key});

  @override
  State<DriverWorkTab> createState() => _DriverWorkTabState();
}

class _DriverWorkTabState extends State<DriverWorkTab> {
  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: FleetState.instance,
      builder: (context, _) {
        final state = FleetState.instance;
        final driver = state.loggedInDriver ?? MockData.drivers.first;
        final isDutyActive = driver.status != DriverStatus.offDuty;

        // Find active or assigned trip for driver
        final activeTrip = state.trips.firstWhere(
          (t) => t.status == TripStatus.active || t.status == TripStatus.assigned,
          orElse: () => state.trips.first,
        );

        return Scaffold(
          backgroundColor: AppColors.background,
          body: SafeArea(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              children: [
                // Top Cockpit Bar (Fixes 52px overflow)
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
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Row(
                            children: [
                              Container(
                                width: 6,
                                height: 6,
                                decoration: BoxDecoration(
                                  color: isDutyActive ? AppColors.green : AppColors.mutedGray,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  isDutyActive ? 'ON DUTY · ${driver.assignedVehicle}' : 'OFF DUTY',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    color: AppColors.mutedGray,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),

                    // Duty Toggle Switch
                    GestureDetector(
                      onTap: () {
                        state.setDriverDuty(!isDutyActive);
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: isDutyActive
                              ? AppColors.accent.withOpacity(0.15)
                              : AppColors.cardCharcoal,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: isDutyActive ? AppColors.accent : AppColors.hairline,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              LucideIcons.power,
                              size: 12,
                              color: isDutyActive ? AppColors.accent : AppColors.mutedGray,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              isDutyActive ? 'ACTIVE' : 'STANDBY',
                              style: TextStyle(
                                color: isDutyActive ? AppColors.accent : AppColors.mutedGray,
                                fontSize: 10,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 0.6,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Live Telemetry HUD Bar (Fixes 9.5px overflow with Expanded)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                  decoration: BoxDecoration(
                    color: AppColors.cardCharcoal,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.hairline),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: _buildHudItem(
                          label: 'SPEED',
                          value: '${state.liveSpeed.toInt()}',
                          unit: 'KM/H',
                          color: AppColors.accent,
                          icon: LucideIcons.gauge,
                        ),
                      ),
                      Container(width: 1, height: 32, color: AppColors.hairline),
                      Expanded(
                        child: _buildHudItem(
                          label: 'NEXT REST',
                          value: '34',
                          unit: 'KM',
                          color: AppColors.blue,
                          icon: LucideIcons.mapPin,
                        ),
                      ),
                      Container(width: 1, height: 32, color: AppColors.hairline),
                      Expanded(
                        child: _buildHudItem(
                          label: 'RANGE',
                          value: '${state.dieselRangeKm}',
                          unit: 'KM',
                          color: AppColors.green,
                          icon: LucideIcons.fuel,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Section Label (Fixes 2.9px overflow)
                const Row(
                  children: [
                    Expanded(
                      child: Text(
                        'ACTIVE MISSION MANIFEST',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: AppColors.darkSubtext,
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1.0,
                        ),
                      ),
                    ),
                    Text(
                      'NH-66 CORRIDOR',
                      style: TextStyle(
                        color: AppColors.accent,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.8,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                // Boarding Pass Ticket for Driver
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.cardCharcoal,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppColors.accent.withOpacity(0.4)),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.accent.withOpacity(0.06),
                        blurRadius: 18,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      // Upper ticket section
                      Padding(
                        padding: const EdgeInsets.all(18),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: AppColors.cardSurfaceHighlight,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    activeTrip.tripNumber,
                                    style: const TextStyle(
                                      color: AppColors.pureWhite,
                                      fontFamily: 'monospace',
                                      fontSize: 12,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                ),
                                StatusBadge(status: activeTrip.status),
                              ],
                            ),
                            const SizedBox(height: 16),

                            // Route codes and line
                            Row(
                              children: [
                                SizedBox(
                                  width: 76,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        activeTrip.originCode,
                                        style: const TextStyle(
                                          color: AppColors.accent,
                                          fontSize: 24,
                                          fontWeight: FontWeight.w900,
                                          letterSpacing: 1.0,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        activeTrip.originCity,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          color: AppColors.mutedGray,
                                          fontSize: 11,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Column(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                        decoration: BoxDecoration(
                                          color: AppColors.cardSurfaceHighlight,
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: const Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Icon(LucideIcons.truck, size: 11, color: AppColors.accent),
                                            SizedBox(width: 4),
                                            Text(
                                              '195 KM',
                                              style: TextStyle(
                                                color: AppColors.pureWhite,
                                                fontSize: 10,
                                                fontWeight: FontWeight.w800,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      Container(
                                        width: 70,
                                        height: 2,
                                        color: AppColors.hairline,
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  width: 76,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        activeTrip.destCode,
                                        style: const TextStyle(
                                          color: AppColors.pureWhite,
                                          fontSize: 24,
                                          fontWeight: FontWeight.w900,
                                          letterSpacing: 1.0,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        activeTrip.destCity,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          color: AppColors.mutedGray,
                                          fontSize: 11,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 18),

                            // Progress Bar
                            ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: LinearProgressIndicator(
                                value: state.liveProgress,
                                minHeight: 5,
                                backgroundColor: AppColors.cardSurfaceHighlight,
                                valueColor: const AlwaysStoppedAnimation<Color>(AppColors.accent),
                              ),
                            ),
                            const SizedBox(height: 8),

                            // ETA & Checkpoint (Fixes 32px overflow)
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    state.currentWaypoint,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      color: AppColors.mutedGray,
                                      fontSize: 11,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                const Text(
                                  'ETA: 04:30 PM',
                                  style: TextStyle(
                                    color: AppColors.accent,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      // Dashed cut separator
                      Row(
                        children: [
                          Container(
                            width: 14,
                            height: 28,
                            decoration: const BoxDecoration(
                              color: AppColors.background,
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(14),
                                bottomRight: Radius.circular(14),
                              ),
                            ),
                          ),
                          Expanded(
                            child: LayoutBuilder(
                              builder: (context, constraints) {
                                return Flex(
                                  direction: Axis.horizontal,
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: List.generate(
                                    (constraints.constrainWidth() / 10).floor(),
                                    (_) => const SizedBox(
                                      width: 5,
                                      height: 1,
                                      child: DecoratedBox(
                                        decoration: BoxDecoration(color: AppColors.hairline),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                          Container(
                            width: 14,
                            height: 28,
                            decoration: const BoxDecoration(
                              color: AppColors.background,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(14),
                                bottomLeft: Radius.circular(14),
                              ),
                            ),
                          ),
                        ],
                      ),

                      // Lower Details Section
                      Padding(
                        padding: const EdgeInsets.all(18),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Expanded(child: _buildManifestField('CARGO TYPE', activeTrip.cargoTitle)),
                                Expanded(child: _buildManifestField('GROSS WT', activeTrip.cargoWeight, alignRight: true)),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                Expanded(child: _buildManifestField('E-WAY BILL', '3410 8829 1192')),
                                Expanded(child: _buildManifestField('CONSIGNEE', 'Synthite Marine Ltd', alignRight: true)),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Live Navigation Launch Banner
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => LiveTrackingScreen(trip: activeTrip),
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    decoration: BoxDecoration(
                      color: AppColors.cardCharcoal,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.accent.withOpacity(0.5)),
                    ),
                    child: const Row(
                      children: [
                        Icon(LucideIcons.navigation, color: AppColors.accent, size: 22),
                        SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'OPEN LIVE GPS COCKPIT & MAP',
                                style: TextStyle(
                                  color: AppColors.pureWhite,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 0.6,
                                ),
                              ),
                              SizedBox(height: 2),
                              Text(
                                'Turn-by-turn simulation · Live Speed HUD · NH-66',
                                style: TextStyle(
                                  color: AppColors.mutedGray,
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Icon(LucideIcons.chevronRight, color: AppColors.accent, size: 18),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Big High-Contrast Touch Action Buttons (Fixes 11px overflow with FittedBox)
                Text(
                  'MISSION ACTION WORKFLOW (${state.currentWorkflowStep + 1}/4)',
                  style: const TextStyle(
                    color: AppColors.darkSubtext,
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.0,
                  ),
                ),
                const SizedBox(height: 10),

                // Large Action Button
                GestureDetector(
                  onTap: () {
                    state.advanceDriverWorkflow();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        backgroundColor: AppColors.cardCharcoal,
                        behavior: SnackBarBehavior.floating,
                        content: Row(
                          children: [
                            const Icon(LucideIcons.checkCircle2, color: AppColors.accent, size: 20),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                _getStepToastMessage(state.currentWorkflowStep),
                                style: const TextStyle(
                                  color: AppColors.pureWhite,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                    decoration: BoxDecoration(
                      color: AppColors.accent,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.accent.withOpacity(0.3),
                          blurRadius: 16,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            _getStepIcon(state.currentWorkflowStep),
                            color: AppColors.midnightBlack,
                            size: 20,
                          ),
                          const SizedBox(width: 10),
                          Text(
                            _getStepButtonTitle(state.currentWorkflowStep),
                            style: const TextStyle(
                              color: AppColors.midnightBlack,
                              fontSize: 14,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 0.6,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 14),

                // Quick Tools Grid
                Row(
                  children: [
                    Expanded(
                      child: _buildDriverQuickBtn(
                        icon: LucideIcons.phoneCall,
                        label: 'Call Hub',
                        color: AppColors.blue,
                        onTap: () {
                          _showEmergencyDialog(context, 'Fleet Dispatch Hub', '+91 94471 23456');
                        },
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _buildDriverQuickBtn(
                        icon: LucideIcons.alertTriangle,
                        label: 'SOS Alert',
                        color: AppColors.roseAlert,
                        onTap: () {
                          _showSosDialog(context);
                        },
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _buildDriverQuickBtn(
                        icon: LucideIcons.fuel,
                        label: 'Fuel Log',
                        color: AppColors.amberWarning,
                        onTap: () {},
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 90),
              ],
            ),
          ),
        );
      },
    );
  }

  static Widget _buildHudItem({
    required String label,
    required String value,
    required String unit,
    required Color color,
    required IconData icon,
  }) {
    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 11, color: color),
            const SizedBox(width: 4),
            Text(
              label,
              style: const TextStyle(
                color: AppColors.mutedGray,
                fontSize: 9,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 2),
        Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text(
              value,
              style: TextStyle(
                color: color,
                fontSize: 20,
                fontWeight: FontWeight.w900,
                fontFamily: 'monospace',
              ),
            ),
            const SizedBox(width: 2),
            Text(
              unit,
              style: const TextStyle(
                color: AppColors.mutedGray,
                fontSize: 9,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ],
    );
  }

  static Widget _buildManifestField(String label, String value, {bool alignRight = false}) {
    return Column(
      crossAxisAlignment: alignRight ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: AppColors.darkSubtext,
            fontSize: 10,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.8,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: AppColors.pureWhite,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  static Widget _buildDriverQuickBtn({
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
        child: Column(
          children: [
            Icon(icon, color: color, size: 18),
            const SizedBox(height: 4),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppColors.pureWhite,
                fontSize: 11,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getStepButtonTitle(int step) {
    switch (step) {
      case 0:
        return 'CONFIRM LOAD PICKUP & SCAN';
      case 1:
        return 'START GPS NAVIGATION & EN ROUTE';
      case 2:
        return 'ARRIVED AT UNLOADING YARD';
      case 3:
      default:
        return 'TRIP COMPLETED · READY FOR NEXT';
    }
  }

  IconData _getStepIcon(int step) {
    switch (step) {
      case 0:
        return LucideIcons.packageCheck;
      case 1:
        return LucideIcons.navigation;
      case 2:
        return LucideIcons.mapPinCheck;
      case 3:
      default:
        return LucideIcons.checkCheck;
    }
  }

  String _getStepToastMessage(int step) {
    switch (step) {
      case 0:
        return 'Load pickup verified';
      case 1:
        return 'Navigation started along NH-66';
      case 2:
        return 'Arrived at destination yard';
      case 3:
      default:
        return 'POD completed and synced';
    }
  }

  void _showEmergencyDialog(BuildContext context, String title, String phone) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppColors.cardCharcoal,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(title, style: const TextStyle(color: AppColors.pureWhite)),
        content: Text('Calling Fleet Control Line: $phone', style: const TextStyle(color: AppColors.mutedGray)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('CANCEL', style: TextStyle(color: AppColors.mutedGray)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.accent),
            onPressed: () => Navigator.pop(context),
            child: const Text('DIAL NOW', style: TextStyle(color: AppColors.midnightBlack, fontWeight: FontWeight.w800)),
          ),
        ],
      ),
    );
  }

  void _showSosDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppColors.cardCharcoal,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Icon(LucideIcons.alertOctagon, color: AppColors.roseAlert),
            SizedBox(width: 10),
            Text('SOS Breakdown', style: TextStyle(color: AppColors.pureWhite)),
          ],
        ),
        content: const Text(
          'An emergency signal with GPS coordinates (10.0261° N, 76.3125° E - Aluva NH-66) will be dispatched to nearby breakdown cranes and admin HQ.',
          style: TextStyle(color: AppColors.mutedGray, fontSize: 13),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('CANCEL', style: TextStyle(color: AppColors.mutedGray)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.roseAlert),
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  backgroundColor: AppColors.roseAlert,
                  content: Text('EMERGENCY SOS SIGNAL BROADCASTED'),
                ),
              );
            },
            child: const Text('TRANSMIT SOS', style: TextStyle(color: AppColors.pureWhite, fontWeight: FontWeight.w800)),
          ),
        ],
      ),
    );
  }
}
