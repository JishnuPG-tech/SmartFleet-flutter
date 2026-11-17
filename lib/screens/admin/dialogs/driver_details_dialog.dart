import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/models/fleet_models.dart';
import '../../../core/state/fleet_state.dart';
import '../../driver/live_tracking_screen.dart';

class DriverDetailsDialog extends StatelessWidget {
  final Driver driver;

  const DriverDetailsDialog({super.key, required this.driver});

  @override
  Widget build(BuildContext context) {
    Color statusColor;
    String statusLabel;
    switch (driver.status) {
      case DriverStatus.available:
        statusColor = AppColors.green;
        statusLabel = 'Available / On Duty';
        break;
      case DriverStatus.onTrip:
        statusColor = AppColors.accent;
        statusLabel = 'In Transit on NH-66';
        break;
      case DriverStatus.offDuty:
        statusColor = AppColors.mutedGray;
        statusLabel = 'Off Duty';
        break;
      case DriverStatus.pending:
        statusColor = AppColors.orange;
        statusLabel = 'KYC Pending';
        break;
    }

    final activeTrip = FleetState.instance.trips.firstWhere(
      (t) => t.driverName == driver.name && t.status == TripStatus.active,
      orElse: () => FleetState.instance.trips.first,
    );

    return Container(
      padding: EdgeInsets.fromLTRB(20, 20, 20, MediaQuery.of(context).viewInsets.bottom + 24),
      decoration: const BoxDecoration(
        color: AppColors.cardCharcoal,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Handle
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

            // Top Profile Row
            Row(
              children: [
                Container(
                  width: 58,
                  height: 58,
                  decoration: BoxDecoration(
                    color: AppColors.midnightBlack,
                    shape: BoxShape.circle,
                    border: Border.all(color: statusColor, width: 2),
                  ),
                  child: Center(
                    child: Text(
                      driver.name.isNotEmpty ? driver.name.substring(0, 1) : 'D',
                      style: TextStyle(
                        color: statusColor,
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 14),
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
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        driver.phone,
                        style: const TextStyle(
                          color: AppColors.mutedGray,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Container(
                            width: 6,
                            height: 6,
                            decoration: BoxDecoration(color: statusColor, shape: BoxShape.circle),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            statusLabel,
                            style: TextStyle(
                              color: statusColor,
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(LucideIcons.x, color: AppColors.mutedGray),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Quick Call / SMS Action Row
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.blue,
                      foregroundColor: AppColors.pureWhite,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Dialing ${driver.name} (${driver.phone})...')),
                      );
                    },
                    icon: const Icon(LucideIcons.phone, size: 16),
                    label: const Text('CALL PILOT', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 12)),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: AppColors.hairline),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Opening dispatch message to ${driver.name}...')),
                      );
                    },
                    icon: const Icon(LucideIcons.messageSquare, size: 16, color: AppColors.accent),
                    label: const Text('SEND SMS', style: TextStyle(color: AppColors.pureWhite, fontWeight: FontWeight.w800, fontSize: 12)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Performance & Asset Metrics
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.midnightBlack,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.hairline),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildMetricItem('${driver.completedTrips}', 'Trips Done', LucideIcons.checkCheck, AppColors.accent),
                  Container(width: 1, height: 32, color: AppColors.border),
                  _buildMetricItem('${driver.rating} ★', 'Safety Rating', LucideIcons.shieldCheck, AppColors.green),
                  Container(width: 1, height: 32, color: AppColors.border),
                  _buildMetricItem('${driver.experienceYears} Yrs', 'Experience', LucideIcons.award, AppColors.blue),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Government Sarathi License Details
            _buildSectionHeader('SARATHI & COMPLIANCE VERIFICATION'),
            const SizedBox(height: 8),
            _buildDetailTile(
              icon: LucideIcons.idCard,
              title: 'Heavy Commercial License (HMV)',
              subtitle: '${driver.licenseNumber} · Valid till Oct 2029',
              badge: 'SARATHI VERIFIED',
              badgeColor: AppColors.green,
            ),
            _buildDetailTile(
              icon: LucideIcons.truck,
              title: 'Assigned Transport Prime Mover',
              subtitle: '${driver.assignedVehicle} · BharatBenz 2823C (Multi-Axle)',
            ),

            const SizedBox(height: 20),

            // Live GPS Tracking Button for Admin
            if (driver.status == DriverStatus.onTrip || driver.status == DriverStatus.available)
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.accent,
                    foregroundColor: AppColors.midnightBlack,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    elevation: 0,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => LiveTrackingScreen(trip: activeTrip),
                      ),
                    );
                  },
                  icon: const Icon(LucideIcons.navigation2, size: 20),
                  label: const Text(
                    'TRACK DRIVER LIVE GPS ON NH-66',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 0.8,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  static Widget _buildMetricItem(String val, String label, IconData icon, Color color) {
    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 12, color: color),
            const SizedBox(width: 4),
            Text(
              val,
              style: TextStyle(
                color: color,
                fontSize: 16,
                fontWeight: FontWeight.w900,
                fontFamily: 'monospace',
              ),
            ),
          ],
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(color: AppColors.mutedGray, fontSize: 10, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }

  static Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(
        color: AppColors.darkSubtext,
        fontSize: 10,
        fontWeight: FontWeight.w800,
        letterSpacing: 1.0,
      ),
    );
  }

  static Widget _buildDetailTile({
    required IconData icon,
    required String title,
    required String subtitle,
    String? badge,
    Color? badgeColor,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.midnightBlack,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Icon(icon, size: 18, color: AppColors.pureWhite),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(color: AppColors.pureWhite, fontSize: 12, fontWeight: FontWeight.w700),
                ),
                Text(
                  subtitle,
                  style: const TextStyle(color: AppColors.mutedGray, fontSize: 11),
                ),
              ],
            ),
          ),
          if (badge != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: (badgeColor ?? AppColors.accent).withOpacity(0.15),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: (badgeColor ?? AppColors.accent).withOpacity(0.4)),
              ),
              child: Text(
                badge,
                style: TextStyle(color: badgeColor ?? AppColors.accent, fontSize: 9, fontWeight: FontWeight.w800),
              ),
            ),
        ],
      ),
    );
  }
}
