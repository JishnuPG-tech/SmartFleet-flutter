import "package:flutter/material.dart";
import "../design/tokens/app_colors.dart";
import "../design/tokens/app_typography.dart";

enum FleetOperationalStatus { active, running, idle, alert, offDuty }

class FleetStatusBadge extends StatefulWidget {
  final FleetOperationalStatus status;
  final String? customLabel;
  final bool showPulse;

  const FleetStatusBadge({
    super.key,
    required this.status,
    this.customLabel,
    this.showPulse = true,
  });

  @override
  State<FleetStatusBadge> createState() => _FleetStatusBadgeState();
}

class _FleetStatusBadgeState extends State<FleetStatusBadge> with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    Color fg;
    Color bg;
    IconData icon;
    String text;

    switch (widget.status) {
      case FleetOperationalStatus.active:
        fg = colors.statusSuccess;
        bg = colors.statusSuccessContainer;
        icon = Icons.check_circle_outline;
        text = widget.customLabel ?? "ONLINE";
        break;
      case FleetOperationalStatus.running:
        fg = colors.statusRunning;
        bg = colors.statusRunningContainer;
        icon = Icons.navigation_outlined;
        text = widget.customLabel ?? "EN ROUTE";
        break;
      case FleetOperationalStatus.idle:
        fg = colors.statusWaiting;
        bg = colors.statusWaitingContainer;
        icon = Icons.pause_circle_outline;
        text = widget.customLabel ?? "IDLE";
        break;
      case FleetOperationalStatus.alert:
        fg = colors.statusDanger;
        bg = colors.statusDangerContainer;
        icon = Icons.warning_amber_rounded;
        text = widget.customLabel ?? "DELAYED";
        break;
      case FleetOperationalStatus.offDuty:
        fg = colors.textSecondary;
        bg = colors.surfaceAlt;
        icon = Icons.nightlight_round;
        text = widget.customLabel ?? "OFF DUTY";
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: fg.withValues(alpha: 0.35), width: 1.0),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (widget.showPulse && widget.status == FleetOperationalStatus.running)
            AnimatedBuilder(
              animation: _pulseController,
              builder: (context, child) {
                return Container(
                  width: 8,
                  height: 8,
                  margin: const EdgeInsets.only(right: 6),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: fg.withValues(alpha: 0.4 + 0.6 * _pulseController.value),
                  ),
                );
              },
            )
          else ...[
            Icon(icon, size: 14, color: fg),
            const SizedBox(width: 5),
          ],
          Text(
            text,
            style: AppTypography.mono(fg, fontSize: 11, fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}
