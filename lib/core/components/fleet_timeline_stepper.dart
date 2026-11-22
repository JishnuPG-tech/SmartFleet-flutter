import "package:flutter/material.dart";
import "../design/tokens/app_colors.dart";
import "../design/tokens/app_typography.dart";

class FleetTimelineStep {
  final String title;
  final String subtitle;
  final String time;
  final bool isCompleted;
  final bool isActive;

  const FleetTimelineStep({
    required this.title,
    required this.subtitle,
    required this.time,
    this.isCompleted = false,
    this.isActive = false,
  });
}

class FleetTimelineStepper extends StatelessWidget {
  final List<FleetTimelineStep> steps;

  const FleetTimelineStepper({super.key, required this.steps});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Column(
      children: List.generate(steps.length, (index) {
        final step = steps[index];
        final isLast = index == steps.length - 1;

        Color nodeColor = colors.border;
        if (step.isCompleted) nodeColor = colors.statusSuccess;
        if (step.isActive) nodeColor = colors.brand;

        return IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: step.isCompleted || step.isActive ? nodeColor : colors.surfaceAlt,
                      border: Border.all(color: nodeColor, width: 2),
                    ),
                    child: step.isCompleted
                        ? const Icon(Icons.check, size: 12, color: Colors.white)
                        : (step.isActive
                            ? Center(
                                child: Container(
                                  width: 6,
                                  height: 6,
                                  decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.white),
                                ),
                              )
                            : null),
                  ),
                  if (!isLast)
                    Expanded(
                      child: Container(
                        width: 2,
                        color: step.isCompleted ? colors.statusSuccess : colors.border,
                      ),
                    ),
                ],
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(bottom: isLast ? 0 : 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            step.title,
                            style: AppTypography.label(step.isActive ? colors.brand : colors.text),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            step.subtitle,
                            style: AppTypography.caption(colors.textSecondary),
                          ),
                        ],
                      ),
                      Text(
                        step.time,
                        style: AppTypography.mono(colors.textSecondary, fontSize: 11),
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
