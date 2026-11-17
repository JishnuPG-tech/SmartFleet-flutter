import "package:flutter/material.dart";
import "../../../core/design/tokens/app_colors.dart";
import "../../../core/design/tokens/app_typography.dart";
import "../../../core/design/components/status_chip.dart";
import "../../../core/design/utils/currency_formatter.dart";
import "../../../core/data/models/trip.dart";
import "../../../core/data/fleet_repository.dart";
import "../../../l10n/app_localizations.dart";

class DriverEarningsTab extends StatelessWidget {
  final String driverId;

  const DriverEarningsTab({super.key, required this.driverId});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = AppLocalizations.of(context);

    return StreamBuilder<List<Trip>>(
      stream: LocalFleetRepository.instance.watchTrips(),
      builder: (context, snapshot) {
        final allTrips = snapshot.data ?? [];
        final driverTrips = allTrips.where((t) => t.driverId == driverId).toList();

        int thisWeekSum = 0;
        for (final t in driverTrips) {
          thisWeekSum += t.allowanceAmount;
        }

        return ListView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
          children: [
            // BIG THIS WEEK CARD
            Card(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.thisWeekEarnings,
                      style: AppTypography.heading(colors.textSecondary),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      CurrencyFormatter.format(thisWeekSum), // Strict Indian grouping: ₹4,800
                      style: AppTypography.display(colors.brand, isNumber: true),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      l10n.nextPayoutDate("Friday, 21 Nov 2026"),
                      style: AppTypography.label(colors.textSecondary),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // RECENT TRIPS SECTION
            Text(
              l10n.recentTrips,
              style: AppTypography.title(colors.text),
            ),
            const SizedBox(height: 12),

            if (driverTrips.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 32),
                child: Text(
                  l10n.noTripTitle,
                  style: AppTypography.body(colors.textSecondary),
                  textAlign: TextAlign.center,
                ),
              )
            else
              ...driverTrips.map((trip) {
                final isPaid = trip.isPaid || trip.status == TripStatus.delivered;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Wrap(
                            alignment: WrapAlignment.spaceBetween,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            spacing: 8,
                            runSpacing: 8,
                            children: [
                              Text(
                                trip.id,
                                style: AppTypography.heading(colors.text, isNumber: true),
                              ),
                              StatusChipV2(
                                label: isPaid ? l10n.statusPaid : l10n.statusPending,
                                icon: isPaid ? Icons.check_circle_rounded : Icons.hourglass_empty_rounded,
                                type: isPaid ? ChipStatusType.success : ChipStatusType.waiting,
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Text(
                            "${trip.from} ➔ ${trip.to}",
                            style: AppTypography.heading(colors.text),
                            maxLines: 2,
                            overflow: TextOverflow.visible,
                          ),
                          const SizedBox(height: 6),
                          Text(
                            "${CurrencyFormatter.format(trip.allowanceAmount)} · ${trip.cargo}", // Strict format
                            style: AppTypography.body(colors.textSecondary),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
          ],
        );
      },
    );
  }
}
