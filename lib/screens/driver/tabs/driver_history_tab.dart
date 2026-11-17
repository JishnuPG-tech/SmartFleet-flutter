import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/models/fleet_models.dart';
import '../../../core/components/status_badge.dart';

class DriverHistoryTab extends StatelessWidget {
  const DriverHistoryTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          children: [
            // Header
            const Text(
              'Trip Logs & History',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 22,
                fontWeight: FontWeight.w900,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Verified delivery receipts & logged kilometers',
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 20),

            // Performance Card
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: AppColors.card,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildHistoryStat('142', 'Trips Done', LucideIcons.checkCircle2, AppColors.accent),
                  Container(width: 1, height: 36, color: AppColors.border),
                  _buildHistoryStat('38.4k', 'KMs Logged', LucideIcons.route, AppColors.blue),
                  Container(width: 1, height: 36, color: AppColors.border),
                  _buildHistoryStat('4.9★', 'Safety Score', LucideIcons.shieldCheck, AppColors.green),
                ],
              ),
            ),
            const SizedBox(height: 24),

            const Text(
              'PAST DELIVERIES (NOVEMBER 2026)',
              style: TextStyle(
                color: AppColors.textMuted,
                fontSize: 11,
                fontWeight: FontWeight.w800,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 12),

            // History Items
            _buildPastTripItem(
              tripId: 'TR-1027',
              route: 'MAA (Chennai) → PGT (Palakkad)',
              date: '16 Nov 2026 · 04:30 PM',
              cargo: 'Processed Food Grain · 32.0 Tons',
              vehicle: 'KL 09 EF 9012 (Ashok Leyland 3520)',
              podStatus: 'POD Signed & Verified',
              bataAmount: '₹5,200',
            ),
            const SizedBox(height: 12),

            _buildPastTripItem(
              tripId: 'TR-1021',
              route: 'COK (Kochi) → TVM (Trivandrum)',
              date: '14 Nov 2026 · 02:15 PM',
              cargo: 'Electronic Appliance Cartons · 14.2 Tons',
              vehicle: 'KL 11 AB 1234 (BharatBenz 2823C)',
              podStatus: 'POD Signed & Verified',
              bataAmount: '₹3,800',
            ),
            const SizedBox(height: 12),

            _buildPastTripItem(
              tripId: 'TR-1018',
              route: 'CLT (Calicut) → CAN (Kannur)',
              date: '12 Nov 2026 · 11:45 AM',
              cargo: 'Ceramic Floor Tiles · 26.0 Tons',
              vehicle: 'KL 11 AB 1234 (BharatBenz 2823C)',
              podStatus: 'POD Signed & Verified',
              bataAmount: '₹2,600',
            ),
            const SizedBox(height: 12),

            _buildPastTripItem(
              tripId: 'TR-1014',
              route: 'BLR (Bangalore) → COK (Kochi Port)',
              date: '09 Nov 2026 · 08:00 AM',
              cargo: 'Textile Machinery Parts · 19.4 Tons',
              vehicle: 'KL 07 CD 5678 (Tata Prima 3530.K)',
              podStatus: 'POD Signed & Verified',
              bataAmount: '₹6,400',
            ),

            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  static Widget _buildHistoryStat(String value, String label, IconData icon, Color color) {
    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 13, color: color),
            const SizedBox(width: 4),
            Text(
              value,
              style: TextStyle(
                color: color,
                fontSize: 18,
                fontWeight: FontWeight.w900,
                fontFamily: 'monospace',
              ),
            ),
          ],
        ),
        const SizedBox(height: 3),
        Text(
          label,
          style: const TextStyle(
            color: AppColors.textSecondary,
            fontSize: 11,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  static Widget _buildPastTripItem({
    required String tripId,
    required String route,
    required String date,
    required String cargo,
    required String vehicle,
    required String podStatus,
    required String bataAmount,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                tripId,
                style: const TextStyle(
                  color: AppColors.accent,
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  fontFamily: 'monospace',
                ),
              ),
              const StatusBadge(status: TripStatus.completed),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            route,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 15,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            cargo,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 12),
          Container(height: 1, color: AppColors.border),
          const SizedBox(height: 10),
          Row(
            children: [
              const Icon(LucideIcons.fileCheck, size: 14, color: AppColors.green),
              const SizedBox(width: 6),
              Text(
                podStatus,
                style: const TextStyle(
                  color: AppColors.green,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const Spacer(),
              Text(
                bataAmount,
                style: const TextStyle(
                  color: AppColors.accent,
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
