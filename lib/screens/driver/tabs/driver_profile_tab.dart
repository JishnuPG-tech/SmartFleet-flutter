import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:smartfleet_flutter/core/data/models/driver.dart';
import 'package:smartfleet_flutter/core/data/models/truck.dart';
import 'package:smartfleet_flutter/core/data/fleet_repository.dart';
import 'package:smartfleet_flutter/core/theme/app_theme.dart';
import 'package:smartfleet_flutter/l10n/app_localizations.dart';

class DriverProfileTab extends StatelessWidget {
  final String driverId;
  final VoidCallback onToggleLanguage;

  const DriverProfileTab({
    super.key,
    required this.driverId,
    required this.onToggleLanguage,
  });

  Future<void> _callOffice() async {
    final uri = Uri.parse('tel:+919847123456');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return FutureBuilder<List<dynamic>>(
      future: Future.wait([
        LocalFleetRepository.instance.getDriverById(driverId),
        LocalFleetRepository.instance.getTrucks(),
      ]),
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data![0] == null) {
          return const Center(child: CircularProgressIndicator());
        }

        final driver = snapshot.data![0] as Driver;
        final trucks = snapshot.data![1] as List<Truck>;
        final assignedTruck = trucks.firstWhere(
          (t) => t.plate == driver.assignedTruckPlate,
          orElse: () => Truck(
            plate: driver.assignedTruckPlate,
            model: 'Commercial Heavy Hauler',
            capacityTons: 28,
            assignedDriverId: driver.id,
            status: TruckStatus.onTrip,
          ),
        );

        return ListView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
          children: [
            // Driver Profile Header Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 36,
                      backgroundColor: AppColors.accent,
                      child: Text(
                        driver.name.isNotEmpty ? driver.name[0] : 'D',
                        style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            driver.name,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w800,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            driver.phone,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            l10n.years(driver.experienceYears),
                            style: const TextStyle(
                              fontSize: 16,
                              color: AppColors.accent,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Driving Licence Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.driverLicence,
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textSecondary),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      driver.licenceNumber,
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: AppColors.textPrimary),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      l10n.licenceValidity('October 2029'),
                      style: const TextStyle(fontSize: 16, color: AppColors.textSecondary),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Assigned Truck Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.assignedTruck,
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textSecondary),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      assignedTruck.plate,
                      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: AppColors.textPrimary),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '${assignedTruck.model} · ${assignedTruck.capacityTons} Tons',
                      style: const TextStyle(fontSize: 16, color: AppColors.textSecondary),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Language & Office Action Buttons
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.surfaceCard,
                foregroundColor: AppColors.textPrimary,
                side: const BorderSide(color: AppColors.border, width: 2),
              ),
              onPressed: onToggleLanguage,
              icon: const Icon(Icons.language, color: AppColors.accent),
              label: Text(l10n.btnChangeLanguage),
            ),

            const SizedBox(height: 14),

            ElevatedButton.icon(
              onPressed: _callOffice,
              icon: const Icon(Icons.phone),
              label: Text(l10n.btnCallOffice),
            ),

            const SizedBox(height: 14),

            OutlinedButton.icon(
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(Icons.logout),
              label: Text(l10n.btnLogout),
            ),
          ],
        );
      },
    );
  }
}
