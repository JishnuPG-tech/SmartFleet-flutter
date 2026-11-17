import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../core/theme/app_colors.dart';
import '../../auth/role_select_screen.dart';

class MoreTab extends StatelessWidget {
  const MoreTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          children: [
            // Header
            Row(
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: AppColors.card,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: const Center(
                    child: Icon(LucideIcons.shieldCheck, color: AppColors.accent, size: 28),
                  ),
                ),
                const SizedBox(width: 14),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'SmartFleet Kerala',
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.3,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'Fleet Admin · Cochin SEZ Hub',
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.accent.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppColors.accent.withOpacity(0.3)),
                  ),
                  child: const Text(
                    'PRO TIER',
                    style: TextStyle(
                      color: AppColors.accent,
                      fontSize: 10,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 0.8,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Financial & Fleet Summary Ribbon
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: AppColors.card,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildSummaryItem('Monthly Rev', '₹14.82 L', LucideIcons.trendingUp, AppColors.accent),
                      Container(width: 1, height: 38, color: AppColors.border),
                      _buildSummaryItem('Fuel Outlay', '₹4.15 L', LucideIcons.fuel, AppColors.orange),
                      Container(width: 1, height: 38, color: AppColors.border),
                      _buildSummaryItem('Active Tolls', '₹68.4 K', LucideIcons.creditCard, AppColors.blue),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Operations Group
            _buildSectionHeader('OPERATIONS & ASSETS'),
            const SizedBox(height: 10),
            _buildActionTile(
              icon: LucideIcons.wrench,
              title: 'Maintenance & Fitness (FC)',
              subtitle: '2 lorries scheduled for oil service & brake test',
              badge: '2 Due',
              badgeColor: AppColors.orange,
              onTap: () {},
            ),
            _buildActionTile(
              icon: LucideIcons.building2,
              title: 'Customer Accounts & Contracts',
              subtitle: 'Tata Steel, Synthite Exports, Reliance Logistics',
              onTap: () {},
            ),
            _buildActionTile(
              icon: LucideIcons.receipt,
              title: 'Driver Bata & Fuel Advances',
              subtitle: 'Automated Fastag & petrol pump cash vouchers',
              onTap: () {},
            ),
            _buildActionTile(
              icon: LucideIcons.radio,
              title: 'Speed Governors & NH-66 Geofence',
              subtitle: 'Real-time telemetry threshold: 80 km/h limit',
              onTap: () {},
            ),

            const SizedBox(height: 24),

            // Compliance & Settings Group
            _buildSectionHeader('COMPLIANCE & SYSTEM'),
            const SizedBox(height: 10),
            _buildActionTile(
              icon: LucideIcons.fileCheck2,
              title: 'e-Way Bill & GST Invoice Auto-Sync',
              subtitle: 'Connected to NIC Kerala E-Way bill portal',
              onTap: () {},
            ),
            _buildActionTile(
              icon: LucideIcons.bell,
              title: 'Critical Telegram & SMS Alerts',
              subtitle: 'Instant alerts on route deviation or harsh braking',
              onTap: () {},
            ),
            _buildActionTile(
              icon: LucideIcons.cpu,
              title: 'Diagnostic Cloud Relay',
              subtitle: 'Connected to 16-vCPU Antigravity Engine',
              onTap: () {},
            ),

            const SizedBox(height: 28),

            // Logout / Role Switcher Button
            GestureDetector(
              onTap: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (_) => const RoleSelectScreen()),
                );
              },
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  color: AppColors.card,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.red.withOpacity(0.4)),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(LucideIcons.logOut, color: AppColors.red, size: 18),
                    SizedBox(width: 10),
                    Text(
                      'SWITCH ROLE / LOGOUT',
                      style: TextStyle(
                        color: AppColors.red,
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.8,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  static Widget _buildSummaryItem(String label, String value, IconData icon, Color color) {
    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 13),
            const SizedBox(width: 4),
            Text(
              label,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 11,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 15,
            fontWeight: FontWeight.w800,
            fontFamily: 'monospace',
          ),
        ),
      ],
    );
  }

  static Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(
        color: AppColors.textMuted,
        fontSize: 11,
        fontWeight: FontWeight.w800,
        letterSpacing: 1.2,
      ),
    );
  }

  static Widget _buildActionTile({
    required IconData icon,
    required String title,
    required String subtitle,
    String? badge,
    Color? badgeColor,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: AppColors.cardLighter,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: AppColors.textPrimary, size: 20),
        ),
        title: Text(
          title,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(
            color: AppColors.textSecondary,
            fontSize: 11,
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (badge != null)
              Container(
                margin: const EdgeInsets.only(right: 8),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: (badgeColor ?? AppColors.accent).withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: (badgeColor ?? AppColors.accent).withOpacity(0.4)),
                ),
                child: Text(
                  badge,
                  style: TextStyle(
                    color: badgeColor ?? AppColors.accent,
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            const Icon(LucideIcons.chevronRight, color: AppColors.textMuted, size: 18),
          ],
        ),
        onTap: onTap,
      ),
    );
  }
}
