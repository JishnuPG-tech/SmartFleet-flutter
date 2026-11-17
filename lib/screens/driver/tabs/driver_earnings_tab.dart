import 'package:flutter/material.dart';
import 'package:smartfleet_flutter/core/data/models/trip.dart';
import 'package:smartfleet_flutter/core/data/fleet_repository.dart';
import 'package:smartfleet_flutter/core/theme/app_theme.dart';
import 'package:smartfleet_flutter/l10n/app_localizations.dart';

class DriverEarningsTab extends StatelessWidget {
  final String driverId;

  const DriverEarningsTab({super.key, required this.driverId});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return StreamBuilder<List<Trip>>(
      stream: LocalFleetRepository.instance.watchTrips(),
      builder: (context, snapshot) {
        final allTrips = snapshot.data ?? [];
        final driverTrips = allTrips.where((t) => t.driverId == driverId).toList();

        // Calculate this week allowance sum
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
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      '₹${thisWeekSum.toString().replaceAllMapped(RegExp(r'(\d+?)(?=(\d\d)+(\d)(?!\d))'), (m) => '${m[1]},')}',
                      style: const TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.w900,
                        color: AppColors.accent,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      l10n.nextPayoutDate('Friday, 21 Nov 2026'),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // RECENT TRIPS SECTION
            Text(
              l10n.recentTrips,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 12),

            if (driverTrips.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 32),
                child: Text(
                  l10n.noTripTitle,
                  style: const TextStyle(fontSize: 18, color: AppColors.textSecondary),
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
                                trip.id, // Strictly TR-XXXX format
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: isPaid ? AppColors.statusDoneBg : AppColors.statusWaitingBg,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  isPaid ? l10n.statusPaid : l10n.statusPending,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    color: isPaid ? AppColors.statusDoneText : AppColors.statusWaitingText,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Text(
                            '${trip.from} ➔ ${trip.to}',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.visible,
                          ),
                          const SizedBox(height: 6),
                          Text(
                            '₹${trip.allowanceAmount} · ${trip.cargo}',
                            style: const TextStyle(
                              fontSize: 16,
                              color: AppColors.textSecondary,
                            ),
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
