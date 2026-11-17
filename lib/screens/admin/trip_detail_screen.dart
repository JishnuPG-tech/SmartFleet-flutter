import 'package:flutter/material.dart';
import 'package:smartfleet_flutter/core/components/status_chip.dart';
import 'package:smartfleet_flutter/core/data/models/trip.dart';
import 'package:smartfleet_flutter/core/data/seed_data.dart';
import 'package:smartfleet_flutter/core/data/fleet_repository.dart';
import 'package:smartfleet_flutter/core/theme/app_theme.dart';
import 'package:smartfleet_flutter/l10n/app_localizations.dart';

class TripDetailScreen extends StatelessWidget {
  final String tripId;

  const TripDetailScreen({super.key, required this.tripId});

  void _callDriver(BuildContext context, String phone) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Calling $phone...')),
    );
  }

  void _shareOnWhatsApp(BuildContext context, Trip trip, String driverName) {
    final text = 'SmartFleet: Trip ${trip.id} (${trip.from} ➔ ${trip.to}). Driver: $driverName. Status: ${trip.status.name.toUpperCase()} (${(trip.progressPercent * 100).toInt()}% completed).';
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Sharing via WhatsApp:\n$text'),
        duration: const Duration(seconds: 4),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          tripId,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w900,
            color: AppColors.textPrimary,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.5),
          child: Container(color: AppColors.border, height: 1.5),
        ),
      ),
      body: StreamBuilder<List<Trip>>(
        stream: LocalFleetRepository.instance.watchTrips(),
        builder: (context, snapshot) {
          final allTrips = snapshot.data ?? [];
          final tripList = allTrips.where((t) => t.id == tripId).toList();
          if (tripList.isEmpty) {
            return const Center(child: Text('Trip not found'));
          }
          final trip = tripList.first;

          return FutureBuilder(
            future: LocalFleetRepository.instance.getDrivers(),
            builder: (context, driverSnap) {
              final drivers = driverSnap.data ?? [];
              final driver = drivers.firstWhere(
                (d) => d.id == trip.driverId,
                orElse: () => SeedData.drivers.first,
              );

              return ListView(
                padding: const EdgeInsets.fromLTRB(16, 20, 16, 32),
                children: [
                  // STATUS + TRUCK CARD
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Wrap(
                            alignment: WrapAlignment.spaceBetween,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            spacing: 8,
                            runSpacing: 8,
                            children: [
                              StatusChip.forTrip(context, trip.status),
                              Text(
                                trip.truckPlate,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                            ],
                          ),
                          const Divider(height: 24, color: AppColors.border),

                          // Route
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Column(
                                children: [
                                  Icon(Icons.trip_origin, size: 24, color: AppColors.accent),
                                  SizedBox(height: 20),
                                  Icon(Icons.location_on, size: 24, color: AppColors.statusProblemText),
                                ],
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      trip.from,
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w800,
                                        color: AppColors.textPrimary,
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    Text(
                                      trip.to,
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w800,
                                        color: AppColors.textPrimary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 16),

                          // Cargo & Weight
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: AppColors.background,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: AppColors.border),
                            ),
                            child: Text(
                              '${trip.cargo} · ${trip.weightTons} Tons',
                              style: const TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // DRIVER CARD WITH DIRECT CALL BUTTON
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l10n.tabDrivers,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              const Icon(Icons.person, size: 36, color: AppColors.accent),
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
                                    Text(
                                      driver.phone,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        color: AppColors.textSecondary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          OutlinedButton(
                            onPressed: () => _callDriver(context, driver.phone),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.phone, color: AppColors.accent),
                                const SizedBox(width: 8),
                                Flexible(
                                  child: Text(
                                    l10n.btnCallDriver,
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // VERTICAL STEP TIMELINE TRACKER
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Delivery Progress',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 16),
                          _buildTimelineStep(
                            title: l10n.stepAssigned,
                            subtitle: 'Assigned to ${driver.name} · ${trip.truckPlate}',
                            isDone: true,
                            isLast: false,
                          ),
                          _buildTimelineStep(
                            title: l10n.stepOnTheWay,
                            subtitle: trip.status == TripStatus.delivered
                                ? 'Completed 100% of route (${trip.distanceKm.toInt()} km)'
                                : trip.status == TripStatus.running
                                    ? '${trip.distanceDoneKm.toStringAsFixed(1)} of ${trip.distanceKm.toStringAsFixed(0)} km (${(trip.progressPercent * 100).toInt()}%)'
                                    : 'Awaiting driver start',
                            isDone: trip.status == TripStatus.running || trip.status == TripStatus.delivered,
                            isLast: false,
                          ),
                          _buildTimelineStep(
                            title: l10n.stepDelivered,
                            subtitle: trip.status == TripStatus.delivered
                                ? 'Proof submitted (OTP ${trip.podOtp ?? "Verified"} + Photo + Signature)'
                                : 'Pending arrival at destination bay',
                            isDone: trip.status == TripStatus.delivered,
                            isLast: true,
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // WHATSAPP SHARE BUTTON
                  ElevatedButton(
                    onPressed: () => _shareOnWhatsApp(context, trip, driver.name),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.share, color: Colors.white),
                        const SizedBox(width: 8),
                        Flexible(
                          child: Text(
                            l10n.btnShareWhatsApp,
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
      ),
    );
  }

  Widget _buildTimelineStep({
    required String title,
    required String subtitle,
    required bool isDone,
    required bool isLast,
  }) {
    final dotColor = isDone ? AppColors.accent : AppColors.border;
    final textColor = isDone ? AppColors.textPrimary : AppColors.textSecondary;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color: dotColor,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.background, width: 3),
              ),
            ),
            if (!isLast)
              Container(
                width: 2,
                height: 48,
                color: dotColor,
              ),
          ],
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: textColor,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 15,
                  color: AppColors.textSecondary,
                ),
              ),
              if (!isLast) const SizedBox(height: 18),
            ],
          ),
        ),
      ],
    );
  }
}
