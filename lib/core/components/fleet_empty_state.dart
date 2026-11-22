import "package:flutter/material.dart";
import "../design/tokens/app_colors.dart";
import "../design/tokens/app_typography.dart";
import "fleet_button.dart";

class FleetEmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final String? actionLabel;
  final VoidCallback? onAction;

  const FleetEmptyState({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
    this.actionLabel,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: colors.surfaceAlt,
              ),
              child: Icon(icon, size: 32, color: colors.textSecondary),
            ),
            const SizedBox(height: 16),
            Text(title, style: AppTypography.heading(colors.text), textAlign: TextAlign.center),
            const SizedBox(height: 8),
            Text(description, style: AppTypography.body(colors.textSecondary), textAlign: TextAlign.center),
            if (actionLabel != null && onAction != null) ...[
              const SizedBox(height: 24),
              FleetButton(label: actionLabel!, onPressed: onAction, width: 200),
            ],
          ],
        ),
      ),
    );
  }
}
