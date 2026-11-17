import "package:flutter/material.dart";
import "package:flutter_map/flutter_map.dart";
import "package:latlong2/latlong.dart";
import "../design/tokens/app_colors.dart";
import "../design/tokens/app_typography.dart";
import "../design/tokens/app_spacing.dart";
import "../data/models/truck.dart";

/// Reusable map component powered by official OpenStreetMap tiles with zero API keys or watermarks.
/// Uses ColorFilter matrix inversion in Dark Mode for a sleek Midnight logistics aesthetic.
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
    final colors = context.colors;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      color: colors.bg,
      child: ClipRRect(
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
              urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
              userAgentPackageName: "com.smartfleet.app.smartfleet_flutter",
              maxZoom: 19,
              tileBuilder: isDark
                  ? (context, tileWidget, tile) {
                      return ColorFiltered(
                        colorFilter: const ColorFilter.matrix([
                          -0.82, 0, 0, 0, 230,
                          0, -0.82, 0, 0, 230,
                          0, 0, -0.82, 0, 230,
                          0, 0, 0, 1, 0,
                        ]),
                        child: tileWidget,
                      );
                    }
                  : null,
              errorTileCallback: (tile, error, stackTrace) {
                // Graceful fallback on network/tile failure
              },
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
    Color iconColor;
    switch (status) {
      case TruckStatus.available:
        markerBg = colors.brand;
        iconColor = colors.onBrand;
        break;
      case TruckStatus.onTrip:
        markerBg = colors.brand;
        iconColor = colors.onBrand;
        break;
      case TruckStatus.inWorkshop:
        markerBg = colors.statusDanger;
        iconColor = Colors.white;
        break;
    }

    return Marker(
      point: position,
      width: 54,
      height: 54,
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Transform.rotate(
              angle: heading * (3.141592653589793 / 180.0),
              child: Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: markerBg,
                  shape: BoxShape.circle,
                  border: Border.all(color: colors.surface, width: 2.0),
                  boxShadow: const [
                    BoxShadow(
                      color: Color.fromRGBO(0, 0, 0, 0.4),
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.local_shipping_rounded,
                  color: iconColor,
                  size: 18,
                ),
              ),
            ),
            const SizedBox(height: 2),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
              decoration: BoxDecoration(
                color: colors.surface,
                borderRadius: BorderRadius.circular(AppSpacing.radiusChip),
                border: Border.all(color: colors.border, width: 1),
              ),
              child: Text(
                plateNumber,
                style: AppTypography.supporting(colors.text).copyWith(
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
      width: 64,
      height: 52,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              border: Border.all(color: colors.surface, width: 2),
              boxShadow: const [
                BoxShadow(
                  color: Color.fromRGBO(0, 0, 0, 0.3),
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Icon(icon, color: Colors.white, size: 14),
          ),
          const SizedBox(height: 2),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
            decoration: BoxDecoration(
              color: colors.surface,
              borderRadius: BorderRadius.circular(AppSpacing.radiusChip),
              border: Border.all(color: colors.border, width: 1),
            ),
            child: Text(
              label,
              style: AppTypography.supporting(colors.text).copyWith(
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
