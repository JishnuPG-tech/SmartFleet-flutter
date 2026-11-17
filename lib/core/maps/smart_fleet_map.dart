import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../design/tokens/app_colors.dart';
import '../design/tokens/app_typography.dart';
import '../data/models/truck.dart';

/// Reusable map component powered by open-source vector/raster tiles (CartoDB & OSM).
/// Adapts seamlessly to Light (Positron/Voyager) and Dark (Dark Matter) modes with zero API keys.
class SmartFleetMap extends StatelessWidget {
  final LatLng center;
  final double zoom;
  final double minZoom;
  final double maxZoom;
  final List<Polyline>? polylines;
  final List<Marker>? markers;
  final MapController? controller;
  final bool interactive;
  final Function(TapPosition, LatLng)? onTap;

  const SmartFleetMap({
    super.key,
    required this.center,
    this.zoom = 13.0,
    this.minZoom = 5.0,
    this.maxZoom = 18.0,
    this.polylines,
    this.markers,
    this.controller,
    this.interactive = true,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // CartoDB tiles provide clean, muted logistics-style roads with zero clutter
    final tileUrl = isDark
        ? 'https://{s}.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}@2x.png'
        : 'https://{s}.basemaps.cartocdn.com/rastertiles/voyager/{z}/{x}/{y}@2x.png';

    return ClipRRect(
      child: FlutterMap(
        mapController: controller,
        options: MapOptions(
          initialCenter: center,
          initialZoom: zoom,
          minZoom: minZoom,
          maxZoom: maxZoom,
          interactionOptions: InteractionOptions(
            flags: interactive ? InteractiveFlag.all : InteractiveFlag.none,
          ),
          onTap: onTap,
        ),
        children: [
          TileLayer(
            urlTemplate: tileUrl,
            subdomains: const ['a', 'b', 'c', 'd'],
            userAgentPackageName: 'com.agy.smartfleet',
            retinaMode: true,
            maxZoom: 19,
          ),
          if (polylines != null && polylines!.isNotEmpty)
            PolylineLayer(
              polylines: polylines!,
            ),
          if (markers != null && markers!.isNotEmpty)
            MarkerLayer(
              markers: markers!,
            ),
        ],
      ),
    );
  }

  /// Factory helper for creating an accessible truck marker
  static Marker buildTruckMarker({
    required LatLng position,
    required String plateNumber,
    required TruckStatus status,
    required AppColorsExtension colors,
    double heading = 0.0,
    VoidCallback? onTap,
  }) {
    Color markerBg;
    switch (status) {
      case TruckStatus.available:
        markerBg = colors.statusSuccess;
        break;
      case TruckStatus.onTrip:
        markerBg = colors.brand;
        break;
      case TruckStatus.inWorkshop:
        markerBg = colors.statusDanger;
        break;
    }

    return Marker(
      point: position,
      width: 52,
      height: 52,
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Transform.rotate(
              angle: heading * (3.141592653589793 / 180.0),
              child: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: markerBg,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2.5),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.25),
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.local_shipping_rounded,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
            const SizedBox(height: 2),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
              decoration: BoxDecoration(
                color: colors.surface,
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: colors.border, width: 1),
              ),
              child: Text(
                plateNumber,
                style: AppTypography.label(colors.text).copyWith(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                ),
                maxLines: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Factory helper for destination/origin pins
  static Marker buildPinMarker({
    required LatLng position,
    required IconData icon,
    required Color color,
    required String label,
    required AppColorsExtension colors,
  }) {
    return Marker(
      point: position,
      width: 60,
      height: 50,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 2),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.2),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Icon(icon, color: Colors.white, size: 16),
          ),
          const SizedBox(height: 2),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
            decoration: BoxDecoration(
              color: colors.surface,
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: colors.border, width: 1),
            ),
            child: Text(
              label,
              style: AppTypography.label(colors.text).copyWith(
                fontSize: 10,
                fontWeight: FontWeight.w600,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
