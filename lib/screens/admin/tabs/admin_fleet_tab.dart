import 'package:flutter/material.dart';
import 'package:smartfleet_flutter/core/components/status_chip.dart';
import 'package:smartfleet_flutter/core/data/models/truck.dart';
import 'package:smartfleet_flutter/core/data/fleet_repository.dart';
import 'package:smartfleet_flutter/core/theme/app_theme.dart';
import 'package:smartfleet_flutter/l10n/app_localizations.dart';

class AdminFleetTab extends StatelessWidget {
  const AdminFleetTab({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return StreamBuilder<List<Truck>>(
      stream: LocalFleetRepository.instance.watchTrucks(),
      builder: (context, snapshot) {
        final trucks = snapshot.data ?? [];

        return ListView.builder(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
          itemCount: trucks.length,
          itemBuilder: (context, index) {
            final truck = trucks[index];

            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Plate + Status Chip
                      Wrap(
                        alignment: WrapAlignment.spaceBetween,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          Text(
                            truck.plate,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w900,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          StatusChip.forTruck(context, truck.status),
                        ],
                      ),

                      const SizedBox(height: 12),

                      // Model & Capacity
                      Text(
                        '${truck.model} · ${truck.capacityTons}T ${l10n.truckCapacity}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),

                      const SizedBox(height: 6),

                      // Assigned driver
                      Text(
                        truck.assignedDriverId.isNotEmpty
                            ? 'Assigned Driver ID: ${truck.assignedDriverId}'
                            : 'No driver currently assigned',
                        style: const TextStyle(
                          fontSize: 15,
                          color: AppColors.textSecondary,
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
