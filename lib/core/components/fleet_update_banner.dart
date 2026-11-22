import "package:flutter/material.dart";
import "../design/tokens/app_colors.dart";
import "../design/tokens/app_typography.dart";
import "../design/tokens/app_spacing.dart";

class FleetUpdateBanner extends StatelessWidget {
  final String version;
  final double? progress;
  final VoidCallback onUpdate;

  const FleetUpdateBanner({
    super.key,
    required this.version,
    this.progress,
    required this.onUpdate,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: colors.brand.withValues(alpha: 0.12),
        borderRadius: AppSpacing.cardBorderRadius,
        border: Border.all(color: colors.brand.withValues(alpha: 0.4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.system_update_rounded, size: 20, color: colors.brand),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  "New Update Available (v$version)",
                  style: AppTypography.label(colors.brand),
                ),
              ),
              if (progress == null)
                TextButton(
                  onPressed: onUpdate,
                  child: const Text("UPDATE NOW"),
                ),
            ],
          ),
          if (progress != null) ...[
            const SizedBox(height: 10),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: progress,
                backgroundColor: colors.surfaceAlt,
                valueColor: AlwaysStoppedAnimation<Color>(colors.brand),
                minHeight: 6,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
