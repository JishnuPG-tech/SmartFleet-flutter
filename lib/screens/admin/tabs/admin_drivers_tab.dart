import 'package:flutter/material.dart';
import 'package:smartfleet_flutter/core/data/models/driver.dart';
import 'package:smartfleet_flutter/core/data/fleet_repository.dart';
import 'package:smartfleet_flutter/core/theme/app_theme.dart';
import 'package:smartfleet_flutter/l10n/app_localizations.dart';

class AdminDriversTab extends StatelessWidget {
  const AdminDriversTab({super.key});

  void _callDriver(BuildContext context, String phone) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Calling $phone...')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return StreamBuilder<List<Driver>>(
      stream: LocalFleetRepository.instance.watchDrivers(),
      builder: (context, snapshot) {
        final drivers = snapshot.data ?? [];

        return ListView.builder(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
          itemCount: drivers.length,
          itemBuilder: (context, index) {
            final driver = drivers[index];
            final isLicenceValid = !driver.isLicencePlaceholder;

            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header: Driver Name + Call Button
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: AppColors.background,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: AppColors.border),
                            ),
                            child: const Icon(Icons.person, color: AppColors.accent, size: 28),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  driver.name,
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w800,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  driver.phone,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.phone, color: AppColors.accent, size: 28),
                            tooltip: l10n.btnCall,
                            onPressed: () => _callDriver(context, driver.phone),
                          ),
                        ],
                      ),

                      const Divider(height: 24, color: AppColors.border),

                      // Assigned Truck & Experience
                      Wrap(
                        alignment: WrapAlignment.spaceBetween,
                        spacing: 8,
                        runSpacing: 6,
                        children: [
                          Text(
                            driver.assignedTruckPlate,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          Text(
                            l10n.years(driver.experienceYears),
                            style: const TextStyle(
                              fontSize: 15,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 10),

                      // Licence details with status badge
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: isLicenceValid ? AppColors.statusDoneBg : AppColors.statusWaitingBg,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              isLicenceValid ? Icons.verified : Icons.warning_amber,
                              size: 18,
                              color: isLicenceValid ? AppColors.statusDoneText : AppColors.statusWaitingText,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                '${driver.licenceNumber} · ${isLicenceValid ? "Valid" : "Needs Update"}',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: isLicenceValid ? AppColors.statusDoneText : AppColors.statusWaitingText,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
