import "package:flutter/material.dart";
import "../../core/design/tokens/app_colors.dart";
import "../../core/design/tokens/app_typography.dart";
import "../../core/design/tokens/app_spacing.dart";
import "../../core/design/components/status_chip.dart";
import "../../core/design/components/tracking_timeline.dart";
import "../../core/design/components/buttons.dart";
import "../../core/data/models/trip.dart";
import "../../core/data/models/driver.dart";
import "../../core/data/seed_data.dart";
import "../../core/data/fleet_repository.dart";
import "../../l10n/app_localizations.dart";

class TripDetailScreen extends StatelessWidget {
  final String tripId;

  const TripDetailScreen({super.key, required this.tripId});

  void _callDriver(BuildContext context, String phone) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Calling $phone...")),
    );
  }

  void _shareOnWhatsApp(BuildContext context, Trip trip, String driverName) {
    final text = "SmartFleet: Trip ${trip.id} (${trip.from} ➔ ${trip.to}). Driver: $driverName. Status: ${trip.status.name.toUpperCase()} (${(trip.progressPercent * 100).toInt()}% completed). Tracking link: https://smartfleet.app/t/${trip.id} [link feature not built yet]";
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Sharing via WhatsApp:\n$text"),
        duration: const Duration(seconds: 4),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: colors.bg,
      appBar: AppBar(
        title: Text(
          tripId,
          style: AppTypography.title(colors.text, isNumber: true),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(color: colors.border, height: 1.0),
        ),
      ),
      body: StreamBuilder<List<Trip>>(
        stream: LocalFleetRepository.instance.watchTrips(),
        builder: (context, snapshot) {
          final allTrips = snapshot.data ?? [];
          final tripList = allTrips.where((t) => t.id == tripId).toList();
          if (tripList.isEmpty) {
            return const Center(child: Text("Trip not found"));
          }
          final trip = tripList.first;

          return FutureBuilder<List<Driver>>(
            future: LocalFleetRepository.instance.getDrivers(),
            builder: (context, driverSnap) {
              final drivers = driverSnap.data ?? [];
              final driver = drivers.firstWhere(
                (d) => d.id == trip.driverId,
                orElse: () => SeedData.drivers.first,
              );

              ChipStatusType statusType;
              String statusLabel;
              switch (trip.status) {
                case TripStatus.waiting:
                  statusType = ChipStatusType.waiting;
                  statusLabel = l10n.statusWaiting;
                  break;
                case TripStatus.accepted:
                case TripStatus.running:
                  statusType = ChipStatusType.running;
                  statusLabel = l10n.statusRunning;
                  break;
                case TripStatus.delivered:
                  statusType = ChipStatusType.success;
                  statusLabel = l10n.statusDelivered;
                  break;
              }

              return ListView(
                padding: const EdgeInsets.fromLTRB(16, 20, 16, 32),
                children: [
                  // STATUS + ROUTE CARD
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
                              StatusChipV2(label: statusLabel, icon: Icons.local_shipping_rounded, type: statusType),
                              Text(
                                trip.truckPlate,
                                style: AppTypography.heading(colors.text, isNumber: true),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Divider(height: 1, color: colors.border),
                          const SizedBox(height: 16),

                          // Route
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                children: [
                                  Icon(Icons.trip_origin_rounded, size: 24, color: colors.brand),
                                  const SizedBox(height: 20),
                                  Icon(Icons.location_on_rounded, size: 24, color: colors.statusDanger),
                                ],
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(trip.from, style: AppTypography.heading(colors.text)),
                                    const SizedBox(height: 16),
                                    Text(trip.to, style: AppTypography.heading(colors.text)),
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
                              color: colors.surfaceAlt,
                              borderRadius: AppSpacing.buttonBorderRadius,
                            ),
                            child: Text(
                              "${trip.cargo} · ${trip.weightTons} Tons",
                              style: AppTypography.heading(colors.text),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // DRIVER CARD (Singular "Driver", NOT "Drivers")
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Driver", // Singular label
                            style: AppTypography.label(colors.textSecondary),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: colors.brand.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Icon(Icons.person_rounded, size: 30, color: colors.brand),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(driver.name, style: AppTypography.heading(colors.text)),
                                    Text(driver.phone, style: AppTypography.body(colors.textSecondary)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          SecondaryButton(
                            label: l10n.btnCallDriver,
                            icon: Icons.phone_rounded,
                            onPressed: () => _callDriver(context, driver.phone),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // VERTICAL STEP TIMELINE WITH TIMESTAMPS
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Delivery Progress", style: AppTypography.heading(colors.text)),
                          const SizedBox(height: 20),
                          TrackingTimeline(
                            steps: [
                              TimelineStepData(
                                title: l10n.stepAssigned,
                                subtitle: "Assigned to ${driver.name} · ${trip.truckPlate}",
                                timestamp: "08:30 AM",
                                isCompleted: true,
                              ),
                              TimelineStepData(
                                title: l10n.stepOnTheWay,
                                subtitle: trip.status == TripStatus.delivered
                                    ? "Completed 100% of route (${trip.distanceKm.toInt()} km)"
                                    : trip.status == TripStatus.running
                                        ? "${trip.distanceDoneKm.toStringAsFixed(1)} of ${trip.distanceKm.toStringAsFixed(0)} km (${(trip.progressPercent * 100).toInt()}%)"
                                        : "Awaiting driver start",
                                timestamp: trip.status == TripStatus.delivered
                                    ? "01:45 PM"
                                    : trip.status == TripStatus.running
                                        ? "11:00 AM"
                                        : "Pending",
                                isCompleted: trip.status == TripStatus.delivered,
                                isCurrent: trip.status == TripStatus.running,
                              ),
                              TimelineStepData(
                                title: l10n.stepDelivered,
                                subtitle: trip.status == TripStatus.delivered
                                    ? "Proof submitted (OTP ${trip.podOtp ?? "Verified"} + Photo + Signature)"
                                    : "Pending arrival at destination bay",
                                timestamp: trip.status == TripStatus.delivered ? "03:15 PM" : "ETA 04:30 PM",
                                isCompleted: trip.status == TripStatus.delivered,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // WHATSAPP SHARE BUTTON
                  PrimaryButton(
                    label: l10n.btnShareWhatsApp,
                    icon: Icons.share_rounded,
                    onPressed: () => _shareOnWhatsApp(context, trip, driver.name),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
