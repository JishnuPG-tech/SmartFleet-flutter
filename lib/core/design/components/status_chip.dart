import "package:flutter/material.dart";
import "../tokens/app_colors.dart";
import "../tokens/app_typography.dart";
import "../tokens/app_spacing.dart";

enum ChipStatusType { success, running, waiting, danger }

class StatusChipV2 extends StatelessWidget {
  final String label;
  final IconData icon;
  final ChipStatusType type;

  const StatusChipV2({
    super.key,
    required this.label,
    required this.icon,
    this.type = ChipStatusType.running,
  });

  factory StatusChipV2.success({required String label, IconData icon = Icons.check_circle_rounded}) {
    return StatusChipV2(label: label, icon: icon, type: ChipStatusType.success);
  }

  factory StatusChipV2.running({required String label, IconData icon = Icons.navigation_rounded}) {
    return StatusChipV2(label: label, icon: icon, type: ChipStatusType.running);
  }

  factory StatusChipV2.waiting({required String label, IconData icon = Icons.hourglass_empty_rounded}) {
    return StatusChipV2(label: label, icon: icon, type: ChipStatusType.waiting);
  }

  factory StatusChipV2.danger({required String label, IconData icon = Icons.build_rounded}) {
    return StatusChipV2(label: label, icon: icon, type: ChipStatusType.danger);
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    late Color textColor;
    late Color containerColor;

    switch (type) {
      case ChipStatusType.success:
        textColor = colors.statusSuccess;
        containerColor = colors.statusSuccessContainer;
        break;
      case ChipStatusType.running:
        textColor = colors.statusRunning;
        containerColor = colors.statusRunningContainer;
        break;
      case ChipStatusType.waiting:
        textColor = colors.statusWaiting;
        containerColor = colors.statusWaitingContainer;
        break;
      case ChipStatusType.danger:
        textColor = colors.statusDanger;
        containerColor = colors.statusDangerContainer;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: containerColor,
        borderRadius: AppSpacing.chipBorderRadius,
        border: Border.all(color: textColor.withValues(alpha: 0.35), width: 1.2),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18, color: textColor),
          const SizedBox(width: 6),
          Flexible(
            child: Text(
              label,
              style: AppTypography.label(textColor),
              overflow: TextOverflow.visible,
            ),
          ),
        ],
      ),
    );
  }
}
