import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/design/tokens/app_colors.dart';
import '../../../core/design/tokens/app_typography.dart';
import '../../../core/design/tokens/app_spacing.dart';
import '../../../core/design/components/status_chip.dart';
import '../../../core/design/components/buttons.dart';
import '../../../core/data/models/driver.dart';
import '../../../core/data/models/trip.dart';
import '../../../core/data/models/truck.dart';
import '../../../core/data/fleet_repository.dart';
import '../../../core/maps/smart_fleet_map.dart';
import '../../../core/maps/kerala_locations.dart';
import '../../../core/maps/marker_interpolator.dart';
import '../../../l10n/app_localizations.dart';
import '../delivery_proof_flow.dart';

class DriverTripTab extends StatelessWidget {
  final Driver? driver;
  final String? driverId;

  const DriverTripTab({
    super.key,
    this.driver,
    this.driverId,
  }) : assert(driver != null || driverId != null);

  String get effectiveDriverId => driver?.id ?? driverId!;

  Future<void> _openGoogleMaps(BuildContext context, String from, String to) async {
    final query = Uri.encodeComponent("$from to $to Kerala");
    final url = Uri.parse("https://www.google.com/maps/search/?api=1&query=$query");
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Could not open navigation app")),
        );
      }
    }
  }

  Future<void> _callOffice(BuildContext context) async {
    final uri = Uri.parse("tel:+914842889000");
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Calling fleet office: +91 484 288 9000")),
        );
      }
    }
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
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: colors.surface,
                      shape: BoxShape.circle,
                      border: Border.all(color: colors.border, width: 1.0),
                    ),
                    child: Icon(Icons.check_circle_outline_rounded, size: 48, color: colors.statusSuccess),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    l10n.noTripTitle,
                    style: AppTypography.title(colors.text, fontSize: 20),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    l10n.noTripSubtitle,
                    style: AppTypography.supporting(colors.textSecondary, fontSize: 14),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        }

        final trip = activeTrip;
        final isRunning = trip.status == TripStatus.running || trip.status == TripStatus.accepted;

        final origin = KeralaLocations.resolve(trip.from);
        final dest = KeralaLocations.resolve(trip.to);
        final truckPos = MarkerInterpolator.interpolateLatLng(origin, dest, trip.progressPercent);

        final arrivalTime = "${trip.estimatedArrival.hour.toString().padLeft(2, '0')}:${trip.estimatedArrival.minute.toString().padLeft(2, '0')}";
        final kmRemaining = (trip.distanceKm - trip.distanceDoneKm).clamp(0, trip.distanceKm);

        return ListView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
          children: [
            // OPERATIONAL HEADLINE
            Container(
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
                        label: trip.status == TripStatus.waiting ? l10n.statusWaiting : l10n.statusRunning,
                        icon: trip.status == TripStatus.waiting ? Icons.hourglass_empty_rounded : Icons.navigation_rounded,
                        type: trip.status == TripStatus.waiting ? ChipStatusType.waiting : ChipStatusType.running,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    trip.status == TripStatus.waiting
                        ? "Assigned: ${trip.to}"
                        : "Arriving by $arrivalTime · ${kmRemaining.toStringAsFixed(0)} km left",
                    style: AppTypography.title(colors.text, fontSize: 18),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "${trip.from} ➔ ${trip.to}",
                    style: AppTypography.supporting(colors.textSecondary, fontSize: 14),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 10),

            // LIVE GPS STATUS BAR (Zero overflow, honest telemetry)
            if (isRunning) ...[
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: colors.surfaceAlt,
                  borderRadius: BorderRadius.circular(AppSpacing.radiusChip),
                  border: Border.all(color: colors.border, width: 1.0),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: colors.statusSuccess,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        "GPS sharing active",
                        style: AppTypography.supporting(colors.text, fontSize: 13).copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Text(
                      "${trip.distanceDoneKm.toStringAsFixed(0)} / ${trip.distanceKm.toStringAsFixed(0)} km",
                      style: AppTypography.supporting(colors.textSecondary, fontSize: 12, isNumber: true),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
            ],

            // COMPACT ROUTE PREVIEW MAP
            ClipRRect(
              borderRadius: AppSpacing.cardBorderRadius,
              child: Container(
                height: 150,
                decoration: BoxDecoration(
                  borderRadius: AppSpacing.cardBorderRadius,
                  border: Border.all(color: colors.border, width: 1.0),
                ),
                child: SmartFleetMap(
                  center: truckPos,
                  zoom: 9.5,
                  interactive: false,
                  polylines: [
                    Polyline(
                      points: [origin, dest],
                      strokeWidth: 3.5,
                      color: colors.brand,
                      strokeCap: StrokeCap.round,
                    ),
                  ],
                  markers: [
                    SmartFleetMap.buildPinMarker(
                      position: origin,
                      icon: Icons.trip_origin_rounded,
                      color: colors.textSecondary,
                      label: trip.from,
                      colors: colors,
                    ),
                    SmartFleetMap.buildPinMarker(
                      position: dest,
                      icon: Icons.flag_rounded,
                      color: colors.statusSuccess,
                      label: trip.to,
                      colors: colors,
                    ),
                    SmartFleetMap.buildTruckMarker(
                      position: truckPos,
                      plateNumber: trip.truckPlate,
                      status: TruckStatus.onTrip,
                      colors: colors,
                      heading: 335.0,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 14),

            // ONE OBVIOUS PRIMARY ACTION (56dp Thumb Target)
            if (trip.status == TripStatus.waiting) ...[
              PrimaryButton(
                label: l10n.btnAcceptTrip,
                icon: Icons.check_circle_outline_rounded,
                height: 56,
                onPressed: () async {
                  await LocalFleetRepository.instance.updateTripStatus(trip.id, TripStatus.accepted);
                },
              ),
            ] else if (trip.status == TripStatus.accepted) ...[
              PrimaryButton(
                label: l10n.btnStartTrip,
                icon: Icons.play_arrow_rounded,
                height: 56,
                onPressed: () async {
                  await LocalFleetRepository.instance.updateTripStatus(trip.id, TripStatus.running);
                },
              ),
            ] else if (trip.status == TripStatus.running) ...[
              PrimaryButton(
                label: l10n.btnReached,
                icon: Icons.flag_rounded,
                height: 56,
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

            const SizedBox(height: 10),

            // SECONDARY ACTIONS: Route navigation & office call
            Row(
              children: [
                Expanded(
                  child: SecondaryButton(
                    label: "Navigation",
                    icon: Icons.navigation_rounded,
                    height: 48,
                    onPressed: () => _openGoogleMaps(context, trip.from, trip.to),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: SecondaryButton(
                    label: "Call office",
                    icon: Icons.phone_rounded,
                    height: 48,
                    onPressed: () => _callOffice(context),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),

            // BREAKDOWN / EMERGENCY ASSISTANCE
            DangerButton(
              label: l10n.btnHelpBreakdown,
              icon: Icons.warning_amber_rounded,
              height: 48,
              confirmTitle: l10n.confirmBreakdownTitle,
              confirmMessage: l10n.confirmBreakdownMessage,
              confirmActionLabel: l10n.btnConfirm,
              onConfirmed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text("Breakdown alert sent to fleet office."),
                    backgroundColor: colors.statusDanger,
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
