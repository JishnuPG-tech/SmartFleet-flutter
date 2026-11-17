import 'package:flutter/material.dart';
import 'package:smartfleet_flutter/core/data/models/driver.dart';
import 'package:smartfleet_flutter/core/data/fleet_repository.dart';
import 'package:smartfleet_flutter/core/theme/app_theme.dart';
import 'package:smartfleet_flutter/l10n/app_localizations.dart';
import 'package:smartfleet_flutter/screens/driver/driver_main_screen.dart';
// Note: OwnerMainScreen will be built in Phase 3; for now role select navigates to Driver or shows placeholder/nav
import 'package:smartfleet_flutter/screens/admin/admin_main_screen.dart';

class RoleSelectScreen extends StatelessWidget {
  final Locale currentLocale;
  final Function(Locale)? onLocaleChanged;

  const RoleSelectScreen({
    super.key,
    this.currentLocale = const Locale('ml'),
    this.onLocaleChanged,
  });

  void _showDriverLoginSheet(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    // DEMO LOGIN NOTE: Until real backend authentication is connected,
    // drivers select their name from the verified roster.
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.background,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return FutureBuilder<List<Driver>>(
          future: LocalFleetRepository.instance.getDrivers(),
          builder: (context, snapshot) {
            final drivers = snapshot.data ?? [];
            return Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        l10n.driverSelectTitle,
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.pop(ctx),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    l10n.demoLoginNotice,
                    style: const TextStyle(fontSize: 14, color: AppColors.textSecondary, fontStyle: FontStyle.italic),
                  ),
                  const SizedBox(height: 16),
                  ...drivers.map((d) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          alignment: Alignment.centerLeft,
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        ),
                        onPressed: () {
                          Navigator.pop(ctx);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => DriverMainScreen(
                                driverId: d.id,
                                onToggleLanguage: () {
                                  final newLoc = currentLocale.languageCode == 'ml'
                                      ? const Locale('en')
                                      : const Locale('ml');
                                  onLocaleChanged?.call(newLoc);
                                },
                              ),
                            ),
                          );
                        },
                        child: Row(
                          children: [
                            const Icon(Icons.person, color: AppColors.accent, size: 28),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    d.name,
                                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                                  ),
                                  Text(
                                    '${d.assignedTruckPlate} · ${d.phone}',
                                    style: const TextStyle(fontSize: 14, color: AppColors.textSecondary),
                                  ),
                                ],
                              ),
                            ),
                            const Icon(Icons.arrow_forward_ios, size: 16, color: AppColors.textSecondary),
                          ],
                        ),
                      ),
                    );
                  }),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isMl = currentLocale.languageCode == 'ml';

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 16),

              // Logo & App Name
              Center(
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.accent,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Icon(Icons.local_shipping, size: 64, color: Colors.white),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                l10n.appTitle,
                style: const TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.w900,
                  color: AppColors.textPrimary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                l10n.tagline,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 24),

              // Language Choice: Two Big Buttons
              Text(
                l10n.selectLanguage,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isMl ? AppColors.accent : AppColors.surfaceCard,
                        foregroundColor: isMl ? Colors.white : AppColors.textPrimary,
                        side: BorderSide(
                          color: isMl ? AppColors.accent : AppColors.border,
                          width: 2,
                        ),
                      ),
                      onPressed: () => onLocaleChanged?.call(const Locale('ml')),
                      child: Text(l10n.malayalam),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: !isMl ? AppColors.accent : AppColors.surfaceCard,
                        foregroundColor: !isMl ? Colors.white : AppColors.textPrimary,
                        side: BorderSide(
                          color: !isMl ? AppColors.accent : AppColors.border,
                          width: 2,
                        ),
                      ),
                      onPressed: () => onLocaleChanged?.call(const Locale('en')),
                      child: Text(l10n.english),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 32),

              // Large Role Selection Buttons
              // Driver Role with STEERING WHEEL icon
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(64),
                ),
                onPressed: () => _showDriverLoginSheet(context),
                icon: const Icon(Icons.drive_eta, size: 30),
                label: Text(
                  l10n.driverRole,
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
              ),

              const SizedBox(height: 16),

              // Owner Role with BUILDING icon
              OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size.fromHeight(64),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const AdminMainScreen(),
                    ),
                  );
                },
                icon: const Icon(Icons.business, size: 30, color: AppColors.accent),
                label: Text(
                  l10n.ownerRole,
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
