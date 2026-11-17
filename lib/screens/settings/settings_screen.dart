import "package:flutter/material.dart";
import "../../core/design/tokens/app_colors.dart";
import "../../core/design/tokens/app_typography.dart";
import "../../core/design/tokens/app_spacing.dart";
import "../../core/design/theme/theme_controller.dart";
import "../../l10n/app_localizations.dart";
import "../dev/component_gallery_screen.dart";
import "../auth/role_select_screen.dart";

class SettingsScreen extends StatelessWidget {
  final VoidCallback? onToggleLanguage;

  const SettingsScreen({super.key, this.onToggleLanguage});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.settingsTitle, style: AppTypography.title(colors.text)),
      ),
      body: AnimatedBuilder(
        animation: ThemeController.instance,
        builder: (context, _) {
          final currentMode = ThemeController.instance.mode;

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // 1. THEME MODE PICKER (3 BIG TILES WITH PREVIEWS)
              Text("Theme Appearance", style: AppTypography.heading(colors.text)),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _buildThemeTile(
                      context,
                      label: "System",
                      mode: ThemeMode.system,
                      isSelected: currentMode == ThemeMode.system,
                      bgPreview: const Color(0xFF888888),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildThemeTile(
                      context,
                      label: "Light",
                      mode: ThemeMode.light,
                      isSelected: currentMode == ThemeMode.light,
                      bgPreview: const Color(0xFFF6F7F9),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildThemeTile(
                      context,
                      label: "Dark",
                      mode: ThemeMode.dark,
                      isSelected: currentMode == ThemeMode.dark,
                      bgPreview: const Color(0xFF0E1116),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 28),

              // 2. LANGUAGE SWITCH
              Text(l10n.selectLanguage, style: AppTypography.heading(colors.text)),
              const SizedBox(height: 12),
              Card(
                child: ListTile(
                  leading: const Icon(Icons.language_rounded),
                  title: Text(
                    Localizations.localeOf(context).languageCode == "ml" ? "മലയാളം (Malayalam)" : "English",
                    style: AppTypography.heading(colors.text),
                  ),
                  trailing: OutlinedButton(
                    style: OutlinedButton.styleFrom(minimumSize: const Size(100, 40)),
                    onPressed: onToggleLanguage,
                    child: Text(
                      Localizations.localeOf(context).languageCode == "ml" ? "English" : "മലയാളം",
                      style: AppTypography.label(colors.brand),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 28),

              // 3. DEVELOPER COMPONENT GALLERY
              Text("Developer Preview", style: AppTypography.heading(colors.text)),
              const SizedBox(height: 12),
              Card(
                child: ListTile(
                  leading: Icon(Icons.widgets_outlined, color: colors.brand),
                  title: Text("Design Component Gallery", style: AppTypography.heading(colors.text)),
                  subtitle: Text("View all components, themes, scales & Malayalam", style: AppTypography.body(colors.textSecondary)),
                  trailing: const Icon(Icons.chevron_right_rounded),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const ComponentGalleryScreen()),
                    );
                  },
                ),
              ),

              const SizedBox(height: 36),

              // 4. SWITCH ROLE / LOGOUT
              SizedBox(
                height: 56,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: colors.statusDanger,
                    side: BorderSide(color: colors.statusDanger.withValues(alpha: 0.5), width: 1.5),
                    shape: RoundedRectangleBorder(borderRadius: AppSpacing.buttonBorderRadius),
                  ),
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (_) => RoleSelectScreen(onToggleLanguage: onToggleLanguage),
                      ),
                      (route) => false,
                    );
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.logout_rounded, size: 22),
                      const SizedBox(width: 8),
                      Text(l10n.btnLogout, style: AppTypography.heading(colors.statusDanger)),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildThemeTile(
    BuildContext context, {
    required String label,
    required ThemeMode mode,
    required bool isSelected,
    required Color bgPreview,
  }) {
    final colors = context.colors;

    return InkWell(
      onTap: () => ThemeController.instance.setThemeMode(mode),
      borderRadius: AppSpacing.cardBorderRadius,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: AppSpacing.cardBorderRadius,
          border: Border.all(
            color: isSelected ? colors.brand : colors.border,
            width: isSelected ? 2.5 : 1.0,
          ),
        ),
        child: Column(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: bgPreview,
                shape: BoxShape.circle,
                border: Border.all(color: colors.border, width: 1.5),
              ),
              child: isSelected
                  ? Icon(Icons.check, size: 18, color: mode == ThemeMode.dark ? Colors.white : colors.brand)
                  : null,
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: AppTypography.label(
                isSelected ? colors.brand : colors.text,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
