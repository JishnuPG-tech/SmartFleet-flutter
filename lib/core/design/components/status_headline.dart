import "package:flutter/material.dart";
import "../tokens/app_colors.dart";
import "../tokens/app_typography.dart";

class StatusHeadline extends StatelessWidget {
  final String headline;
  final String? subtitle;
  final Color? headlineColor;

  const StatusHeadline({
    super.key,
    required this.headline,
    this.subtitle,
    this.headlineColor,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final primaryColor = headlineColor ?? colors.text;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          headline,
          style: AppTypography.title(primaryColor),
        ),
        if (subtitle != null) ...[
          const SizedBox(height: 4),
          Text(
            subtitle!,
            style: AppTypography.body(colors.textSecondary),
          ),
        ],
      ],
    );
  }
}
