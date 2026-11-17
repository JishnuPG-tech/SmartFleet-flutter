import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../core/theme/app_colors.dart';
import '../../auth/role_select_screen.dart';

class DriverProfileTab extends StatelessWidget {
  const DriverProfileTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          children: [
            // Driver Profile Header Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.card,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                children: [
                  Stack(
                    children: [
                      Container(
                        width: 76,
                        height: 76,
                        decoration: BoxDecoration(
                          color: AppColors.cardLighter,
                          shape: BoxShape.circle,
                          border: Border.all(color: AppColors.accent, width: 2),
                        ),
                        child: const Center(
                          child: Text(
                            'SK',
                            style: TextStyle(
                              color: AppColors.accent,
                              fontSize: 26,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: AppColors.green,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(LucideIcons.check, size: 12, color: Colors.black),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Suresh Kumar',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -0.3,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    '+91 98472 10982 · HMV Senior Pilot',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Verification Pill
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.green.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppColors.green.withOpacity(0.3)),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(LucideIcons.shieldCheck, color: AppColors.green, size: 14),
                        SizedBox(width: 6),
                        Text(
                          'GOVT KYC & SARATHI VERIFIED',
                          style: TextStyle(
                            color: AppColors.green,
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.8,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Credentials Group
            _buildSectionHeader('PILOT CREDENTIALS & ASSET'),
            const SizedBox(height: 10),
            _buildInfoTile(
              icon: LucideIcons.idCard,
              title: 'Heavy Motor Vehicle Licence (HMV)',
              subtitle: 'KL-11-2012-0049281 · Valid till Oct 2029',
              badge: 'VALID',
              badgeColor: AppColors.green,
            ),
            _buildInfoTile(
              icon: LucideIcons.truck,
              title: 'Assigned Prime Mover',
              subtitle: 'KL 11 AB 1234 · BharatBenz 2823C (28 Ton Multi-Axle)',
            ),
            _buildInfoTile(
              icon: LucideIcons.heartPulse,
              title: 'Annual Driver Medical & Vision Check',
              subtitle: 'Certified at Aster Medcity Kochi · Grade A1 Fit',
            ),

            const SizedBox(height: 20),

            // Payout & Banking
            _buildSectionHeader('PAYOUTS & BATA ACCOUNT'),
            const SizedBox(height: 10),
            _buildInfoTile(
              icon: LucideIcons.landmark,
              title: 'Direct Bank Settlement (Bata & Toll)',
              subtitle: 'Federal Bank Ltd · A/C Ending in **8192',
            ),
            _buildInfoTile(
              icon: LucideIcons.qrCode,
              title: 'Instant UPI Payout ID',
              subtitle: 'suresh.kumar@okhdfcbank',
            ),

            const SizedBox(height: 20),

            // App & Preferences
            _buildSectionHeader('APP PREFERENCES'),
            const SizedBox(height: 10),
            _buildInfoTile(
              icon: LucideIcons.languages,
              title: 'Voice & Interface Language',
              subtitle: 'English (Malayalam & Tamil audio navigation active)',
            ),
            _buildInfoTile(
              icon: LucideIcons.database,
              title: 'Offline Manifest & Map Cache',
              subtitle: 'NH-66 & NH-544 offline maps downloaded (42 MB)',
            ),

            const SizedBox(height: 28),

            // Switch Role / Logout
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

  static Widget _buildInfoTile({
    required IconData icon,
    required String title,
    required String subtitle,
    String? badge,
    Color? badgeColor,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: AppColors.cardLighter,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: AppColors.textPrimary, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 11,
                  ),
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
                style: TextStyle(
                  color: badgeColor ?? AppColors.accent,
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
