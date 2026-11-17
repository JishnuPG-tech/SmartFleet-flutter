import "package:flutter/material.dart";
import "../tokens/app_colors.dart";
import "../tokens/app_typography.dart";

class SettingsTile extends StatelessWidget {
  final String title;
  final String? subtitle;
  final IconData icon;
  final Widget? trailing;
  final VoidCallback? onTap;

  const SettingsTile({
    super.key,
    required this.title,
    this.subtitle,
    required this.icon,
    this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      leading: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: colors.brand.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: colors.brand, size: 24),
      ),
      title: Text(title, style: AppTypography.heading(colors.text)),
      subtitle: subtitle != null
          ? Text(subtitle!, style: AppTypography.body(colors.textSecondary))
          : null,
      trailing: trailing ?? const Icon(Icons.chevron_right_rounded, size: 24),
      onTap: onTap,
    );
  }
}
