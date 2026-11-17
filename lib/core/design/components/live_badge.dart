import "package:flutter/material.dart";
import "../tokens/app_colors.dart";
import "../tokens/app_typography.dart";

enum LiveStatus { live, stale, offline }

class LiveBadge extends StatefulWidget {
  final LiveStatus status;
  final String label;

  const LiveBadge({
    super.key,
    required this.status,
    required this.label,
  });

  factory LiveBadge.fromLastSeen(DateTime? lastSeen) {
    if (lastSeen == null) {
      return const LiveBadge(status: LiveStatus.offline, label: "Offline");
    }
    final diff = DateTime.now().difference(lastSeen);
    if (diff.inMinutes < 2) {
      final s = diff.inSeconds < 10 ? "just now" : "${diff.inSeconds} s ago";
      return LiveBadge(status: LiveStatus.live, label: "Live · updated $s");
    } else if (diff.inMinutes < 10) {
      return LiveBadge(status: LiveStatus.stale, label: "Last seen ${diff.inMinutes} min ago");
    } else {
      return const LiveBadge(status: LiveStatus.offline, label: "Offline");
    }
  }

  @override
  State<LiveBadge> createState() => _LiveBadgeState();
}

class _LiveBadgeState extends State<LiveBadge> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.25).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final disableAnimations = MediaQuery.of(context).disableAnimations;

    Color dotColor;
    Color textColor;

    switch (widget.status) {
      case LiveStatus.live:
        dotColor = colors.statusSuccess;
        textColor = colors.statusSuccess;
        break;
      case LiveStatus.stale:
        dotColor = colors.statusWaiting;
        textColor = colors.statusWaiting;
        break;
      case LiveStatus.offline:
        dotColor = colors.textSecondary;
        textColor = colors.textSecondary;
        break;
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (disableAnimations || widget.status != LiveStatus.live)
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(shape: BoxShape.circle, color: dotColor),
          )
        else
          ScaleTransition(
            scale: _scaleAnimation,
            child: Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(shape: BoxShape.circle, color: dotColor),
            ),
          ),
        const SizedBox(width: 8),
        Flexible(
          child: Text(
            widget.label,
            style: AppTypography.label(textColor),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
