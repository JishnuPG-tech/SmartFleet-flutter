import "package:flutter/material.dart";
import "../../../core/design/tokens/app_colors.dart";
import "../../../core/design/tokens/app_typography.dart";
import "../../../core/design/tokens/app_spacing.dart";
import "../../../core/design/components/kpi_tile.dart";
import "../../../core/design/components/buttons.dart";
import "../../../core/data/models/trip.dart";
import "../../../core/data/models/truck.dart";
import "../../../core/data/fleet_repository.dart";
import "../../../l10n/app_localizations.dart";

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
    final colors = context.colors;
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
                  style: AppTypography.display(colors.text),
                ),
                const SizedBox(height: 4),
                Text(
                  l10n.tagline,
                  style: AppTypography.body(colors.textSecondary),
                ),

                const SizedBox(height: 20),

                // NEW TRIP BUTTON (Single + Icon + Label)
                PrimaryButton(
                  label: l10n.btnNewTrip,
                  icon: Icons.add_rounded,
                  onPressed: onNewTrip,
                ),

                const SizedBox(height: 24),

                // 3 BIG METRIC TILES
                // 1. Running Trips
                KpiTile(
                  label: l10n.runningTrips,
                  count: runningCount,
                  icon: Icons.navigation_rounded,
                  accentColor: colors.brand,
                  containerColor: colors.statusRunningContainer,
                ),

                const SizedBox(height: 12),

                // 2. Free Trucks (Exactly matches Trucks tab count!)
                KpiTile(
                  label: l10n.freeTrucks,
                  count: availableTrucks,
                  icon: Icons.local_shipping_rounded,
                  accentColor: colors.statusSuccess,
                  containerColor: colors.statusSuccessContainer,
                ),

                const SizedBox(height: 12),

                // 3. Delivered this Month
                KpiTile(
                  label: l10n.deliveredThisMonth,
                  count: deliveredCount,
                  icon: Icons.check_circle_rounded,
                  accentColor: colors.statusSuccess,
                  containerColor: colors.statusSuccessContainer,
                ),

                const SizedBox(height: 24),

                // NEEDS ATTENTION SECTION
                if (workshopTrucks.isNotEmpty || waitingCount > 0) ...[
                  Row(
                    children: [
                      Icon(Icons.warning_amber_rounded, color: colors.statusDanger, size: 26),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          l10n.needsAttention,
                          style: AppTypography.title(colors.statusDanger),
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
                          color: colors.statusDangerContainer,
                          borderRadius: AppSpacing.buttonBorderRadius,
                          border: Border.all(color: colors.statusDanger.withValues(alpha: 0.4), width: 1.5),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.build_rounded, color: colors.statusDanger, size: 28),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    t.plate,
                                    style: AppTypography.heading(colors.text, isNumber: true),
                                  ),
                                  Text(
                                    "${t.model} · ${l10n.statusInWorkshop}",
                                    style: AppTypography.body(colors.statusDanger),
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
                        color: colors.statusWaitingContainer,
                        borderRadius: AppSpacing.buttonBorderRadius,
                        border: Border.all(color: colors.statusWaiting.withValues(alpha: 0.4), width: 1.5),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.hourglass_empty_rounded, color: colors.statusWaiting, size: 28),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              "$waitingCount trip(s) waiting for driver confirmation",
                              style: AppTypography.body(colors.statusWaiting),
                            ),
                          ),
                        ],
                      ),
                    ),
                  const SizedBox(height: 20),
                ],

                // VIEW ALL TRIPS BUTTON
                SecondaryButton(
                  label: l10n.tabTrips,
                  icon: Icons.receipt_long_rounded,
                  onPressed: onViewAllTrips,
                ),
              ],
            );
          },
        );
      },
    );
  }
}
