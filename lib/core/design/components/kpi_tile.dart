import "package:flutter/material.dart";
import "../tokens/app_colors.dart";
import "../tokens/app_typography.dart";
import "../tokens/app_spacing.dart";

class KpiTile extends StatefulWidget {
  final String label;
  final int count;
  final IconData icon;
  final Color accentColor;
  final Color containerColor;
  final VoidCallback? onTap;

  const KpiTile({
    super.key,
    required this.label,
    required this.count,
    required this.icon,
    required this.accentColor,
    required this.containerColor,
    this.onTap,
  });

  @override
  State<KpiTile> createState() => _KpiTileState();
}

class _KpiTileState extends State<KpiTile> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<int> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _animation = IntTween(begin: 0, end: widget.count).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );
    _controller.forward();
  }

  @override
  void didUpdateWidget(covariant KpiTile oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.count != widget.count) {
      _animation = IntTween(begin: oldWidget.count, end: widget.count).animate(
        CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
      );
      _controller.forward(from: 0);
    }
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

    return Card(
      child: InkWell(
        onTap: widget.onTap,
        borderRadius: AppSpacing.cardBorderRadius,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: widget.containerColor,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(widget.icon, size: 32, color: widget.accentColor),
              ),
              const SizedBox(width: 18),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AnimatedBuilder(
                      animation: _animation,
                      builder: (context, _) {
                        final val = disableAnimations ? widget.count : _animation.value;
                        return Text(
                          val.toString(),
                          style: AppTypography.display(widget.accentColor, isNumber: true),
                        );
                      },
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.label,
                      style: AppTypography.heading(colors.text),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
