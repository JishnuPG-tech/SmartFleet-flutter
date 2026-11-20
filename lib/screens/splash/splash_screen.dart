import "dart:async";
import "package:flutter/material.dart";
import "../../core/design/tokens/app_colors.dart";
import "../../core/design/tokens/app_typography.dart";
import "../../core/design/theme/theme_controller.dart";
import "../../core/design/components/smartfleet_logo.dart";
import "../onboarding/onboarding_screen.dart";
import "../auth/role_select_screen.dart";

class SplashScreen extends StatefulWidget {
  final VoidCallback? onToggleLanguage;

  const SplashScreen({super.key, this.onToggleLanguage});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOut,
    );

    _animController.forward();

    Timer(const Duration(milliseconds: 1400), () {
      if (!mounted) return;
      final hasSeen = ThemeController.instance.hasCompletedOnboarding;

      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (_, animation, secondaryAnimation) => hasSeen
              ? RoleSelectScreen(onToggleLanguage: widget.onToggleLanguage)
              : OnboardingScreen(onToggleLanguage: widget.onToggleLanguage),
          transitionsBuilder: (_, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
          transitionDuration: const Duration(milliseconds: 250),
        ),
      );
    });
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Scaffold(
      backgroundColor: colors.bg,
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(flex: 3),

                const SmartFleetLogo(size: 64),

                const SizedBox(height: 20),

                Text(
                  "SmartFleet",
                  style: AppTypography.title(colors.text, fontSize: 26).copyWith(
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.8,
                  ),
                ),

                const SizedBox(height: 6),

                Text(
                  "Fleet Logistics Platform",
                  style: AppTypography.body(colors.textSecondary, fontSize: 13.5),
                ),

                const Spacer(flex: 3),

                Text(
                  "v2.8.1",
                  style: AppTypography.mono(colors.textSecondary.withValues(alpha: 0.6), fontSize: 11),
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
