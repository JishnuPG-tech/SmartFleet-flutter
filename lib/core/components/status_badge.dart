import 'package:flutter/material.dart';
import '../models/fleet_models.dart';
import '../theme/app_colors.dart';

class StatusBadge extends StatelessWidget {
  final String label;
  final Color color;
  final bool showDot;

  const StatusBadge({
    super.key,
    String? label,
    Color? color,
    dynamic status,
    this.showDot = true,
  })  : label = label ??
            (status == TripStatus.active
                ? 'Active'
                : status == TripStatus.completed
                    ? 'Delivered'
                    : status == TripStatus.assigned
                        ? 'Assigned'
                        : status == TripStatus.pending
                            ? 'Pending'
                            : 'Active'),
        color = color ??
            (status == TripStatus.active
                ? AppColors.accent
                : status == TripStatus.completed
                    ? AppColors.green
                    : status == TripStatus.assigned
                        ? AppColors.blue
                        : status == TripStatus.pending
                            ? AppColors.orange
                            : AppColors.accent);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: color.withOpacity(0.35),
          width: 0.8,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showDot) ...[
            Container(
              width: 6,
              height: 6,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: color.withOpacity(0.6),
                    blurRadius: 4,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 6),
          ],
          Text(
            label.toUpperCase(),
            style: TextStyle(
              color: color,
              fontSize: 10,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.8,
            ),
          ),
        ],
      ),
    );
  }
}
