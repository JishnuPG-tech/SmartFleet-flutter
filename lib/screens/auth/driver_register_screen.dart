import 'package:flutter/material.dart';
import 'package:smartfleet_flutter/core/components/lucide_compat.dart';
import '../../core/theme/app_colors.dart';
import '../../core/state/fleet_state.dart';
import '../driver/driver_main_screen.dart';

class DriverRegisterScreen extends StatefulWidget {
  const DriverRegisterScreen({super.key});

  @override
  State<DriverRegisterScreen> createState() => _DriverRegisterScreenState();
}

class _DriverRegisterScreenState extends State<DriverRegisterScreen> {
  final _nameController = TextEditingController(text: 'Rajesh Varma');
  final _phoneController = TextEditingController(text: '+91 94471 89201');
  final _licenseController = TextEditingController(text: 'KL-07-2015-0082910');
  final _plateController = TextEditingController(text: 'KL 07 CD 5678');
  final _modelController = TextEditingController(text: 'Tata Prima 3530.K (35T Multi-Axle)');
  final _experienceController = TextEditingController(text: '6');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.midnightBlack,
      appBar: AppBar(
        backgroundColor: AppColors.midnightBlack,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(LucideIcons.arrowLeft, color: AppColors.pureWhite),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Driver Pilot Onboarding',
          style: TextStyle(
            color: AppColors.pureWhite,
            fontSize: 16,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          children: [
            // Branding Ribbon
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.cardCharcoal,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.hairline),
              ),
              child: const Row(
                children: [
                  Icon(LucideIcons.shieldCheck, color: AppColors.accent, size: 28),
                  SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Govt Sarathi KYC Compliance',
                          style: TextStyle(
                            color: AppColors.pureWhite,
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'Your commercial HMV credentials will be verified against Kerala MVD records.',
                          style: TextStyle(
                            color: AppColors.mutedGray,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            _buildField('FULL PILOT NAME', _nameController, LucideIcons.user),
            const SizedBox(height: 12),
            _buildField('REGISTERED MOBILE (FOR SMS/OTP)', _phoneController, LucideIcons.phone),
            const SizedBox(height: 12),
            _buildField('COMMERCIAL DRIVING LICENCE (HMV)', _licenseController, LucideIcons.idCard),
            const SizedBox(height: 12),
            _buildField('ASSIGNED TRUCK REGISTRATION (PLATE)', _plateController, LucideIcons.truck),
            const SizedBox(height: 12),
            _buildField('TRUCK MAKE & MODEL', _modelController, LucideIcons.package),
            const SizedBox(height: 12),
            _buildField('YEARS OF HEAVY VEHICLE EXPERIENCE', _experienceController, LucideIcons.award),
            const SizedBox(height: 26),

            // Submit Button
            SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.accent,
                  foregroundColor: AppColors.midnightBlack,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 0,
                ),
                onPressed: () {
                  FleetState.instance.loginDriver(
                    name: _nameController.text.trim(),
                    phone: _phoneController.text.trim(),
                    license: _licenseController.text.trim(),
                    vehiclePlate: _plateController.text.trim(),
                  );
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => const DriverMainScreen()),
                    (route) => false,
                  );
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      backgroundColor: AppColors.cardCharcoal,
                      content: Row(
                        children: [
                          const Icon(LucideIcons.checkCircle2, color: AppColors.accent),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              'Welcome ${_nameController.text.trim()}! Cockpit initialized.',
                              style: const TextStyle(color: AppColors.pureWhite),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
                icon: const Icon(LucideIcons.userCheck, size: 20),
                label: const Text(
                  'COMPLETE REGISTRATION & ENTER COCKPIT',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 0.6,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildField(String label, TextEditingController controller, IconData icon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: AppColors.darkSubtext,
            fontSize: 10,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.8,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          decoration: BoxDecoration(
            color: AppColors.cardCharcoal,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.hairline),
          ),
          child: Row(
            children: [
              Icon(icon, size: 16, color: AppColors.mutedGray),
              const SizedBox(width: 10),
              Expanded(
                child: TextField(
                  controller: controller,
                  style: const TextStyle(
                    color: AppColors.pureWhite,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
