import 'package:flutter/material.dart';
import 'package:smartfleet_flutter/core/data/models/trip.dart';
import 'package:smartfleet_flutter/core/data/models/truck.dart';
import 'package:smartfleet_flutter/core/data/fleet_repository.dart';
import 'package:smartfleet_flutter/core/theme/app_theme.dart';
import 'package:smartfleet_flutter/l10n/app_localizations.dart';

String _getGreeting(DateTime now, String morning, String afternoon, String evening) {
  final hour = now.hour;
  if (hour >= 5 && hour < 12) {
    return morning;
  } else if (hour >= 12 && hour < 17) {
    return afternoon;
  } else {
    return evening;
  }
}

class AdminHomeTab extends StatelessWidget {
  final VoidCallback onNewTrip;
  final VoidCallback onViewAllTrips;

  const AdminHomeTab({
    super.key,
    required this.onNewTrip,
    required this.onViewAllTrips,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final now = DateTime.now();
    final greeting = _getGreeting(
      now,
      l10n.greetingMorning,
      l10n.greetingAfternoon,
      l10n.greetingEvening,
    );

    return StreamBuilder<List<Trip>>(
      stream: LocalFleetRepository.instance.watchTrips(),
      builder: (context, tripSnap) {
        return StreamBuilder<List<Truck>>(
          stream: LocalFleetRepository.instance.watchTrucks(),
          builder: (context, truckSnap) {
            final trips = tripSnap.data ?? [];
            final trucks = truckSnap.data ?? [];

            final runningCount = trips.where((t) => t.status == TripStatus.running).length;
            final waitingCount = trips.where((t) => t.status == TripStatus.waiting).length;
            final deliveredCount = trips.where((t) => t.status == TripStatus.delivered).length;

            final activeTruckPlates = trips
                .where((t) => t.status != TripStatus.delivered)
                .map((t) => t.truckPlate)
                .toSet();

            final availableTrucks = trucks
                .where((t) => t.status != TruckStatus.inWorkshop && !activeTruckPlates.contains(t.plate))
                .length;

            final workshopTrucks = trucks.where((t) => t.status == TruckStatus.inWorkshop).toList();

            return ListView(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 24),
              children: [
                // GREETING
                Text(
                  greeting,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w900,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  l10n.tagline,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textSecondary,
                  ),
                ),

                const SizedBox(height: 20),

                // PRIMARY ACTION: + NEW TRIP BUTTON
                ElevatedButton(
                  onPressed: onNewTrip,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.add, size: 26),
                      const SizedBox(width: 8),
                      Flexible(
                        child: Text(
                          l10n.btnNewTrip,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // 3 BIG METRIC CARDS
                // 1. Running Trips
                _buildBigMetricCard(
                  title: l10n.runningTrips,
                  count: runningCount,
                  icon: Icons.navigation,
                  accentColor: AppColors.statusRunningText,
                  bgColor: AppColors.statusRunningBg,
                ),

                const SizedBox(height: 12),

                // 2. Free Trucks
                _buildBigMetricCard(
                  title: l10n.freeTrucks,
                  count: availableTrucks,
                  icon: Icons.local_shipping,
                  accentColor: AppColors.statusDoneText,
                  bgColor: AppColors.statusDoneBg,
                ),

                const SizedBox(height: 12),

                // 3. Delivered this Month
                _buildBigMetricCard(
                  title: l10n.deliveredThisMonth,
                  count: deliveredCount,
                  icon: Icons.check_circle,
                  accentColor: AppColors.statusDoneText,
                  bgColor: AppColors.statusDoneBg,
                ),

                const SizedBox(height: 24),

                // NEEDS ATTENTION SECTION
                if (workshopTrucks.isNotEmpty || waitingCount > 0) ...[
                  Row(
                    children: [
                      const Icon(Icons.warning_amber_rounded, color: AppColors.statusProblemText, size: 26),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          l10n.needsAttention,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                            color: AppColors.statusProblemText,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Workshop alerts
                  ...workshopTrucks.map((t) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.statusProblemBg,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: AppColors.statusProblemText.withOpacity(0.4), width: 1.5),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.build, color: AppColors.statusProblemText, size: 28),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    t.plate,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w800,
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                  Text(
                                    '${t.model} · ${l10n.statusInWorkshop}',
                                    style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.statusProblemText,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),

                  // Waiting trip alerts
                  if (waitingCount > 0)
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.statusWaitingBg,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: AppColors.statusWaitingText.withOpacity(0.4), width: 1.5),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.hourglass_empty, color: AppColors.statusWaitingText, size: 28),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              '$waitingCount trip(s) waiting for driver confirmation',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: AppColors.statusWaitingText,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  const SizedBox(height: 20),
                ],

                // VIEW ALL TRIPS BUTTON
                OutlinedButton(
                  onPressed: onViewAllTrips,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.receipt_long, color: AppColors.accent),
                      const SizedBox(width: 8),
                      Flexible(
                        child: Text(
                          l10n.tabTrips,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildBigMetricCard({
    required String title,
    required int count,
    required IconData icon,
    required Color accentColor,
    required Color bgColor,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, size: 32, color: accentColor),
            ),
            const SizedBox(width: 18),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    count.toString(),
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.w900,
                      color: accentColor,
                      height: 1.1,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
