import "package:flutter/material.dart";
import "../../../core/design/tokens/app_colors.dart";
import "../../../core/design/tokens/app_typography.dart";
import "../../../core/design/tokens/app_spacing.dart";
import "../../../core/design/components/status_chip.dart";
import "../../../core/design/utils/currency_formatter.dart";
import "../../../core/data/models/trip.dart";
import "../../../core/data/fleet_repository.dart";
import "../../../l10n/app_localizations.dart";

class DriverEarningsTab extends StatelessWidget {
  final String driverId;

  const DriverEarningsTab({super.key, required this.driverId});

  void _showBreakdownSheet(BuildContext context, Trip trip) {
    final colors = context.colors;
    showModalBottomSheet(
      context: context,
      backgroundColor: colors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppSpacing.radiusCard)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(trip.id, style: AppTypography.title(colors.text, fontSize: 18)),
                    StatusChipV2(
                      label: trip.isPaid ? "Paid" : "Pending",
                      icon: trip.isPaid ? Icons.check_circle_rounded : Icons.hourglass_empty_rounded,
                      type: trip.isPaid ? ChipStatusType.success : ChipStatusType.waiting,
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text("${trip.from} ➔ ${trip.to}", style: AppTypography.section(colors.text, fontSize: 16)),
                const SizedBox(height: 4),
                Text("${trip.cargo} · ${trip.weightTons}T", style: AppTypography.supporting(colors.textSecondary)),
                const Divider(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Trip Allowance", style: AppTypography.supporting(colors.textSecondary)),
                    Text(CurrencyFormatter.format(trip.allowanceAmount), style: AppTypography.section(colors.brand, fontSize: 16, isNumber: true)),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Distance", style: AppTypography.supporting(colors.textSecondary)),
                    Text("${trip.distanceKm.toStringAsFixed(0)} km", style: AppTypography.supporting(colors.text, isNumber: true)),
                  ],
                ),
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
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
          children: [
            // HIGH-DENSITY ALLOWANCE HERO
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              decoration: BoxDecoration(
                color: colors.surface,
                borderRadius: AppSpacing.cardBorderRadius,
                border: Border.all(color: colors.border, width: 1.0),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Weekly allowance",
                    style: AppTypography.supporting(colors.textSecondary, fontSize: 13),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    CurrencyFormatter.format(thisWeekSum),
                    style: AppTypography.value(colors.brand, fontSize: 32),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    l10n.nextPayoutDate("Friday, 21 Nov 2026"),
                    style: AppTypography.supporting(colors.textSecondary, fontSize: 12),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 18),

            // RECENT TRIPS SECTION
            Text(
              "Recent trips",
              style: AppTypography.section(colors.text, fontSize: 16),
            ),
            const SizedBox(height: 10),

            if (driverTrips.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 32),
                child: Center(
                  child: Text(
                    "No trips recorded",
                    style: AppTypography.supporting(colors.textSecondary),
                  ),
                ),
              )
            else
              ...driverTrips.map((trip) {
                final isPaid = trip.isPaid || trip.status == TripStatus.delivered;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: InkWell(
                    onTap: () => _showBreakdownSheet(context, trip),
                    borderRadius: AppSpacing.cardBorderRadius,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                      decoration: BoxDecoration(
                        color: colors.surface,
                        borderRadius: AppSpacing.cardBorderRadius,
                        border: Border.all(color: colors.border, width: 1.0),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                trip.id,
                                style: AppTypography.section(colors.text, fontSize: 15, isNumber: true),
                              ),
                              StatusChipV2(
                                label: isPaid ? l10n.statusPaid : l10n.statusPending,
                                icon: isPaid ? Icons.check_circle_rounded : Icons.hourglass_empty_rounded,
                                type: isPaid ? ChipStatusType.success : ChipStatusType.waiting,
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Text(
                            "${trip.from} ➔ ${trip.to}",
                            style: AppTypography.section(colors.text, fontSize: 16),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "${trip.cargo} · ${trip.weightTons}T",
                                style: AppTypography.supporting(colors.textSecondary, fontSize: 13),
                              ),
                              Text(
                                CurrencyFormatter.format(trip.allowanceAmount),
                                style: AppTypography.section(colors.brand, fontSize: 15, isNumber: true),
                              ),
                            ],
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
