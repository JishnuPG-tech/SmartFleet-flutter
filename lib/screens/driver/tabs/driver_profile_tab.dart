import "package:flutter/material.dart";
import "../../../core/design/tokens/app_colors.dart";
import "../../../core/design/tokens/app_typography.dart";
import "../../../core/design/tokens/app_spacing.dart";
import "../../../core/design/components/buttons.dart";
import "../../../core/design/theme/theme_controller.dart";
import "../../../core/data/models/driver.dart";
import "../../../core/data/seed_data.dart";
import "../../../l10n/app_localizations.dart";
import "../../auth/role_select_screen.dart";

class DriverProfileTab extends StatefulWidget {
  final Driver? driver;
  final String? driverId;
  final VoidCallback? onToggleLanguage;

  const DriverProfileTab({
    super.key,
    this.driver,
    this.driverId,
    this.onToggleLanguage,
  });

  @override
  State<DriverProfileTab> createState() => _DriverProfileTabState();
}

class _DriverProfileTabState extends State<DriverProfileTab> {
  Driver get effectiveDriver {
    if (widget.driver != null) return widget.driver!;
    return SeedData.drivers.firstWhere(
      (d) => d.id == widget.driverId,
      orElse: () => SeedData.drivers.first,
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = AppLocalizations.of(context);
    final d = effectiveDriver;
    final isDark = ThemeController.instance.isDark(context);

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
      children: [
        // DRIVER IDENTITY CARD
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          decoration: BoxDecoration(
            color: colors.surface,
            borderRadius: AppSpacing.cardBorderRadius,
            border: Border.all(color: colors.border, width: 1.0),
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: colors.surfaceAlt,
                child: Icon(Icons.person_rounded, size: 28, color: colors.brand),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      d.name,
                      style: AppTypography.title(colors.text, fontSize: 18),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      d.phone,
                      style: AppTypography.supporting(colors.textSecondary, fontSize: 13),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 12),

        // VEHICLE & LICENCE DETAILS
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: colors.surface,
            borderRadius: AppSpacing.cardBorderRadius,
            border: Border.all(color: colors.border, width: 1.0),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildInfoRow(context, "Assigned vehicle", d.assignedTruckPlate),
              const Divider(height: 20),
              _buildInfoRow(context, "Driving licence", d.licenceNumber),
              const Divider(height: 20),
              _buildInfoRow(context, "Experience", "${d.experienceYears} Years"),
            ],
          ),
        ),

        const SizedBox(height: 12),

        // THEME PREFERENCE (Midnight Black / Pure White)
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: colors.surface,
            borderRadius: AppSpacing.cardBorderRadius,
            border: Border.all(color: colors.border, width: 1.0),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Icon(
                      isDark ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
                      size: 20,
                      color: colors.brand,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        isDark ? "Midnight Black" : "Pure White",
                        style: AppTypography.section(colors.text, fontSize: 15),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              Switch(
                value: isDark,
                activeColor: colors.brand,
                onChanged: (val) {
                  setState(() {
                    ThemeController.instance.setThemeMode(val ? ThemeMode.dark : ThemeMode.light);
                  });
                },
              ),
            ],
          ),
        ),

        const SizedBox(height: 14),

        // LANGUAGE BUTTON
        SecondaryButton(
          label: "Change language (English / മലയാളം)",
          icon: Icons.language_rounded,
          height: 48,
          onPressed: widget.onToggleLanguage,
        ),

        const SizedBox(height: 10),

        // SIGN OUT
        DangerButton(
          label: l10n.btnLogout,
          icon: Icons.logout_rounded,
          height: 48,
          confirmTitle: "Switch role / Sign out?",
          confirmMessage: "You will return to the role selection screen.",
          confirmActionLabel: "Sign out",
          onConfirmed: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => RoleSelectScreen(onToggleLanguage: widget.onToggleLanguage)),
              (route) => false,
            );
          },
        ),
      ],
    );
  }

  Widget _buildInfoRow(BuildContext context, String label, String value) {
    final colors = context.colors;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            label,
            style: AppTypography.supporting(colors.textSecondary, fontSize: 13),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(width: 8),
        Text(value, style: AppTypography.section(colors.text, fontSize: 14, isNumber: true)),
      ],
    );
  }
}
