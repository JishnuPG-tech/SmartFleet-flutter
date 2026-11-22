import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "../design/tokens/app_colors.dart";
import "../design/tokens/app_typography.dart";
import "../design/tokens/app_spacing.dart";

enum FleetButtonVariant { primary, secondary, outline, ghost, destructive }

class FleetButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final FleetButtonVariant variant;
  final IconData? icon;
  final bool isLoading;
  final bool isDriverMode; // 56dp oversized touch target for cab driving
  final double? width;

  const FleetButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.variant = FleetButtonVariant.primary,
    this.icon,
    this.isLoading = false,
    this.isDriverMode = false,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final height = isDriverMode ? 56.0 : 48.0;

    Color bg;
    Color fg;
    BorderSide border = BorderSide.none;

    switch (variant) {
      case FleetButtonVariant.primary:
        bg = colors.brand;
        fg = colors.onBrand;
        break;
      case FleetButtonVariant.secondary:
        bg = colors.surfaceAlt;
        fg = colors.text;
        break;
      case FleetButtonVariant.outline:
        bg = Colors.transparent;
        fg = colors.text;
        border = BorderSide(color: colors.border, width: 1.5);
        break;
      case FleetButtonVariant.ghost:
        bg = Colors.transparent;
        fg = colors.textSecondary;
        break;
      case FleetButtonVariant.destructive:
        bg = colors.statusDanger;
        fg = Colors.white;
        break;
    }

    final disabled = onPressed == null || isLoading;

    return SizedBox(
      width: width ?? double.infinity,
      height: height,
      child: Material(
        color: disabled ? bg.withValues(alpha: 0.35) : bg,
        shape: RoundedRectangleBorder(
          borderRadius: AppSpacing.buttonBorderRadius,
          side: border,
        ),
        child: InkWell(
          onTap: disabled
              ? null
              : () {
                  HapticFeedback.lightImpact();
                  onPressed?.call();
                },
          borderRadius: AppSpacing.buttonBorderRadius,
          child: Center(
            child: isLoading
                ? SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      valueColor: AlwaysStoppedAnimation<Color>(fg),
                    ),
                  )
                : Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (icon != null) ...[
                        Icon(icon, size: 18, color: fg),
                        const SizedBox(width: 8),
                      ],
                      Text(
                        label,
                        style: AppTypography.button(fg).copyWith(
                          fontSize: isDriverMode ? 17 : 15,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
