import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "../../core/design/tokens/app_colors.dart";
import "../../core/design/tokens/app_typography.dart";
import "../settings/settings_screen.dart";
import "admin_login_screen.dart";
import "driver_auth_screen.dart";

class RoleSelectScreen extends StatelessWidget {
  final VoidCallback? onToggleLanguage;

  const RoleSelectScreen({super.key, this.onToggleLanguage});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final isMl = Localizations.localeOf(context).languageCode == "ml";

    return Scaffold(
      backgroundColor: colors.bg,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          "SmartFleet",
          style: TextStyle(
            color: colors.text,
            fontSize: 15,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.4,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              HapticFeedback.lightImpact();
              if (onToggleLanguage != null) {
                onToggleLanguage!();
              }
            },
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              minimumSize: const Size(40, 32),
            ),
            child: Text(
              isMl ? "English" : "മലയാളം",
              style: TextStyle(
                color: colors.textSecondary,
                fontSize: 12.5,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.tune_rounded, size: 18, color: colors.textSecondary),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => SettingsScreen(onToggleLanguage: onToggleLanguage),
                ),
              );
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 20),

                  Text(
                    "Are you an Admin or a Driver?",
                    textAlign: TextAlign.center,
                    style: AppTypography.title(colors.text, fontSize: 24).copyWith(
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.6,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    "Select your workspace to continue.",
                    textAlign: TextAlign.center,
                    style: AppTypography.body(colors.textSecondary, fontSize: 14),
                  ),

                  const SizedBox(height: 36),

                  // 1. FLEET ADMINISTRATOR CARD
                  _buildRoleCard(
                    context,
                    title: "Fleet Administrator",
                    description: "Operations dispatch and system configuration",
                    onTap: () {
                      HapticFeedback.lightImpact();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => AdminLoginScreen(onToggleLanguage: onToggleLanguage),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 14),

                  // 2. FLEET DRIVER CARD
                  _buildRoleCard(
                    context,
                    title: "Fleet Driver",
                    description: "Active trip cockpit and delivery clearance",
                    onTap: () {
                      HapticFeedback.lightImpact();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => DriverAuthScreen(onToggleLanguage: onToggleLanguage),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 48),

                  Center(
                    child: Text(
                      "SmartFleet Operations",
                      style: AppTypography.mono(
                        colors.textSecondary.withValues(alpha: 0.5),
                        fontSize: 11,
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),
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
    required String title,
    required String description,
    required VoidCallback onTap,
  }) {
    final colors = context.colors;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        splashColor: colors.brand.withValues(alpha: 0.08),
        highlightColor: colors.brand.withValues(alpha: 0.04),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
          decoration: BoxDecoration(
            color: colors.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: colors.border, width: 1.0),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: colors.text,
                        letterSpacing: -0.3,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: TextStyle(
                        fontSize: 13,
                        color: colors.textSecondary,
                        height: 1.35,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Icon(
                Icons.arrow_forward_rounded,
                size: 18,
                color: colors.textSecondary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
