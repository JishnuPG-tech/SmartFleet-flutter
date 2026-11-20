import "dart:async";
import "package:flutter/material.dart";
import "package:flutter_map/flutter_map.dart";
import "package:latlong2/latlong.dart";
import "package:url_launcher/url_launcher.dart";

import "../../core/data/models/trip.dart";
import "../../core/data/config_manager.dart";
import "../../core/design/tokens/app_colors.dart";
import "../../core/design/tokens/app_typography.dart";
import "../../core/design/tokens/app_spacing.dart";
import "../../core/maps/kerala_locations.dart";
import "../../core/data/highway_routes.dart";
import "../../core/telemetry/gps_telemetry_service.dart";

class LiveTrackingScreen extends StatefulWidget {
  final Trip trip;

  const LiveTrackingScreen({super.key, required this.trip});

  @override
  State<LiveTrackingScreen> createState() => _LiveTrackingScreenState();
}

class _LiveTrackingScreenState extends State<LiveTrackingScreen> {
  final MapController _mapController = MapController();
  List<LatLng> _routePoints = [];

  @override
  void initState() {
    super.initState();
    _loadHighwayRoute();

    // Start mobile phone GPS telemetry streaming for this trip
    GpsTelemetryService.instance.startTracking(
      tripId: widget.trip.id,
      truckPlate: widget.trip.truckPlate,
      initialLat: widget.trip.from == "Kochi" ? 9.9312 : 11.2588,
      initialLng: widget.trip.from == "Kochi" ? 76.2673 : 75.7804,
    );
  }

  void _loadHighwayRoute() {
    final origin = KeralaLocations.resolve(widget.trip.from);
    final destination = KeralaLocations.resolve(widget.trip.to);
    final points = HighwayRoutes.getCorridorPolyline(
      widget.trip.from,
      widget.trip.to,
      fallbackOrigin: origin,
      fallbackDest: destination,
    );
    if (mounted) {
      setState(() {
        _routePoints = points;
      });
    } else {
      _routePoints = points;
    }
  }

  Future<void> _makeCall(String phone) async {
    final uri = Uri.parse("tel:${phone.replaceAll(' ', '')}");
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final origin = KeralaLocations.resolve(widget.trip.from);
    final destination = KeralaLocations.resolve(widget.trip.to);

    return Scaffold(
      backgroundColor: colors.bg,
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Route HUD: ${widget.trip.id}",
              style: AppTypography.title(colors.text, fontSize: 18),
            ),
            Text(
              "${widget.trip.from} ➔ ${widget.trip.to}",
              style: AppTypography.supporting(colors.brand, fontSize: 12).copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(color: colors.border, height: 1.0),
        ),
      ),
      body: AnimatedBuilder(
        animation: GpsTelemetryService.instance,
        builder: (context, _) {
          final currentLat = GpsTelemetryService.instance.currentLat;
          final currentLng = GpsTelemetryService.instance.currentLng;
          final currentSpeed = GpsTelemetryService.instance.currentSpeedKmh;
          final currentHeading = GpsTelemetryService.instance.currentHeading;
          final currentPos = LatLng(currentLat, currentLng);

          return Stack(
            children: [
              // 1. Full-Screen Interactive Highway Map
              FlutterMap(
                mapController: _mapController,
                options: MapOptions(
                  initialCenter: currentPos,
                  initialZoom: 12.0,
                ),
                children: [
                  TileLayer(
                    urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
                    userAgentPackageName: "com.smartfleet.kerala",
                  ),
                  if (_routePoints.isNotEmpty)
                    PolylineLayer(
                      polylines: [
                        Polyline(
                          points: _routePoints,
                          strokeWidth: 5.0,
                          color: colors.brand.withValues(alpha: 0.85),
                        ),
                      ],
                    ),
                  MarkerLayer(
                    markers: [
                      // Origin Marker
                      Marker(
                        point: origin,
                        width: 32,
                        height: 32,
                        child: const Icon(Icons.circle, color: Colors.blue, size: 16),
                      ),
                      // Destination Marker
                      Marker(
                        point: destination,
                        width: 32,
                        height: 32,
                        child: const Icon(Icons.flag_rounded, color: Colors.red, size: 28),
                      ),
                      // Moving Vehicle Puck with Heading Rotation
                      Marker(
                        point: currentPos,
                        width: 44,
                        height: 44,
                        child: Transform.rotate(
                          angle: currentHeading * (3.14159265359 / 180.0),
                          child: Container(
                            decoration: BoxDecoration(
                              color: colors.brand,
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 2.5),
                              boxShadow: [
                                BoxShadow(
                                  color: colors.brand.withValues(alpha: 0.4),
                                  blurRadius: 10,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                            child: const Icon(Icons.navigation_rounded, color: Colors.black, size: 24),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              // 2. Top Navigation Metric HUD Bar
              Positioned(
                top: 16,
                left: 16,
                right: 16,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: colors.surface.withValues(alpha: 0.95),
                    borderRadius: AppSpacing.cardBorderRadius,
                    border: Border.all(color: colors.border, width: 1.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text("SPEED", style: AppTypography.supporting(colors.textSecondary, fontSize: 11)),
                          Text(
                            "${currentSpeed.toStringAsFixed(0)} km/h",
                            style: AppTypography.number(colors.text, fontSize: 24),
                          ),
                        ],
                      ),
                      Container(width: 1, height: 32, color: colors.border),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text("REMAINING", style: AppTypography.supporting(colors.textSecondary, fontSize: 11)),
                          Text(
                            "${(widget.trip.distanceKm - widget.trip.distanceDoneKm).clamp(0, 999).toStringAsFixed(0)} km",
                            style: AppTypography.number(colors.brand, fontSize: 24),
                          ),
                        ],
                      ),
                      Container(width: 1, height: 32, color: colors.border),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text("STATUS", style: AppTypography.supporting(colors.textSecondary, fontSize: 11)),
                          Row(
                            children: [
                              Container(width: 8, height: 8, decoration: BoxDecoration(color: colors.statusSuccess, shape: BoxShape.circle)),
                              const SizedBox(width: 6),
                              Text("LIVE GPS", style: AppTypography.supporting(colors.statusSuccess, fontSize: 13).copyWith(fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              // 3. Bottom Action Deck: Recenter, Call Office & SOS Breakdown
              Positioned(
                bottom: 24,
                left: 16,
                right: 16,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Recenter Floating Button
                    Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: FloatingActionButton.small(
                          heroTag: "recenter_hud",
                          backgroundColor: colors.surface,
                          foregroundColor: colors.brand,
                          onPressed: () {
                            _mapController.move(currentPos, 14.0);
                          },
                          child: const Icon(Icons.my_location_rounded),
                        ),
                      ),
                    ),

                    // Urgent Dual-Action Touch Targets (≥56dp)
                    Row(
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: 56,
                            child: OutlinedButton.icon(
                              style: OutlinedButton.styleFrom(
                                backgroundColor: colors.surface,
                                side: BorderSide(color: colors.border, width: 1.5),
                                shape: RoundedRectangleBorder(borderRadius: AppSpacing.buttonBorderRadius),
                              ),
                              onPressed: () {
                                final phone = ConfigManager.instance.emergencyContacts.officeDispatch;
                                _makeCall(phone);
                              },
                              icon: Icon(Icons.phone_in_talk_rounded, color: colors.brand, size: 22),
                              label: Text(
                                "Call Office",
                                style: AppTypography.button(colors.text, fontSize: 15),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: SizedBox(
                            height: 56,
                            child: ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: colors.statusDanger,
                                foregroundColor: Colors.white,
                                elevation: 4,
                                shape: RoundedRectangleBorder(borderRadius: AppSpacing.buttonBorderRadius),
                              ),
                              onPressed: () {
                                final police = ConfigManager.instance.emergencyContacts.highwayPolice;
                                _makeCall(police);
                              },
                              icon: const Icon(Icons.warning_amber_rounded, size: 22),
                              label: Text(
                                "SOS Breakdown",
                                style: AppTypography.button(Colors.white, fontSize: 15),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
