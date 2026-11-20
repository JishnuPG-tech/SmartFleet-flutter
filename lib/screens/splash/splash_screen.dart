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
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _animController,
      curve: const Interval(0.0, 0.7, curve: Curves.easeOut),
    );

    _scaleAnimation = Tween<double>(begin: 0.88, end: 1.0).animate(
      CurvedAnimation(
        parent: _animController,
        curve: const Interval(0.0, 0.8, curve: Curves.easeOutCubic),
      ),
    );

    _animController.forward();

    // After brief splash duration, transition to onboarding or role select
    Timer(const Duration(milliseconds: 1900), () {
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
          transitionDuration: const Duration(milliseconds: 350),
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
        child: AnimatedBuilder(
          animation: _animController,
          builder: (context, child) {
            return FadeTransition(
              opacity: _fadeAnimation,
              child: ScaleTransition(
                scale: _scaleAnimation,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Spacer(flex: 3),

                      // Logo with glowing vector
                      const SmartFleetLogo(size: 96),

                      const SizedBox(height: 24),

                      // Brand Wordmark
                      Text(
                        "SMARTFLEET",
                        style: AppTypography.title(colors.text, fontSize: 26).copyWith(
                          letterSpacing: 3.5,
                          fontWeight: FontWeight.w900,
                        ),
                      ),

                      const SizedBox(height: 6),

                      // Subtitle
                      Text(
                        "ENTERPRISE FLEET TELEMATICS",
                        style: AppTypography.mono(colors.textSecondary, fontSize: 11).copyWith(
                          letterSpacing: 2.2,
                          fontWeight: FontWeight.w600,
                        ),
                      ),

                      const Spacer(flex: 3),

                      // Bottom loader & Version badge
                      SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.0,
                          valueColor: AlwaysStoppedAnimation<Color>(colors.brand),
                        ),
                      ),

                      const SizedBox(height: 18),

                      Text(
                        "v2.8.0 • Build 11",
                        style: AppTypography.mono(colors.textSecondary, fontSize: 11),
                      ),

                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
