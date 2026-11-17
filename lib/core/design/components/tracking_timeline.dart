import "package:flutter/material.dart";
import "../tokens/app_colors.dart";
import "../tokens/app_typography.dart";

class TimelineStepData {
  final String title;
  final String subtitle;
  final String timestamp;
  final bool isCompleted;
  final bool isCurrent;

  const TimelineStepData({
    required this.title,
    required this.subtitle,
    required this.timestamp,
    this.isCompleted = false,
    this.isCurrent = false,
  });
}

class TrackingTimeline extends StatefulWidget {
  final List<TimelineStepData> steps;

  const TrackingTimeline({
    super.key,
    required this.steps,
  });

  @override
  State<TrackingTimeline> createState() => _TrackingTimelineState();
}

class _TrackingTimelineState extends State<TrackingTimeline> with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 0.9, end: 1.25).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final disableAnimations = MediaQuery.of(context).disableAnimations;

    return Column(
      children: List.generate(widget.steps.length, (index) {
        final step = widget.steps[index];
        final isLast = index == widget.steps.length - 1;

        Color dotColor;
        Widget dotWidget;

        if (step.isCompleted) {
          dotColor = colors.statusSuccess;
          dotWidget = Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(color: dotColor, shape: BoxShape.circle),
            child: const Icon(Icons.check, size: 14, color: Colors.white),
          );
        } else if (step.isCurrent) {
          dotColor = colors.brand;
          final coreDot = Container(
            width: 18,
            height: 18,
            decoration: BoxDecoration(
              color: dotColor,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 2.5),
            ),
          );
          dotWidget = disableAnimations
              ? coreDot
              : ScaleTransition(scale: _pulseAnimation, child: coreDot);
        } else {
          dotColor = colors.border;
          dotWidget = Container(
            width: 16,
            height: 16,
            decoration: BoxDecoration(
              color: colors.surfaceAlt,
              shape: BoxShape.circle,
              border: Border.all(color: dotColor, width: 2),
            ),
          );
        }

        return IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Left: Indicator column + Line
              SizedBox(
                width: 28,
                child: Column(
                  children: [
                    const SizedBox(height: 4),
                    dotWidget,
                    if (!isLast)
                      Expanded(
                        child: Container(
                          width: 2,
                          color: step.isCompleted ? colors.statusSuccess : colors.border,
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(width: 12),

              // Right: Step content & Timestamp
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(bottom: isLast ? 0 : 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              step.title,
                              style: AppTypography.heading(
                                step.isCurrent ? colors.brand : colors.text,
                              ),
                            ),
                          ),
                          Text(
                            step.timestamp,
                            style: AppTypography.label(
                              step.isCurrent ? colors.brand : colors.textSecondary,
                              isNumber: true,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        step.subtitle,
                        style: AppTypography.body(colors.textSecondary),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
