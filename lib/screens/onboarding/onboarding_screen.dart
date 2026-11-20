import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "../../core/design/tokens/app_colors.dart";
import "../../core/design/tokens/app_typography.dart";
import "../../core/design/theme/theme_controller.dart";
import "../../core/design/components/buttons.dart";
import "../auth/role_select_screen.dart";

class OnboardingScreen extends StatefulWidget {
  final VoidCallback? onToggleLanguage;

  const OnboardingScreen({super.key, this.onToggleLanguage});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<_OnboardingItem> _slides = const [
    _OnboardingItem(
      icon: Icons.radar_rounded,
      tag: "CONTINUOUS TELEMETRY",
      title: "Real-Time GPS Fleet Radar",
      description:
          "High-precision corridor tracking across NH-66, NH-544, and MC Road. Automatic dead-reckoning keeps vehicles tracked even in tunnel and ghat deadzones.",
    ),
    _OnboardingItem(
      icon: Icons.sync_rounded,
      tag: "ZERO-REDEPLOY CMS",
      title: "Instant Live Sync",
      description:
          "Trip presets, cargo descriptions, and fleet operational policies update dynamically from the enterprise web portal. Reflected instantly in-app without APK redeployments.",
    ),
    _OnboardingItem(
      icon: Icons.verified_user_rounded,
      tag: "TAMPER-PROOF POD",
      title: "Cryptographic Delivery Handshake",
      description:
          "Guaranteed proof of delivery. Consignee secret OTP combined with driver location geofencing eliminates cargo discrepancies and disputes.",
    ),
  ];

  void _finishOnboarding() {
    HapticFeedback.mediumImpact();
    ThemeController.instance.completeOnboarding();
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (_, animation, secondaryAnimation) => RoleSelectScreen(onToggleLanguage: widget.onToggleLanguage),
        transitionsBuilder: (_, animation, secondaryAnimation, child) => FadeTransition(opacity: animation, child: child),
        transitionDuration: const Duration(milliseconds: 300),
      ),
    );
  }

  void _nextPage() {
    HapticFeedback.lightImpact();
    if (_currentPage < _slides.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 320),
        curve: Curves.easeOutCubic,
      );
    } else {
      _finishOnboarding();
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Scaffold(
      backgroundColor: colors.bg,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          TextButton(
            onPressed: _finishOnboarding,
            child: Text(
              "Skip",
              style: TextStyle(
                color: colors.textSecondary,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _slides.length,
                onPageChanged: (index) {
                  setState(() => _currentPage = index);
                },
                itemBuilder: (context, index) {
                  final slide = _slides[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 28.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Icon in styled Shadcn Card
                        Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            color: colors.surface,
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(
                              color: colors.brand.withValues(alpha: 0.35),
                              width: 1.5,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: colors.brand.withValues(alpha: 0.15),
                                blurRadius: 20,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          child: Center(
                            child: Icon(
                              slide.icon,
                              size: 48,
                              color: colors.brand,
                            ),
                          ),
                        ),

                        const SizedBox(height: 36),

                        // Section Tag
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: colors.brand.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(color: colors.brand.withValues(alpha: 0.3), width: 1.0),
                          ),
                          child: Text(
                            slide.tag,
                            style: AppTypography.mono(colors.brand, fontSize: 11).copyWith(
                              letterSpacing: 1.4,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),

                        const SizedBox(height: 16),

                        // Slide Title
                        Text(
                          slide.title,
                          textAlign: TextAlign.center,
                          style: AppTypography.title(colors.text, fontSize: 24).copyWith(
                            fontWeight: FontWeight.w800,
                          ),
                        ),

                        const SizedBox(height: 14),

                        // Slide Description
                        Text(
                          slide.description,
                          textAlign: TextAlign.center,
                          style: AppTypography.body(colors.textSecondary, fontSize: 14.5).copyWith(
                            height: 1.45,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            // Bottom Navigation & Indicators
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 28),
              child: Column(
                children: [
                  // Smooth Indicator Dots
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      _slides.length,
                      (index) => AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: _currentPage == index ? 24 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: _currentPage == index ? colors.brand : colors.border,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Next / Get Started Button
                  PrimaryButton(
                    label: _currentPage == _slides.length - 1 ? "Get Started" : "Continue",
                    onPressed: _nextPage,
                    icon: _currentPage == _slides.length - 1 ? Icons.arrow_forward_rounded : null,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OnboardingItem {
  final IconData icon;
  final String tag;
  final String title;
  final String description;

  const _OnboardingItem({
    required this.icon,
    required this.tag,
    required this.title,
    required this.description,
  });
}
