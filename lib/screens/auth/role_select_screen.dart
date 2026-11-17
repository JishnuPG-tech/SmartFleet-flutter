import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../core/theme/app_colors.dart';
import '../admin/admin_main_screen.dart';
import '../driver/driver_main_screen.dart';
import 'driver_register_screen.dart';

class RoleSelectScreen extends StatelessWidget {
  const RoleSelectScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.midnightBlack,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Spacer(),
              // Brand Mark
              Container(
                width: 54,
                height: 54,
                decoration: BoxDecoration(
                  color: AppColors.acidLime,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.acidLime.withOpacity(0.3),
                      blurRadius: 16,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Center(
                  child: Icon(
                    Icons.local_shipping,
                    color: AppColors.midnightBlack,
                    size: 30,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'SMARTFLEET',
                style: TextStyle(
                  color: AppColors.pureWhite,
                  fontSize: 32,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'MOVE SMART. MANAGE BETTER.',
                style: TextStyle(
                  color: AppColors.acidLime,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.5,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Enterprise commercial fleet management & driver cockpit operations.',
                style: TextStyle(
                  color: AppColors.mutedGray,
                  fontSize: 14,
                  height: 1.4,
                ),
              ),
              const Spacer(),

              // Role Option: Fleet Owner / Admin
              _buildRoleCard(
                context,
                title: 'Fleet Owner / Admin',
                subtitle: 'Manage trips, lorries, drivers & live telemetry',
                icon: Icons.dashboard_customize,
                accentColor: AppColors.acidLime,
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const AdminMainScreen()),
                  );
                },
              ),
              const SizedBox(height: 16),

              // Role Option: Lorry Driver
              _buildRoleCard(
                context,
                title: 'Lorry Driver / Pilot',
                subtitle: 'Active mission boarding pass, route & proof of delivery',
                icon: Icons.airline_seat_recline_normal,
                accentColor: AppColors.skyInfo,
                onTap: () {
                  _showDriverOptionsSheet(context);
                },
              ),
              const SizedBox(height: 24),
              const Center(
                child: Text(
                  'v2.0.0 · Commercial Android Edition',
                  style: TextStyle(
                    color: AppColors.darkSubtext,
                    fontSize: 11,
                    fontFamily: 'monospace',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showDriverOptionsSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: AppColors.cardCharcoal,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
            const SizedBox(height: 18),
            const Text(
              'DRIVER ACCESS',
              style: TextStyle(
                color: AppColors.skyInfo,
                fontSize: 11,
                fontWeight: FontWeight.w800,
                letterSpacing: 1.0,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Choose Entry Mode',
              style: TextStyle(
                color: AppColors.pureWhite,
                fontSize: 20,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 20),

            _buildSheetOption(
              icon: LucideIcons.gauge,
              title: 'Enter Cockpit (Suresh Kumar)',
              subtitle: 'Active mission #TR-1025 · KL 11 AB 1234',
              color: AppColors.accent,
              onTap: () {
                Navigator.pop(context);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const DriverMainScreen()),
                );
              },
            ),
            const SizedBox(height: 12),

            _buildSheetOption(
              icon: LucideIcons.userPlus,
              title: 'Register New Driver & Truck',
              subtitle: 'Sarathi KYC onboarding, license & vehicle registration',
              color: AppColors.blue,
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const DriverRegisterScreen()),
                );
              },
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildSheetOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.midnightBlack,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.hairline),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withOpacity(0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: AppColors.pureWhite,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: AppColors.mutedGray,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(LucideIcons.chevronRight, color: AppColors.mutedGray, size: 18),
          ],
        ),
      ),
    );
  }

  Widget _buildRoleCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required Color accentColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.cardCharcoal,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppColors.hairline, width: 0.8),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: accentColor.withOpacity(0.12),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, color: accentColor, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: AppColors.pureWhite,
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: AppColors.mutedGray,
                      fontSize: 12,
                      height: 1.3,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              size: 14,
              color: AppColors.mutedGray,
            ),
          ],
        ),
      ),
    );
  }
}
