import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/models/fleet_models.dart';
import '../../../core/state/fleet_state.dart';
import '../../../core/components/compact_stat_pill.dart';
import '../../../core/components/tracking_timeline.dart';
import '../dialogs/create_dispatch_dialog.dart';

class AdminHomeTab extends StatelessWidget {
  final VoidCallback? onNavigateToOrders;

  const AdminHomeTab({super.key, this.onNavigateToOrders});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: FleetState.instance,
      builder: (context, _) {
        final state = FleetState.instance;
        final activeTrip = state.trips.firstWhere(
          (t) => t.status == TripStatus.active,
          orElse: () => state.trips.first,
        );

        return Scaffold(
          backgroundColor: AppColors.midnightBlack,
          body: SafeArea(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              children: [
                // Top Header: Brand + Live Pill
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'SMARTFLEET',
                      style: TextStyle(
                        color: AppColors.pureWhite,
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.0,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.accent.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: AppColors.accent.withOpacity(0.4)),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(LucideIcons.radio, size: 10, color: AppColors.accent),
                          SizedBox(width: 4),
                          Text(
                            'LIVE',
                            style: TextStyle(
                              color: AppColors.accent,
                              fontSize: 10,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 0.8,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),

                // Greeting & Subtitle
                const Text(
                  'Good evening!',
                  style: TextStyle(
                    color: AppColors.pureWhite,
                    fontSize: 26,
                    fontWeight: FontWeight.w900,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 2),
                const Text(
                  "Here's your fleet overview.",
                  style: TextStyle(
                    color: AppColors.mutedGray,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 16),

                // 4-Pill Unified Status Grid
                Row(
                  children: [
                    Expanded(
                      child: CompactStatPill(
                        label: 'Active Trips',
                        value: '24',
                        subtitle: 'Currently running',
                        accentColor: AppColors.accent,
                        onTap: onNavigateToOrders,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: CompactStatPill(
                        label: 'Available',
                        value: '18',
                        subtitle: 'Ready for dispatch',
                        accentColor: AppColors.green,
                        onTap: onNavigateToOrders,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: CompactStatPill(
                        label: 'Delivered',
                        value: '142',
                        subtitle: 'This month',
                        accentColor: AppColors.blue,
                        onTap: onNavigateToOrders,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: CompactStatPill(
                        label: 'Pending',
                        value: '06',
                        subtitle: 'Needs attention',
                        accentColor: AppColors.orange,
                        onTap: onNavigateToOrders,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Live Fleet Section Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Live fleet',
                      style: TextStyle(
                        color: AppColors.pureWhite,
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    GestureDetector(
                      onTap: onNavigateToOrders,
                      child: const Text(
                        'View all',
                        style: TextStyle(
                          color: AppColors.accent,
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                // Hero Live Fleet Active Card (Interactive Shiprocket format)
                GestureDetector(
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (_) => ShipmentTrackingDetailSheet(trip: activeTrip),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.cardCharcoal,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: AppColors.accent.withOpacity(0.4)),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.accent.withOpacity(0.06),
                          blurRadius: 16,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              activeTrip.vehiclePlate,
                              style: const TextStyle(
                                color: AppColors.pureWhite,
                                fontSize: 16,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 0.5,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: AppColors.accent.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Text(
                                'On trip',
                                style: TextStyle(
                                  color: AppColors.accent,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                          '${activeTrip.originCity} → ${activeTrip.destCity}',
                          style: const TextStyle(
                            color: AppColors.accent,
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 12),

                        // Progress Bar + ETA
                        Row(
                          children: [
                            Expanded(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(3),
                                child: const LinearProgressIndicator(
                                  value: 0.65,
                                  minHeight: 5,
                                  backgroundColor: Color(0xFF242B24),
                                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.accent),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            const Text(
                              '65% completed',
                              style: TextStyle(
                                color: AppColors.pureWhite,
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Approaching Thrissur Bypass',
                              style: TextStyle(color: AppColors.mutedGray, fontSize: 11),
                            ),
                            Text(
                              'ETA 4:30 PM',
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
                ),
                const SizedBox(height: 18),

                // Quick Action: + Create Shipment Button
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
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        builder: (_) => const CreateDispatchDialog(),
                      );
                    },
                    icon: const Icon(LucideIcons.plusCircle, size: 18),
                    label: const Text(
                      'CREATE NEW SHIPMENT',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 0.8,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Recent Alerts & Logs
                const Text(
                  'Recent activity',
                  style: TextStyle(
                    color: AppColors.pureWhite,
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 8),

                ...state.activities.take(3).map((act) => _buildCompactActivity(act)),
                const SizedBox(height: 80),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildCompactActivity(FleetActivity act) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.cardCharcoal,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.hairline),
      ),
      child: Row(
        children: [
          Container(
            width: 7,
            height: 7,
            decoration: BoxDecoration(color: act.statusColor, shape: BoxShape.circle),
          ),
          const SizedBox(width: 10),
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
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  act.subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: AppColors.mutedGray,
                    fontSize: 10,
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
