import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "../../core/design/tokens/app_colors.dart";
import "../../core/design/tokens/app_typography.dart";
import "../../core/design/theme/theme_controller.dart";
import "../../core/services/update_service.dart";
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
          final currentCanvas = ThemeController.instance.canvasTheme;
          final currentPalette = ThemeController.instance.palette;

          return ListView(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 40),
            children: [
              // 0. THREE STARTING PRODUCTION THEMES
              Text("Production Enterprise Themes", style: AppTypography.section(colors.text, fontSize: 16)),
              const SizedBox(height: 6),
              Text(
                "High-contrast WCAG AAA/AA accessible themes calibrated for cab ergonomics and daylight legibility.",
                style: AppTypography.caption(colors.textSecondary),
              ),
              const SizedBox(height: 12),
              _buildFleetThemeTile(
                context,
                title: "Theme A: Sage & Lemon",
                subtitle: "Sage green canvas · Charcoal text · High-vis Lemon accent",
                palette: FleetPalette.sageLemon,
                isSelected: ThemeController.instance.fleetPalette == FleetPalette.sageLemon,
                accentColor: const Color(0xFFE6FB2B),
                canvasColor: ThemeController.instance.isDarkMode ? const Color(0xFF0A0F0C) : const Color(0xFFEFF4F0),
              ),
              const SizedBox(height: 10),
              _buildFleetThemeTile(
                context,
                title: "Theme B: Blue & Tangerine",
                subtitle: "Soft blue canvas · Midnight navy text · High-vis Tangerine accent",
                palette: FleetPalette.blueTangerine,
                isSelected: ThemeController.instance.fleetPalette == FleetPalette.blueTangerine,
                accentColor: const Color(0xFFFF7824),
                canvasColor: ThemeController.instance.isDarkMode ? const Color(0xFF060B12) : const Color(0xFFEDF3F9),
              ),
              const SizedBox(height: 10),
              _buildFleetThemeTile(
                context,
                title: "Theme C: Off-white & Cherry",
                subtitle: "Off-white canvas · Espresso brown text · High-vis Cherry red accent",
                palette: FleetPalette.offWhiteCherry,
                isSelected: ThemeController.instance.fleetPalette == FleetPalette.offWhiteCherry,
                accentColor: const Color(0xFFFF3B53),
                canvasColor: ThemeController.instance.isDarkMode ? const Color(0xFF0D0B0A) : const Color(0xFFF8F7F5),
              ),
              const SizedBox(height: 28),

              // 1. CANVAS BACKGROUND SELECTOR
              Text("Canvas Background", style: AppTypography.section(colors.text, fontSize: 16)),
              const SizedBox(height: 6),
              Text(
                "Sets the application foundation canvas. Elements and buttons maintain chosen accent.",
                style: AppTypography.caption(colors.textSecondary),
              ),
              const SizedBox(height: 12),
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                childAspectRatio: 2.3,
                children: [
                  _buildCanvasTile(
                    context,
                    label: "Pure White",
                    code: "#FFFFFF",
                    canvas: AppCanvasTheme.pureWhite,
                    isSelected: currentCanvas == AppCanvasTheme.pureWhite,
                    bgPreview: const Color(0xFFFFFFFF),
                    borderPreview: const Color(0xFFD4D4D8),
                    textColor: const Color(0xFF09090B),
                  ),
                  _buildCanvasTile(
                    context,
                    label: "Midnight Black",
                    code: "#000000",
                    canvas: AppCanvasTheme.midnightBlack,
                    isSelected: currentCanvas == AppCanvasTheme.midnightBlack,
                    bgPreview: const Color(0xFF000000),
                    borderPreview: const Color(0xFF27272A),
                    textColor: const Color(0xFFFFFFFF),
                  ),
                  _buildCanvasTile(
                    context,
                    label: "Claude Warm",
                    code: "#181715",
                    canvas: AppCanvasTheme.claudeWarm,
                    isSelected: currentCanvas == AppCanvasTheme.claudeWarm,
                    bgPreview: const Color(0xFF181715),
                    borderPreview: const Color(0xFF3D3832),
                    textColor: const Color(0xFFF4EDE2),
                  ),
                  _buildCanvasTile(
                    context,
                    label: "Claude Deep",
                    code: "#141413",
                    canvas: AppCanvasTheme.claudeDeep,
                    isSelected: currentCanvas == AppCanvasTheme.claudeDeep,
                    bgPreview: const Color(0xFF141413),
                    borderPreview: const Color(0xFF33312E),
                    textColor: const Color(0xFFF4EDE2),
                  ),
                ],
              ),

              const SizedBox(height: 28),

              // 2. ACCENT PALETTE SELECTOR
              Text("Accent Highlight Color", style: AppTypography.section(colors.text, fontSize: 16)),
              const SizedBox(height: 6),
              Text(
                "Applies to active buttons, indicators, route highlights, and focus borders.",
                style: AppTypography.caption(colors.textSecondary),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _buildPaletteTile(
                      context,
                      label: "Lime Green",
                      code: "#C6FF00",
                      palette: AppAccentPalette.limeGreen,
                      isSelected: currentPalette == AppAccentPalette.limeGreen,
                      colorPreview: const Color(0xFFC6FF00),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildPaletteTile(
                      context,
                      label: "Sky Blue",
                      code: "#38BDF8",
                      palette: AppAccentPalette.skyBlue,
                      isSelected: currentPalette == AppAccentPalette.skyBlue,
                      colorPreview: const Color(0xFF38BDF8),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildPaletteTile(
                      context,
                      label: "Terracotta",
                      code: "#D97757",
                      palette: AppAccentPalette.claudeOrange,
                      isSelected: currentPalette == AppAccentPalette.claudeOrange,
                      colorPreview: const Color(0xFFD97757),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 28),

              // 3. LIVE COMPONENT PREVIEW SWATCH
              Text("Live Component Swatch", style: AppTypography.section(colors.text, fontSize: 16)),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: colors.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: colors.border, width: 1.0),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Active Theme Configuration", style: AppTypography.body(colors.text, fontSize: 14)),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: colors.brand.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(color: colors.brand.withValues(alpha: 0.4), width: 1.0),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 6,
                                height: 6,
                                decoration: BoxDecoration(
                                  color: colors.brand,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                "LIVE",
                                style: AppTypography.mono(colors.brand, fontSize: 11).copyWith(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    SizedBox(
                      height: 44,
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: colors.brand,
                          foregroundColor: colors.onBrand,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          elevation: 0,
                        ),
                        onPressed: () {},
                        child: Text(
                          "Primary Interactive Action",
                          style: TextStyle(color: colors.onBrand, fontWeight: FontWeight.w600, fontSize: 14),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 28),

              // 4. LANGUAGE PREFERENCES
              Text("Language / ഭാഷ", style: AppTypography.section(colors.text, fontSize: 16)),
              const SizedBox(height: 10),
              Container(
                decoration: BoxDecoration(
                  color: colors.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: colors.border, width: 1.0),
                ),
                child: ListTile(
                  title: Text(l10n.selectLanguage, style: AppTypography.body(colors.text)),
                  subtitle: Text(
                    Localizations.localeOf(context).languageCode == "ml" ? "മലയാളം (സജീവമാണ്)" : "English (Active)",
                    style: AppTypography.caption(colors.textSecondary),
                  ),
                  trailing: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: colors.border),
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                      minimumSize: const Size(80, 36),
                    ),
                    onPressed: () {
                      HapticFeedback.lightImpact();
                      onToggleLanguage?.call();
                    },
                    child: Text(
                      Localizations.localeOf(context).languageCode == "ml" ? "English" : "മലയാളം",
                      style: TextStyle(color: colors.text, fontSize: 13, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 28),

              // 5. SYSTEM & OTA UPDATES
              Text("System & Maintenance", style: AppTypography.section(colors.text, fontSize: 16)),
              const SizedBox(height: 10),
              Container(
                decoration: BoxDecoration(
                  color: colors.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: colors.border, width: 1.0),
                ),
                child: Column(
                  children: [
                    ListTile(
                      leading: Icon(Icons.system_update_alt_rounded, color: colors.brand, size: 22),
                      title: Text("Check for App Updates", style: AppTypography.body(colors.text)),
                      subtitle: Text("Over-the-Air APK delivery channel", style: AppTypography.caption(colors.textSecondary)),
                      onTap: () {
                        HapticFeedback.lightImpact();
                        UpdateService.checkForUpdates(context, showToastIfLatest: true);
                      },
                    ),
                    Divider(height: 1, thickness: 1, color: colors.border),
                    ListTile(
                      leading: Icon(Icons.layers_outlined, color: colors.textSecondary, size: 22),
                      title: Text("Component Gallery", style: AppTypography.body(colors.text)),
                      subtitle: Text("Design system & typography preview", style: AppTypography.caption(colors.textSecondary)),
                      trailing: Icon(Icons.chevron_right_rounded, color: colors.textSecondary),
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (_) => const ComponentGalleryScreen()));
                      },
                    ),
                    Divider(height: 1, thickness: 1, color: colors.border),
                    ListTile(
                      leading: Icon(Icons.swap_horiz_rounded, color: colors.textSecondary, size: 22),
                      title: Text("Switch Workspace Role", style: AppTypography.body(colors.text)),
                      subtitle: Text("Return to role selection gateway", style: AppTypography.caption(colors.textSecondary)),
                      trailing: Icon(Icons.chevron_right_rounded, color: colors.textSecondary),
                      onTap: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (_) => RoleSelectScreen(onToggleLanguage: onToggleLanguage)),
                          (route) => false,
                        );
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // 6. BUILD INFO FOOTER
              Center(
                child: Column(
                  children: [
                    Text("SmartFleet Enterprise Logistics", style: AppTypography.caption(colors.textSecondary)),
                    const SizedBox(height: 4),
                    Text(
                      "Version 2.8.0 • Build 11 • Kerala Corridor Edition",
                      style: AppTypography.mono(colors.textSecondary, fontSize: 11),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildCanvasTile(
    BuildContext context, {
    required String label,
    required String code,
    required AppCanvasTheme canvas,
    required bool isSelected,
    required Color bgPreview,
    required Color borderPreview,
    required Color textColor,
  }) {
    final colors = context.colors;

    return GestureDetector(
      onTap: () {
        HapticFeedback.selectionClick();
        ThemeController.instance.setCanvasTheme(canvas);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: bgPreview,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? colors.brand : borderPreview,
            width: isSelected ? 2.0 : 1.0,
          ),
          boxShadow: isSelected
              ? [BoxShadow(color: colors.brand.withValues(alpha: 0.25), blurRadius: 8, spreadRadius: 1)]
              : null,
        ),
        child: Row(
          children: [
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color: bgPreview,
                shape: BoxShape.circle,
                border: Border.all(color: borderPreview, width: 1.5),
              ),
              child: isSelected
                  ? Icon(Icons.check, size: 14, color: isSelected && bgPreview == const Color(0xFFFFFFFF) ? Colors.black : colors.brand)
                  : null,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      color: textColor,
                      fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                      fontSize: 13,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    code,
                    style: TextStyle(
                      color: textColor.withValues(alpha: 0.65),
                      fontSize: 10,
                      fontFamily: "monospace",
                    ),
                  ),
                ],
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
    required String code,
    required AppAccentPalette palette,
    required bool isSelected,
    required Color colorPreview,
  }) {
    final colors = context.colors;

    return GestureDetector(
      onTap: () {
        HapticFeedback.selectionClick();
        ThemeController.instance.setPalette(palette);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? colorPreview : colors.border,
            width: isSelected ? 2.0 : 1.0,
          ),
          boxShadow: isSelected
              ? [BoxShadow(color: colorPreview.withValues(alpha: 0.25), blurRadius: 8, spreadRadius: 1)]
              : null,
        ),
        child: Column(
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: colorPreview,
                shape: BoxShape.circle,
              ),
              child: isSelected
                  ? Icon(
                      Icons.check,
                      size: 16,
                      color: palette == AppAccentPalette.claudeOrange ? Colors.white : Colors.black,
                    )
                  : null,
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                color: colors.text,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                fontSize: 12,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
            ),
            Text(
              code,
              style: TextStyle(
                color: colors.textSecondary,
                fontSize: 9.5,
                fontFamily: "monospace",
              ),
            ),
          ],
        ),
      ),
    );
  }
}


  Widget _buildFleetThemeTile(
    BuildContext context, {
    required String title,
    required String subtitle,
    required FleetPalette palette,
    required bool isSelected,
    required Color accentColor,
    required Color canvasColor,
  }) {
    final colors = context.colors;
    return GestureDetector(
      onTap: () {
        HapticFeedback.selectionClick();
        ThemeController.instance.setFleetPalette(palette);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? colors.brand : colors.border,
            width: isSelected ? 2.0 : 1.0,
          ),
          boxShadow: isSelected
              ? [BoxShadow(color: colors.brand.withValues(alpha: 0.2), blurRadius: 8, spreadRadius: 1)]
              : null,
        ),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: canvasColor,
                shape: BoxShape.circle,
                border: Border.all(color: accentColor, width: 2.5),
              ),
              child: isSelected ? Icon(Icons.check, size: 20, color: accentColor) : null,
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: AppTypography.label(colors.text, fontSize: 15)),
                  const SizedBox(height: 2),
                  Text(subtitle, style: AppTypography.caption(colors.textSecondary)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
