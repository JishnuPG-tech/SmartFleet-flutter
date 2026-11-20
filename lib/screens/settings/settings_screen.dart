import "../../core/data/api_client.dart";
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
      backgroundColor: colors.bg,
      appBar: AppBar(
        title: Text(l10n.settingsTitle, style: AppTypography.title(colors.text, fontSize: 22)),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(color: colors.border, height: 1.0),
        ),
      ),
      body: AnimatedBuilder(
        animation: ThemeController.instance,
        builder: (context, _) {
          final currentMode = ThemeController.instance.mode;

          return ListView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
            children: [
              // 1. THEME MODE PICKER (Midnight Black & Pure White)
              Text("Theme", style: AppTypography.section(colors.text, fontSize: 16)),
              const SizedBox(height: 10),
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
                      label: "Pure White",
                      mode: ThemeMode.light,
                      isSelected: currentMode == ThemeMode.light,
                      bgPreview: const Color(0xFFFFFFFF),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildThemeTile(
                      context,
                      label: "Midnight",
                      mode: ThemeMode.dark,
                      isSelected: currentMode == ThemeMode.dark,
                      bgPreview: const Color(0xFF080A08),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // 1B. ACCENT PALETTE PICKER (Lime Green, Sky Blue, Claude Orange)
              Text("Accent Palette", style: AppTypography.section(colors.text, fontSize: 16)),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: _buildPaletteTile(
                      context,
                      label: "Lime Green",
                      palette: AppAccentPalette.limeGreen,
                      isSelected: ThemeController.instance.palette == AppAccentPalette.limeGreen,
                      colorPreview: const Color(0xFFC6FF00),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildPaletteTile(
                      context,
                      label: "Sky Blue",
                      palette: AppAccentPalette.skyBlue,
                      isSelected: ThemeController.instance.palette == AppAccentPalette.skyBlue,
                      colorPreview: const Color(0xFF38BDF8),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildPaletteTile(
                      context,
                      label: "Claude Orange",
                      palette: AppAccentPalette.claudeOrange,
                      isSelected: ThemeController.instance.palette == AppAccentPalette.claudeOrange,
                      colorPreview: const Color(0xFFD97757),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // 2. LANGUAGE SWITCH
              Text(l10n.selectLanguage, style: AppTypography.section(colors.text, fontSize: 16)),
              const SizedBox(height: 10),
              Container(
                decoration: BoxDecoration(
                  color: colors.surface,
                  borderRadius: AppSpacing.cardBorderRadius,
                  border: Border.all(color: colors.border, width: 1.0),
                ),
                child: ListTile(
                  leading: Icon(Icons.language_rounded, color: colors.brand, size: 22),
                  title: Text(
                    Localizations.localeOf(context).languageCode == "ml" ? "മലയാളം (Malayalam)" : "English",
                    style: AppTypography.section(colors.text, fontSize: 15),
                  ),
                  trailing: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size(90, 36),
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                    ),
                    onPressed: onToggleLanguage,
                    child: Text(
                      Localizations.localeOf(context).languageCode == "ml" ? "English" : "മലയാളം",
                      style: AppTypography.supporting(colors.brand, fontSize: 13).copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // 3. DEVELOPER COMPONENT GALLERY
              Text("Developer tools", style: AppTypography.section(colors.text, fontSize: 16)),
              const SizedBox(height: 10),
              Container(
                decoration: BoxDecoration(
                  color: colors.surface,
                  borderRadius: AppSpacing.cardBorderRadius,
                  border: Border.all(color: colors.border, width: 1.0),
                ),
                child: ListTile(
                  leading: Icon(Icons.widgets_outlined, color: colors.brand, size: 22),
                  title: Text("Component Gallery", style: AppTypography.section(colors.text, fontSize: 15)),
                  subtitle: Text("Inspect all tokens, components & contrast", style: AppTypography.supporting(colors.textSecondary, fontSize: 12)),
                  trailing: const Icon(Icons.chevron_right_rounded, size: 20),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const ComponentGalleryScreen()),
                    );
                  },
                ),
              ),

              const SizedBox(height: 32),

              // 4. SWITCH ROLE / LOGOUT
              SizedBox(
                height: 48,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: colors.statusDanger,
                    side: BorderSide(color: colors.statusDanger.withValues(alpha: 0.4), width: 1.0),
                    shape: RoundedRectangleBorder(borderRadius: AppSpacing.buttonBorderRadius),
                  ),
                  onPressed: () {
                    ApiClient.instance.logout();
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
                      const Icon(Icons.logout_rounded, size: 20),
                      const SizedBox(width: 8),
                      Text(l10n.btnLogout, style: AppTypography.button(colors.statusDanger, fontSize: 15)),
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
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: AppSpacing.cardBorderRadius,
          border: Border.all(
            color: isSelected ? colors.brand : colors.border,
            width: isSelected ? 2.0 : 1.0,
          ),
        ),
        child: Column(
          children: [
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: bgPreview,
                shape: BoxShape.circle,
                border: Border.all(color: colors.border, width: 1.0),
              ),
              child: isSelected
                  ? Icon(Icons.check, size: 16, color: mode == ThemeMode.dark ? colors.brand : const Color(0xFF080A08))
                  : null,
            ),
            const SizedBox(height: 6),
            Text(
              label,
              style: AppTypography.supporting(
                isSelected ? colors.brand : colors.text,
                fontSize: 12,
              ).copyWith(
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaletteTile(
    BuildContext context, {
    required String label,
    required AppAccentPalette palette,
    required bool isSelected,
    required Color colorPreview,
  }) {
    final colors = context.colors;

    return InkWell(
      onTap: () => ThemeController.instance.setPalette(palette),
      borderRadius: AppSpacing.cardBorderRadius,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: AppSpacing.cardBorderRadius,
          border: Border.all(
            color: isSelected ? colorPreview : colors.border,
            width: isSelected ? 2.0 : 1.0,
          ),
        ),
        child: Column(
          children: [
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: colorPreview,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white24, width: 1.0),
              ),
              child: isSelected
                  ? const Icon(Icons.check, size: 16, color: Color(0xFF08090D))
                  : null,
            ),
            const SizedBox(height: 6),
            Text(
              label,
              textAlign: TextAlign.center,
              style: AppTypography.supporting(
                isSelected ? colorPreview : colors.text,
                fontSize: 11,
              ).copyWith(
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
