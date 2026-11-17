import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "../tokens/app_colors.dart";
import "../tokens/app_typography.dart";
import "../tokens/app_spacing.dart";

class PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool isLoading;

  const PrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return SizedBox(
      height: 56,
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: colors.brand,
          foregroundColor: colors.onBrand,
          shape: RoundedRectangleBorder(borderRadius: AppSpacing.buttonBorderRadius),
          elevation: 0,
        ),
        onPressed: isLoading || onPressed == null
            ? null
            : () {
                HapticFeedback.lightImpact();
                onPressed!();
              },
        child: isLoading
            ? SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  valueColor: AlwaysStoppedAnimation<Color>(colors.onBrand),
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (icon != null) ...[
                    Icon(icon, size: 22, color: colors.onBrand),
                    const SizedBox(width: 8),
                  ],
                  Flexible(
                    child: Text(
                      label,
                      style: AppTypography.heading(colors.onBrand),
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

class SecondaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;

  const SecondaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return SizedBox(
      height: 56,
      width: double.infinity,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          foregroundColor: colors.text,
          side: BorderSide(color: colors.border, width: 1.5),
          shape: RoundedRectangleBorder(borderRadius: AppSpacing.buttonBorderRadius),
        ),
        onPressed: onPressed == null
            ? null
            : () {
                HapticFeedback.lightImpact();
                onPressed!();
              },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 22, color: colors.text),
              const SizedBox(width: 8),
            ],
            Flexible(
              child: Text(
                label,
                style: AppTypography.heading(colors.text),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DangerButton extends StatelessWidget {
  final String label;
  final String confirmTitle;
  final String confirmMessage;
  final String confirmActionLabel;
  final VoidCallback onConfirmed;
  final IconData? icon;

  const DangerButton({
    super.key,
    required this.label,
    required this.confirmTitle,
    required this.confirmMessage,
    required this.confirmActionLabel,
    required this.onConfirmed,
    this.icon,
  });

  void _showConfirmSheet(BuildContext context) {
    final colors = context.colors;
    showModalBottomSheet(
      context: context,
      backgroundColor: colors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.warning_amber_rounded, color: colors.statusDanger, size: 30),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(confirmTitle, style: AppTypography.title(colors.statusDanger)),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(confirmMessage, style: AppTypography.body(colors.textSecondary)),
                const SizedBox(height: 24),
                SizedBox(
                  height: 56,
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colors.statusDanger,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: AppSpacing.buttonBorderRadius),
                    ),
                    onPressed: () {
                      Navigator.pop(ctx);
                      HapticFeedback.mediumImpact();
                      onConfirmed();
                    },
                    child: Text(confirmActionLabel, style: AppTypography.heading(Colors.white)),
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  height: 56,
                  width: double.infinity,
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: colors.text,
                      side: BorderSide(color: colors.border, width: 1.5),
                      shape: RoundedRectangleBorder(borderRadius: AppSpacing.buttonBorderRadius),
                    ),
                    onPressed: () => Navigator.pop(ctx),
                    child: Text("Cancel", style: AppTypography.heading(colors.text)),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return SizedBox(
      height: 56,
      width: double.infinity,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          foregroundColor: colors.statusDanger,
          side: BorderSide(color: colors.statusDanger.withValues(alpha: 0.5), width: 1.5),
          shape: RoundedRectangleBorder(borderRadius: AppSpacing.buttonBorderRadius),
        ),
        onPressed: () => _showConfirmSheet(context),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 22, color: colors.statusDanger),
              const SizedBox(width: 8),
            ],
            Flexible(
              child: Text(
                label,
                style: AppTypography.heading(colors.statusDanger),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
