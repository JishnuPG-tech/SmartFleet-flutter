import "package:flutter/material.dart";
import "package:url_launcher/url_launcher.dart";
import "../../../core/design/tokens/app_colors.dart";
import "../../../core/design/tokens/app_typography.dart";
import "../../../core/design/tokens/app_spacing.dart";
import "../../../core/design/components/status_chip.dart";
import "../../../core/design/components/status_headline.dart";
import "../../../core/design/components/live_badge.dart";
import "../../../core/design/components/buttons.dart";
import "../../../core/data/models/driver.dart";
import "../../../core/data/models/trip.dart";
import "../../../core/data/fleet_repository.dart";
import "../../../l10n/app_localizations.dart";
import "../delivery_proof_flow.dart";

class DriverTripTab extends StatelessWidget {
  final Driver? driver;
  final String? driverId;

  const DriverTripTab({
    super.key,
    this.driver,
    this.driverId,
  }) : assert(driver != null || driverId != null);

  String get effectiveDriverId => driver?.id ?? driverId!;

  void _openGoogleMaps(BuildContext context, String from, String to) async {
    final query = Uri.encodeComponent("$from to $to Kerala");
    final url = Uri.parse("https://www.google.com/maps/search/?api=1&query=$query");
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Could not open Google Maps")),
        );
      }
    }
  }

  void _callOffice(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Calling fleet office: +91 484 288 9000")),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = AppLocalizations.of(context);

    return StreamBuilder<List<Trip>>(
      stream: LocalFleetRepository.instance.watchTrips(),
      builder: (context, snapshot) {
        final trips = snapshot.data ?? [];
        final driverTrips = trips.where((t) => t.driverId == effectiveDriverId).toList();

        final activeTrip = driverTrips.where((t) => t.status != TripStatus.delivered).firstOrNull;

        if (activeTrip == null) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: colors.surfaceAlt,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.check_circle_outline_rounded, size: 56, color: colors.statusSuccess),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    l10n.noTripTitle,
                    style: AppTypography.title(colors.text),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    l10n.noTripSubtitle,
                    style: AppTypography.body(colors.textSecondary),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        }

        final trip = activeTrip;
        final isRunning = trip.status == TripStatus.running || trip.status == TripStatus.accepted;

        return ListView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: StatusHeadline(
                    headline: trip.status == TripStatus.waiting
                        ? "New Trip Assigned"
                        : "Arriving by 4:30 PM",
                    subtitle: "To ${trip.to}",
                  ),
                ),
                if (isRunning)
                  const LiveBadge(
                    status: LiveStatus.live,
                    label: "Sharing ON",
                  ),
              ],
            ),
            const SizedBox(height: 16),

            // TRIP CARD
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
                        Text(trip.id, style: AppTypography.heading(colors.text, isNumber: true)),
                        StatusChipV2(
                          label: trip.status == TripStatus.waiting ? l10n.statusWaiting : l10n.statusRunning,
                          icon: trip.status == TripStatus.waiting ? Icons.hourglass_empty_rounded : Icons.navigation_rounded,
                          type: trip.status == TripStatus.waiting ? ChipStatusType.waiting : ChipStatusType.running,
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    Row(
                      children: [
                        Column(
                          children: [
                            Icon(Icons.trip_origin_rounded, size: 22, color: colors.brand),
                            Container(width: 2, height: 28, color: colors.border),
                            Icon(Icons.location_on_rounded, size: 22, color: colors.statusDanger),
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

                    if (isRunning) ...[
                      const SizedBox(height: 16),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: trip.progressPercent,
                          backgroundColor: colors.surfaceAlt,
                          valueColor: AlwaysStoppedAnimation<Color>(colors.brand),
                          minHeight: 8,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        l10n.kmDoneOfTotal(trip.distanceDoneKm.toStringAsFixed(1), trip.distanceKm.toStringAsFixed(0)),
                        style: AppTypography.label(colors.textSecondary, isNumber: true),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            SecondaryButton(
              label: l10n.btnShowRoute,
              icon: Icons.map_outlined,
              onPressed: () => _openGoogleMaps(context, trip.from, trip.to),
            ),
            const SizedBox(height: 14),

            if (trip.status == TripStatus.waiting) ...[
              PrimaryButton(
                label: l10n.btnAcceptTrip,
                icon: Icons.check_circle_outline_rounded,
                onPressed: () async {
                  await LocalFleetRepository.instance.updateTripStatus(trip.id, TripStatus.accepted);
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Trip accepted! Ready for dispatch.")),
                    );
                  }
                },
              ),
            ] else if (trip.status == TripStatus.accepted) ...[
              PrimaryButton(
                label: l10n.btnStartTrip,
                icon: Icons.play_arrow_rounded,
                onPressed: () async {
                  await LocalFleetRepository.instance.updateTripStatus(trip.id, TripStatus.running);
                },
              ),
            ] else if (trip.status == TripStatus.running) ...[
              PrimaryButton(
                label: l10n.btnReached,
                icon: Icons.flag_rounded,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => DeliveryProofFlow(tripId: trip.id),
                    ),
                  );
                },
              ),
            ],

            const SizedBox(height: 14),

            SecondaryButton(
              label: l10n.btnCallOffice,
              icon: Icons.phone_rounded,
              onPressed: () => _callOffice(context),
            ),
            const SizedBox(height: 14),

            DangerButton(
              label: l10n.btnHelpBreakdown,
              icon: Icons.warning_amber_rounded,
              confirmTitle: l10n.confirmBreakdownTitle,
              confirmMessage: l10n.confirmBreakdownMessage,
              confirmActionLabel: l10n.btnConfirm,
              onConfirmed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Breakdown alert sent to fleet office."),
                    backgroundColor: Color(0xFFC62828),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }
}
