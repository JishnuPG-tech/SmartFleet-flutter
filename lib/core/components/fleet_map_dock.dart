import "package:flutter/material.dart";
import "package:url_launcher/url_launcher.dart";
import "../design/tokens/app_colors.dart";
import "../design/tokens/app_typography.dart";
import "../design/tokens/app_spacing.dart";

class FleetMapDock extends StatelessWidget {
  final double currentSpeed;
  final String eta;
  final String nextManeuver;
  final VoidCallback? onRecenter;
  final double destLat;
  final double destLng;

  const FleetMapDock({
    super.key,
    required this.currentSpeed,
    required this.eta,
    required this.nextManeuver,
    this.onRecenter,
    required this.destLat,
    required this.destLng,
  });

  Future<void> _openExternalNavigation() async {
    final uri = Uri.parse("https://www.google.com/maps/dir/?api=1&destination=$destLat,$destLng&travelmode=driving");
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Top row: Compass Recenter + Google Maps External Nav Button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (onRecenter != null)
                FloatingActionButton.small(
                  heroTag: "recenter_fab",
                  backgroundColor: colors.surface,
                  foregroundColor: colors.brand,
                  onPressed: onRecenter,
                  child: const Icon(Icons.my_location_rounded, size: 20),
                ),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: colors.surface,
                  foregroundColor: colors.brand,
                  side: BorderSide(color: colors.border),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                ),
                onPressed: _openExternalNavigation,
                icon: const Icon(Icons.map_outlined, size: 18),
                label: const Text("Open in Google Maps"),
              ),
            ],
          ),
          const SizedBox(height: 10),
          // Maneuver and Speed Bar (Vela Navigation Spec)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: colors.surface,
              borderRadius: AppSpacing.cardBorderRadius,
              border: Border.all(color: colors.border, width: 1.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.15),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                // Speed Pill
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: colors.surfaceAlt,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      Text(
                        currentSpeed.toStringAsFixed(0),
                        style: AppTypography.number(colors.brand, fontSize: 24),
                      ),
                      Text("KM/H", style: AppTypography.caption(colors.textSecondary)),
                    ],
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(nextManeuver, style: AppTypography.label(colors.text)),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          Icon(Icons.timer_outlined, size: 14, color: colors.brand),
                          const SizedBox(width: 4),
                          Text(eta, style: AppTypography.caption(colors.brand)),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
