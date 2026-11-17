import "package:flutter/material.dart";
import "package:latlong2/latlong.dart";
import "../../../core/design/tokens/app_colors.dart";
import "../../../core/design/tokens/app_typography.dart";
import "../../../core/design/tokens/app_spacing.dart";
import "../../../core/design/components/status_chip.dart";
import "../../../core/design/components/kpi_tile.dart";
import "../../../core/design/components/buttons.dart";
import "../../../core/design/components/trip_card.dart";
import "../../../core/data/models/trip.dart";
import "../../../core/data/models/truck.dart";
import "../../../core/data/models/driver.dart";
import "../../../core/data/fleet_repository.dart";
import "../../../core/maps/smart_fleet_map.dart";
import "../../../l10n/app_localizations.dart";

class AdminHomeTab extends StatefulWidget {
  final VoidCallback onNewTrip;
  final VoidCallback onViewAllTrips;

  const AdminHomeTab({
    super.key,
    required this.onNewTrip,
    required this.onViewAllTrips,
  });

  @override
  State<AdminHomeTab> createState() => _AdminHomeTabState();
}

class _AdminHomeTabState extends State<AdminHomeTab> {
  Truck? _selectedTruck;
  bool _alertsExpanded = false;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = AppLocalizations.of(context);
    final now = DateTime.now();

    return StreamBuilder<List<Trip>>(
      stream: LocalFleetRepository.instance.watchTrips(),
      builder: (context, tripSnap) {
        return StreamBuilder<List<Truck>>(
          stream: LocalFleetRepository.instance.watchTrucks(),
          builder: (context, truckSnap) {
            return StreamBuilder<List<Driver>>(
              stream: LocalFleetRepository.instance.watchDrivers(),
              builder: (context, driverSnap) {
                final trips = tripSnap.data ?? [];
                final trucks = truckSnap.data ?? [];
                final drivers = driverSnap.data ?? [];

                final runningCount = trips.where((t) => t.status == TripStatus.running).length;
                final deliveredCount = trips.where((t) => t.status == TripStatus.delivered).length;

                final activeTruckPlates = trips
                    .where((t) => t.status != TripStatus.delivered)
                    .map((t) => t.truckPlate)
                    .toSet();

                final availableTrucks = trucks
                    .where((t) => t.status != TruckStatus.inWorkshop && !activeTruckPlates.contains(t.plate))
                    .length;

                // Derived Alerts
                final workshopTrucks = trucks.where((t) => t.status == TruckStatus.inWorkshop).toList();
                final expiringLicenceDrivers = drivers.where((d) => d.isLicenceExpiringSoon).toList();
                final offlineRunningTrucks = trucks.where((truck) {
                  final hasRunningTrip = trips.any((t) => t.truckPlate == truck.plate && t.status == TripStatus.running);
                  if (!hasRunningTrip) return false;
                  if (truck.lastSeen == null) return true;
                  return now.difference(truck.lastSeen!).inMinutes > 10;
                }).toList();

                final totalUrgentAlerts = workshopTrucks.length + expiringLicenceDrivers.length + offlineRunningTrucks.length;

                // Markers
                final markers = trucks.map((truck) {
                  final effectiveStatus = truck.status == TruckStatus.inWorkshop
                      ? TruckStatus.inWorkshop
                      : (activeTruckPlates.contains(truck.plate) ? TruckStatus.onTrip : TruckStatus.available);

                  return SmartFleetMap.buildTruckMarker(
                    position: truck.position,
                    plateNumber: truck.plate,
                    status: effectiveStatus,
                    colors: colors,
                    heading: truck.heading,
                    onTap: () {
                      setState(() {
                        _selectedTruck = truck;
                      });
                    },
                  );
                }).toList();

                // Max 3 recent trips
                final recentTrips = trips.take(3).toList();

                return Stack(
                  children: [
                    // TOP HERO: Small, useful live fleet map (~35% of height)
                    Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      height: MediaQuery.of(context).size.height * 0.34,
                      child: SmartFleetMap(
                        center: const LatLng(10.5276, 76.2144), // Central Kerala (Thrissur)
                        zoom: 8.0,
                        markers: markers,
                        onTap: (_, _) {
                          if (_selectedTruck != null) {
                            setState(() => _selectedTruck = null);
                          }
                        },
                      ),
                    ),

                    // SELECTED TRUCK QUICK OVERLAY
                    if (_selectedTruck != null)
                      Positioned(
                        top: 12,
                        left: 12,
                        right: 12,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                          decoration: BoxDecoration(
                            color: colors.surface,
                            borderRadius: AppSpacing.cardBorderRadius,
                            border: Border.all(color: colors.border, width: 1.0),
                            boxShadow: AppSpacing.lightCardShadow,
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      _selectedTruck!.plate,
                                      style: AppTypography.section(colors.text, fontSize: 16, isNumber: true),
                                    ),
                                    Text(
                                      _selectedTruck!.model,
                                      style: AppTypography.supporting(colors.textSecondary, fontSize: 12),
                                    ),
                                  ],
                                ),
                              ),
                              if (_selectedTruck!.status == TruckStatus.inWorkshop)
                                StatusChipV2.danger(label: "Service")
                              else if (activeTruckPlates.contains(_selectedTruck!.plate))
                                StatusChipV2.running(label: "On trip")
                              else
                                StatusChipV2.success(label: "Available"),
                              const SizedBox(width: 8),
                              IconButton(
                                icon: const Icon(Icons.close_rounded, size: 18),
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(),
                                onPressed: () => setState(() => _selectedTruck = null),
                              ),
                            ],
                          ),
                        ),
                      ),

                    // COMPACT OPERATIONAL CONTENT SHEET
                    DraggableScrollableSheet(
                      initialChildSize: 0.68,
                      minChildSize: 0.64,
                      maxChildSize: 0.96,
                      snap: true,
                      snapSizes: const [0.64, 0.68, 0.96],
                      builder: (context, scrollController) {
                        return Container(
                          decoration: BoxDecoration(
                            color: colors.bg,
                            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                            border: Border(top: BorderSide(color: colors.border, width: 1.0)),
                          ),
                          child: ListView(
                            controller: scrollController,
                            padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                            children: [
                              // Drag Handle
                              Center(
                                child: Container(
                                  width: 36,
                                  height: 4,
                                  margin: const EdgeInsets.only(bottom: 12),
                                  decoration: BoxDecoration(
                                    color: colors.border,
                                    borderRadius: BorderRadius.circular(2),
                                  ),
                                ),
                              ),

                              // ONE PRIMARY ACTION: Crisp Acid Lime Button
                              PrimaryButton(
                                label: l10n.btnNewTrip,
                                icon: Icons.add_rounded,
                                onPressed: widget.onNewTrip,
                                height: 50,
                              ),

                              const SizedBox(height: 14),

                              // 3 SUMMARY METRICS: Compact Horizontal Group
                              Row(
                                children: [
                                  CompactMetricTile(
                                    label: "Active trips",
                                    count: runningCount,
                                    icon: Icons.navigation_rounded,
                                    accentColor: colors.brand,
                                    onTap: widget.onViewAllTrips,
                                  ),
                                  const SizedBox(width: 8),
                                  CompactMetricTile(
                                    label: "Available",
                                    count: availableTrucks,
                                    icon: Icons.local_shipping_rounded,
                                    accentColor: colors.statusSuccess,
                                  ),
                                  const SizedBox(width: 8),
                                  CompactMetricTile(
                                    label: "Delivered",
                                    count: deliveredCount,
                                    icon: Icons.check_circle_rounded,
                                    accentColor: colors.textSecondary,
                                  ),
                                ],
                              ),

                              // URGENT ALERTS (Only when needed, compact banner)
                              if (totalUrgentAlerts > 0) ...[
                                const SizedBox(height: 14),
                                InkWell(
                                  onTap: () => setState(() => _alertsExpanded = !_alertsExpanded),
                                  borderRadius: AppSpacing.cardBorderRadius,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                                    decoration: BoxDecoration(
                                      color: colors.statusWaitingContainer,
                                      borderRadius: AppSpacing.cardBorderRadius,
                                      border: Border.all(color: colors.statusWaiting.withValues(alpha: 0.35), width: 1.0),
                                    ),
                                    child: Row(
                                      children: [
                                        Icon(Icons.warning_amber_rounded, size: 18, color: colors.statusWaiting),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: Text(
                                            "$totalUrgentAlerts urgent operational alert${totalUrgentAlerts > 1 ? 's' : ''}",
                                            style: AppTypography.supporting(colors.statusWaiting, fontSize: 13).copyWith(
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                        Icon(
                                          _alertsExpanded ? Icons.keyboard_arrow_up_rounded : Icons.keyboard_arrow_down_rounded,
                                          size: 20,
                                          color: colors.statusWaiting,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                if (_alertsExpanded) ...[
                                  const SizedBox(height: 8),
                                  ...offlineRunningTrucks.map((truck) => Padding(
                                    padding: const EdgeInsets.only(bottom: 6),
                                    child: Text(
                                      "• ${truck.plate}: GPS offline > 10 min",
                                      style: AppTypography.supporting(colors.statusDanger, fontSize: 12),
                                    ),
                                  )),
                                  ...expiringLicenceDrivers.map((driver) => Padding(
                                    padding: const EdgeInsets.only(bottom: 6),
                                    child: Text(
                                      "• ${driver.name}: Licence expires in ${driver.licenceExpiryDate!.difference(now).inDays} days",
                                      style: AppTypography.supporting(colors.statusWaiting, fontSize: 12),
                                    ),
                                  )),
                                  ...workshopTrucks.map((truck) => Padding(
                                    padding: const EdgeInsets.only(bottom: 6),
                                    child: Text(
                                      "• ${truck.plate}: In workshop for service",
                                      style: AppTypography.supporting(colors.statusDanger, fontSize: 12),
                                    ),
                                  )),
                                ],
                              ],

                              const SizedBox(height: 18),

                              // RECENT TRIPS SECTION (Max 3)
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Recent trips",
                                    style: AppTypography.section(colors.text, fontSize: 16),
                                  ),
                                  GestureDetector(
                                    onTap: widget.onViewAllTrips,
                                    child: Text(
                                      "View all",
                                      style: AppTypography.supporting(colors.brand, fontSize: 13).copyWith(
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),

                              if (recentTrips.isEmpty)
                                Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 24),
                                  child: Center(
                                    child: Text(
                                      "No active trips",
                                      style: AppTypography.supporting(colors.textSecondary),
                                    ),
                                  ),
                                )
                              else
                                ...recentTrips.map((trip) {
                                  final chipType = trip.status == TripStatus.delivered
                                      ? ChipStatusType.success
                                      : (trip.status == TripStatus.running ? ChipStatusType.running : ChipStatusType.waiting);

                                  return Padding(
                                    padding: const EdgeInsets.only(bottom: 8),
                                    child: TripCard(
                                      id: trip.id,
                                      from: trip.from,
                                      to: trip.to,
                                      cargo: trip.cargo,
                                      weightTons: trip.weightTons,
                                      truckPlate: trip.truckPlate,
                                      statusType: chipType,
                                      statusLabel: trip.status == TripStatus.delivered
                                          ? "Done"
                                          : (trip.status == TripStatus.running ? "Running" : "Waiting"),
                                      progressPercent: trip.progressPercent,
                                      distanceDoneText: "${trip.distanceDoneKm.toStringAsFixed(0)} / ${trip.distanceKm.toStringAsFixed(0)} km",
                                      onTap: widget.onViewAllTrips,
                                    ),
                                  );
                                }),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                );
              },
            );
          },
        );
      },
    );
  }
}
