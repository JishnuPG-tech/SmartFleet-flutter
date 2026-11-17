import "package:flutter/material.dart";
import "../../../core/design/tokens/app_colors.dart";
import "../../../core/design/tokens/app_typography.dart";
import "../../../core/design/components/buttons.dart";
import "../../../core/data/models/driver.dart";
import "../../../core/data/seed_data.dart";
import "../../../l10n/app_localizations.dart";
import "../../auth/role_select_screen.dart";

class DriverProfileTab extends StatelessWidget {
  final Driver? driver;
  final String? driverId;
  final VoidCallback? onToggleLanguage;

  const DriverProfileTab({
    super.key,
    this.driver,
    this.driverId,
    this.onToggleLanguage,
  }) : assert(driver != null || driverId != null);

  Driver get effectiveDriver {
    if (driver != null) return driver!;
    return SeedData.drivers.firstWhere(
      (d) => d.id == driverId,
      orElse: () => SeedData.drivers.first,
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = AppLocalizations.of(context);
    final d = effectiveDriver;

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 100),
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: colors.brand.withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.person_rounded, size: 56, color: colors.brand),
                ),
                const SizedBox(height: 16),
                Text(
                  d.name,
                  style: AppTypography.title(colors.text),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 4),
                Text(
                  d.phone,
                  style: AppTypography.body(colors.textSecondary),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 16),

        Card(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildInfoRow(context, l10n.assignedTruck, d.assignedTruckPlate),
                const Divider(height: 24),
                _buildInfoRow(context, l10n.driverLicence, d.licenceNumber),
                const Divider(height: 24),
                _buildInfoRow(context, l10n.driverExperience, l10n.years(d.experienceYears.toString())),
              ],
            ),
          ),
        ),

        const SizedBox(height: 24),

        SecondaryButton(
          label: l10n.btnChangeLanguage,
          icon: Icons.language_rounded,
          onPressed: onToggleLanguage,
        ),

        const SizedBox(height: 14),

        DangerButton(
          label: l10n.btnLogout,
          icon: Icons.logout_rounded,
          confirmTitle: "Switch User / Logout?",
          confirmMessage: "You will return to the role selection screen.",
          confirmActionLabel: "Yes, Logout",
          onConfirmed: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => RoleSelectScreen(onToggleLanguage: onToggleLanguage)),
              (route) => false,
            );
          },
        ),
      ],
    );
  }

  Widget _buildInfoRow(BuildContext context, String label, String value) {
    final colors = context.colors;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTypography.label(colors.textSecondary)),
        const SizedBox(height: 4),
        Text(value, style: AppTypography.heading(colors.text)),
      ],
    );
  }
}
