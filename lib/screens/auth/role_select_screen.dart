import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "../../core/design/tokens/app_colors.dart";
import "../../core/design/tokens/app_typography.dart";
import "../../core/design/components/smartfleet_logo.dart";
import "../../l10n/app_localizations.dart";
import "../settings/settings_screen.dart";
import "admin_login_screen.dart";
import "driver_auth_screen.dart";

class RoleSelectScreen extends StatelessWidget {
  final VoidCallback? onToggleLanguage;

  const RoleSelectScreen({super.key, this.onToggleLanguage});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = AppLocalizations.of(context);
    final isMl = Localizations.localeOf(context).languageCode == "ml";

    return Scaffold(
      backgroundColor: colors.bg,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          // Language Switcher Chip
          TextButton.icon(
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            ),
            icon: Icon(Icons.language_rounded, size: 18, color: colors.textSecondary),
            label: Text(
              isMl ? "മലയാളം" : "English",
              style: TextStyle(color: colors.textSecondary, fontSize: 13, fontWeight: FontWeight.w600),
            ),
            onPressed: () {
              HapticFeedback.lightImpact();
              onToggleLanguage?.call();
            },
          ),
          // Settings Gear
          IconButton(
            icon: Icon(Icons.settings_outlined, color: colors.textSecondary, size: 22),
            onPressed: () {
              HapticFeedback.lightImpact();
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => SettingsScreen(onToggleLanguage: onToggleLanguage)),
              );
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 440),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Centered Vector Logo
                  const Center(
                    child: SmartFleetLogo(size: 72),
                  ),

                  const SizedBox(height: 24),

                  // Centered Title
                  Text(
                    "Are you an Admin or a Driver?",
                    textAlign: TextAlign.center,
                    style: AppTypography.title(colors.text, fontSize: 24).copyWith(
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.5,
                    ),
                  ),

                  const SizedBox(height: 8),

                  // Centered Subtitle
                  Text(
                    "Select your role to access fleet operations or cockpit telematics.",
                    textAlign: TextAlign.center,
                    style: AppTypography.body(colors.textSecondary, fontSize: 14),
                  ),

                  const SizedBox(height: 36),

                  // 1. FLEET ADMINISTRATOR CARD
                  _buildRoleCard(
                    context,
                    tag: "COMMAND PORTAL",
                    title: "Fleet Administrator",
                    description: "Manage trucks, assign routes, monitor live GPS radar, and configure CMS parameters.",
                    icon: Icons.shield_outlined,
                    onTap: () {
                      HapticFeedback.mediumImpact();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => AdminLoginScreen(onToggleLanguage: onToggleLanguage),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 16),

                  // 2. FLEET PILOT / DRIVER CARD
                  _buildRoleCard(
                    context,
                    tag: "MOBILE COCKPIT",
                    title: "Fleet Pilot / Driver",
                    description: "Access assigned trip manifests, continuous navigation cockpit HUD, and complete POD deliveries.",
                    icon: Icons.local_shipping_outlined,
                    onTap: () {
                      HapticFeedback.mediumImpact();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => DriverAuthScreen(onToggleLanguage: onToggleLanguage),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 36),

                  // Minimal footer
                  Center(
                    child: Text(
                      "Kerala Corridor Fleet Logistics • Encrypted Session",
                      style: AppTypography.mono(colors.textSecondary, fontSize: 10.5),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRoleCard(
    BuildContext context, {
    required String tag,
    required String title,
    required String description,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    final colors = context.colors;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        splashColor: colors.brand.withValues(alpha: 0.1),
        highlightColor: colors.brand.withValues(alpha: 0.05),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: colors.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: colors.border, width: 1.2),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Icon Container
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: colors.bg,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: colors.brand.withValues(alpha: 0.35), width: 1.0),
                ),
                child: Icon(icon, color: colors.brand, size: 24),
              ),

              const SizedBox(width: 16),

              // Title and Description
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2.5),
                      decoration: BoxDecoration(
                        color: colors.brand.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        tag,
                        style: AppTypography.mono(colors.brand, fontSize: 9.5).copyWith(
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.0,
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      title,
                      style: AppTypography.title(colors.text, fontSize: 17).copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: AppTypography.body(colors.textSecondary, fontSize: 12.5).copyWith(
                        height: 1.35,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 8),

              // Arrow
              Padding(
                padding: const EdgeInsets.only(top: 14.0),
                child: Icon(Icons.arrow_forward_ios_rounded, color: colors.textSecondary, size: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
