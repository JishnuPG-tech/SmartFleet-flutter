import "package:flutter/material.dart";
import "../design/tokens/app_colors.dart";
import "../design/tokens/app_typography.dart";
import "../design/tokens/app_spacing.dart";

enum FleetAlertType { warning, error, info }

class FleetAlertBanner extends StatelessWidget {
  final String title;
  final String message;
  final FleetAlertType type;
  final VoidCallback? onAction;
  final String? actionLabel;

  const FleetAlertBanner({
    super.key,
    required this.title,
    required this.message,
    this.type = FleetAlertType.warning,
    this.onAction,
    this.actionLabel,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    Color fg;
    Color bg;
    IconData icon;

    switch (type) {
      case FleetAlertType.error:
        fg = colors.statusDanger;
        bg = colors.statusDangerContainer;
        icon = Icons.error_outline;
        break;
      case FleetAlertType.warning:
        fg = colors.statusWaiting;
        bg = colors.statusWaitingContainer;
        icon = Icons.warning_amber_rounded;
        break;
      case FleetAlertType.info:
        fg = colors.statusRunning;
        bg = colors.statusRunningContainer;
        icon = Icons.info_outline;
        break;
    }

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: AppSpacing.cardBorderRadius,
        border: Border.all(color: fg.withValues(alpha: 0.4), width: 1.0),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: fg),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTypography.label(fg)),
                const SizedBox(height: 2),
                Text(message, style: AppTypography.caption(colors.text)),
                if (actionLabel != null && onAction != null) ...[
                  const SizedBox(height: 8),
                  GestureDetector(
                    onTap: onAction,
                    child: Text(
                      actionLabel!,
                      style: AppTypography.label(fg).copyWith(decoration: TextDecoration.underline),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
