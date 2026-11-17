import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import '../../../core/design/tokens/app_colors.dart';
import '../../../core/design/tokens/app_typography.dart';
import '../../../core/design/tokens/app_spacing.dart';
import '../../../core/design/components/status_chip.dart';
import '../../../core/design/components/kpi_tile.dart';
import '../../../core/design/components/buttons.dart';
import '../../../core/data/models/trip.dart';
import '../../../core/data/models/truck.dart';
import '../../../core/data/models/driver.dart';
import '../../../core/data/fleet_repository.dart';
import '../../../core/maps/smart_fleet_map.dart';
import '../../../l10n/app_localizations.dart';

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
            return StreamBuilder<List<Driver>>(
              stream: LocalFleetRepository.instance.watchDrivers(),
              builder: (context, driverSnap) {
                final trips = tripSnap.data ?? [];
                final trucks = truckSnap.data ?? [];
                final drivers = driverSnap.data ?? [];

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

                // Needs Attention Rules Derivation:
                final workshopTrucks = trucks.where((t) => t.status == TruckStatus.inWorkshop).toList();
                
                // Rule: Driver licence expiring < 30 days
                final expiringLicenceDrivers = drivers.where((d) => d.isLicenceExpiringSoon).toList();

                // Rule: Truck/driver offline > 10 min during a running trip
                final offlineRunningTrucks = trucks.where((truck) {
                  final hasRunningTrip = trips.any((t) => t.truckPlate == truck.plate && t.status == TripStatus.running);
                  if (!hasRunningTrip) return false;
                  if (truck.lastSeen == null) return true;
                  return now.difference(truck.lastSeen!).inMinutes > 10;
                }).toList();

                // Build markers for all trucks
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

                return Stack(
                  children: [
                    // TOP HERO: Live Fleet Map (~45% of height)
                    Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      height: MediaQuery.of(context).size.height * 0.45,
                      child: SmartFleetMap(
                        center: const LatLng(10.5276, 76.2144), // Central Kerala (Thrissur)
                        zoom: 8.2,
                        markers: markers,
                        onTap: (_, _) {
                          if (_selectedTruck != null) {
                            setState(() => _selectedTruck = null);
                          }
                        },
                      ),
                    ),

                    // SELECTED TRUCK MINI-CARD OVERLAY (When tapped)
                    if (_selectedTruck != null)
                      Positioned(
                        top: 16,
                        left: 16,
                        right: 16,
                        child: Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: colors.surface,
                            borderRadius: AppSpacing.cardBorderRadius,
                            border: Border.all(color: colors.border, width: 1.5),
                            boxShadow: AppSpacing.lightCardShadow,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      _selectedTruck!.plate,
                                      style: AppTypography.heading(colors.text, isNumber: true),
                                    ),
                                  ),
                                  if (_selectedTruck!.status == TruckStatus.inWorkshop)
                                    StatusChipV2.danger(label: l10n.statusInWorkshop)
                                  else if (activeTruckPlates.contains(_selectedTruck!.plate))
                                    StatusChipV2.running(label: l10n.statusRunning)
                                  else
                                    StatusChipV2.success(label: l10n.statusAvailable),
                                  const SizedBox(width: 8),
                                  IconButton(
                                    icon: const Icon(Icons.close_rounded),
                                    padding: EdgeInsets.zero,
                                    constraints: const BoxConstraints(),
                                    onPressed: () => setState(() => _selectedTruck = null),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(
                                _selectedTruck!.model,
                                style: AppTypography.body(colors.textSecondary),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  Icon(Icons.person_rounded, size: 18, color: colors.brand),
                                  const SizedBox(width: 6),
                                  Text(
                                    drivers.any((d) => d.id == _selectedTruck!.assignedDriverId)
                                        ? drivers.firstWhere((d) => d.id == _selectedTruck!.assignedDriverId).name
                                        : "Unassigned",
                                    style: AppTypography.label(colors.text),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),

                    // DRAGGABLE BOTTOM SHEET SCAFFOLD
                    DraggableScrollableSheet(
                      initialChildSize: 0.58,
                      minChildSize: 0.35,
                      maxChildSize: 0.95,
                      snap: true,
                      snapSizes: const [0.35, 0.58, 0.95],
                      builder: (context, scrollController) {
                        return Container(
                          decoration: BoxDecoration(
                            color: colors.bg,
                            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                            border: Border(top: BorderSide(color: colors.border, width: 1.5)),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.15),
                                blurRadius: 16,
                                offset: const Offset(0, -4),
                              ),
                            ],
                          ),
                          child: ListView(
                            controller: scrollController,
                            padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
                            children: [
                              // Drag Handle
                              Center(
                                child: Container(
                                  width: 44,
                                  height: 5,
                                  decoration: BoxDecoration(
                                    color: colors.border,
                                    borderRadius: BorderRadius.circular(3),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 14),

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

                              const SizedBox(height: 18),

                              // NEW TRIP BUTTON
                              PrimaryButton(
                                label: l10n.btnNewTrip,
                                icon: Icons.add_rounded,
                                onPressed: widget.onNewTrip,
                              ),

                              const SizedBox(height: 20),

                              // 3 BIG METRIC TILES
                              KpiTile(
                                label: l10n.runningTrips,
                                count: runningCount,
                                icon: Icons.navigation_rounded,
                                accentColor: colors.brand,
                                containerColor: colors.statusRunningContainer,
                              ),
                              const SizedBox(height: 12),

                              KpiTile(
                                label: l10n.freeTrucks,
                                count: availableTrucks,
                                icon: Icons.local_shipping_rounded,
                                accentColor: colors.statusSuccess,
                                containerColor: colors.statusSuccessContainer,
                              ),
                              const SizedBox(height: 12),

                              KpiTile(
                                label: l10n.deliveredThisMonth,
                                count: deliveredCount,
                                icon: Icons.check_circle_rounded,
                                accentColor: colors.statusSuccess,
                                containerColor: colors.statusSuccessContainer,
                              ),

                              const SizedBox(height: 24),

                              // NEEDS ATTENTION SECTION (Derived alerts)
                              if (workshopTrucks.isNotEmpty ||
                                  waitingCount > 0 ||
                                  expiringLicenceDrivers.isNotEmpty ||
                                  offlineRunningTrucks.isNotEmpty) ...[
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

                                // Alert: Offline during running trip
                                ...offlineRunningTrucks.map((truck) => Padding(
                                      padding: const EdgeInsets.only(bottom: 10),
                                      child: Container(
                                        padding: const EdgeInsets.all(16),
                                        decoration: BoxDecoration(
                                          color: colors.statusDangerContainer,
                                          borderRadius: AppSpacing.buttonBorderRadius,
                                          border: Border.all(
                                              color: colors.statusDanger.withValues(alpha: 0.4), width: 1.5),
                                        ),
                                        child: Row(
                                          children: [
                                            Icon(Icons.signal_cellular_connected_no_internet_4_bar_rounded,
                                                color: colors.statusDanger, size: 28),
                                            const SizedBox(width: 12),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(truck.plate,
                                                      style: AppTypography.heading(colors.text, isNumber: true)),
                                                  Text("GPS offline > 10 min during active transit",
                                                      style: AppTypography.body(colors.statusDanger)),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    )),

                                // Alert: Driver licence expiring soon (< 30 days)
                                ...expiringLicenceDrivers.map((driver) => Padding(
                                      padding: const EdgeInsets.only(bottom: 10),
                                      child: Container(
                                        padding: const EdgeInsets.all(16),
                                        decoration: BoxDecoration(
                                          color: colors.statusWaitingContainer,
                                          borderRadius: AppSpacing.buttonBorderRadius,
                                          border: Border.all(
                                              color: colors.statusWaiting.withValues(alpha: 0.4), width: 1.5),
                                        ),
                                        child: Row(
                                          children: [
                                            Icon(Icons.badge_rounded, color: colors.statusWaiting, size: 28),
                                            const SizedBox(width: 12),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(driver.name, style: AppTypography.heading(colors.text)),
                                                  Text(
                                                      "Driving licence expires in ${driver.licenceExpiryDate!.difference(now).inDays} days",
                                                      style: AppTypography.body(colors.statusWaiting)),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    )),

                                // Alert: Trucks in workshop
                                ...workshopTrucks.map((t) => Padding(
                                      padding: const EdgeInsets.only(bottom: 10),
                                      child: Container(
                                        padding: const EdgeInsets.all(16),
                                        decoration: BoxDecoration(
                                          color: colors.statusDangerContainer,
                                          borderRadius: AppSpacing.buttonBorderRadius,
                                          border: Border.all(
                                              color: colors.statusDanger.withValues(alpha: 0.4), width: 1.5),
                                        ),
                                        child: Row(
                                          children: [
                                            Icon(Icons.build_rounded, color: colors.statusDanger, size: 28),
                                            const SizedBox(width: 12),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(t.plate,
                                                      style: AppTypography.heading(colors.text, isNumber: true)),
                                                  Text("${t.model} · ${l10n.statusInWorkshop}",
                                                      style: AppTypography.body(colors.statusDanger)),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    )),

                                // Alert: Waiting trips
                                if (waitingCount > 0)
                                  Container(
                                    padding: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      color: colors.statusWaitingContainer,
                                      borderRadius: AppSpacing.buttonBorderRadius,
                                      border: Border.all(
                                          color: colors.statusWaiting.withValues(alpha: 0.4), width: 1.5),
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
                                onPressed: widget.onViewAllTrips,
                              ),
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
