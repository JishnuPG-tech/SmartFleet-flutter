import "package:flutter/material.dart";
import "../../core/design/tokens/app_colors.dart";
import "../../core/design/tokens/app_typography.dart";
import "../../core/design/components/buttons.dart";
import "../../core/data/models/driver.dart";
import "../../core/data/fleet_repository.dart";
import "../../l10n/app_localizations.dart";
import "../admin/admin_main_screen.dart";
import "../driver/driver_main_screen.dart";

class RoleSelectScreen extends StatelessWidget {
  final VoidCallback? onToggleLanguage;
  final Locale? currentLocale;
  final ValueChanged<Locale>? onLocaleChanged;

  const RoleSelectScreen({
    super.key,
    this.onToggleLanguage,
    this.currentLocale,
    this.onLocaleChanged,
  });

  void _loginAsOwner(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => AdminMainScreen(onToggleLanguage: onToggleLanguage),
      ),
    );
  }

  void _showDriverPicker(BuildContext context, AppLocalizations l10n, List<Driver> drivers) {
    final colors = context.colors;

    showModalBottomSheet(
      context: context,
      backgroundColor: colors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.driverSelectTitle,
                  style: AppTypography.title(colors.text),
                ),
                Text(
                  l10n.demoLoginNotice,
                  style: AppTypography.label(colors.textSecondary),
                ),
                const SizedBox(height: 20),
                ...drivers.map((driver) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Card(
                      child: ListTile(
                        leading: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: colors.brand.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(Icons.person_rounded, color: colors.brand),
                        ),
                        title: Text(driver.name, style: AppTypography.heading(colors.text)),
                        subtitle: Text(
                          "${driver.assignedTruckPlate} · ${driver.phone}",
                          style: AppTypography.body(colors.textSecondary),
                        ),
                        trailing: const Icon(Icons.chevron_right_rounded),
                        onTap: () {
                          Navigator.pop(ctx);
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (_) => DriverMainScreen(
                                driver: driver,
                                onToggleLanguage: onToggleLanguage,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: colors.bg,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          if (onToggleLanguage != null)
            TextButton.icon(
              onPressed: onToggleLanguage,
              icon: Icon(Icons.language_rounded, size: 22, color: colors.brand),
              label: Text(
                Localizations.localeOf(context).languageCode == "ml" ? "English" : "മലയാളം",
                style: AppTypography.label(colors.brand),
              ),
            ),
          const SizedBox(width: 8),
        ],
      ),
      body: StreamBuilder<List<Driver>>(
        stream: LocalFleetRepository.instance.watchDrivers(),
        builder: (context, snapshot) {
          final drivers = snapshot.data ?? [];

          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: colors.brand.withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.local_shipping_rounded, size: 64, color: colors.brand),
                ),
                const SizedBox(height: 24),

                Text(
                  l10n.appTitle,
                  style: AppTypography.display(colors.text),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 6),
                Text(
                  l10n.tagline,
                  style: AppTypography.heading(colors.textSecondary),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 48),

                // DRIVER BUTTON (Primary)
                PrimaryButton(
                  label: l10n.driverRole,
                  icon: Icons.person_pin_rounded,
                  onPressed: () => _showDriverPicker(context, l10n, drivers),
                ),

                const SizedBox(height: 16),

                // OWNER BUTTON (Secondary)
                SecondaryButton(
                  label: l10n.ownerRole,
                  icon: Icons.business_center_rounded,
                  onPressed: () => _loginAsOwner(context),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
