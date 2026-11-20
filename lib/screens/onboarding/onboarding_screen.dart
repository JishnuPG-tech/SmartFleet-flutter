import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "../../core/design/tokens/app_colors.dart";
import "../../core/design/tokens/app_typography.dart";
import "../../core/design/theme/theme_controller.dart";
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

  final List<_SlideData> _slides = const [
    _SlideData(
      step: "01 / 03",
      category: "OPERATIONS",
      title: "Continuous Fleet Tracking",
      description:
          "Real-time route visibility across Kerala corridors. Reliable dead-reckoning maintains tracking continuity through tunnels and coverage gaps.",
      specKey1: "Corridor Coverage",
      specVal1: "NH-66 • NH-544 • MC Road",
      specKey2: "Tracking Mode",
      specVal2: "Sub-meter Dead Reckoning",
    ),
    _SlideData(
      step: "02 / 03",
      category: "SYNCHRONIZATION",
      title: "Dynamic Policy Updates",
      description:
          "Operational manifests, cargo instructions, and route notices sync dynamically from the central portal, keeping all devices aligned without reinstalls.",
      specKey1: "Configuration Source",
      specVal1: "Central Management Portal",
      specKey2: "Update Mechanism",
      specVal2: "Zero-Downtime Cache Sync",
    ),
    _SlideData(
      step: "03 / 03",
      category: "VERIFICATION",
      title: "Secure Delivery Clearance",
      description:
          "Two-point proof of delivery combines consignee authentication with location confirmation to ensure authentic, dispute-free cargo transfers.",
      specKey1: "Authentication",
      specVal1: "Consignee OTP Verification",
      specKey2: "Geofence Check",
      specVal2: "Terminal Arrival Confirmation",
    ),
  ];

  void _finishOnboarding() {
    HapticFeedback.lightImpact();
    ThemeController.instance.completeOnboarding();
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (_, animation, secondaryAnimation) =>
            RoleSelectScreen(onToggleLanguage: widget.onToggleLanguage),
        transitionsBuilder: (_, animation, secondaryAnimation, child) =>
            FadeTransition(opacity: animation, child: child),
        transitionDuration: const Duration(milliseconds: 250),
      ),
    );
  }

  void _nextPage() {
    HapticFeedback.lightImpact();
    if (_currentPage < _slides.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 280),
        curve: Curves.easeInOut,
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
            onPressed: _finishOnboarding,
            child: Text(
              "Skip",
              style: TextStyle(
                color: colors.textSecondary,
                fontWeight: FontWeight.w500,
                fontSize: 13.5,
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
                  return SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 28.0, vertical: 12.0),
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 480),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 12),

                          // Step Counter
                          Text(
                            slide.step,
                            style: AppTypography.mono(colors.textSecondary, fontSize: 12.5),
                          ),

                          const SizedBox(height: 14),

                          // Category
                          Text(
                            slide.category,
                            style: TextStyle(
                              color: colors.brand,
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 1.2,
                            ),
                          ),

                          const SizedBox(height: 12),

                          // Title
                          Text(
                            slide.title,
                            style: AppTypography.title(colors.text, fontSize: 26).copyWith(
                              fontWeight: FontWeight.w700,
                              letterSpacing: -0.8,
                              height: 1.2,
                            ),
                          ),

                          const SizedBox(height: 14),

                          // Description
                          Text(
                            slide.description,
                            style: AppTypography.body(colors.textSecondary, fontSize: 14.5).copyWith(
                              height: 1.5,
                            ),
                          ),

                          const SizedBox(height: 32),

                          // Minimalist Data Specification Container
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: colors.surface,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: colors.border, width: 1.0),
                            ),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      slide.specKey1,
                                      style: TextStyle(color: colors.textSecondary, fontSize: 13),
                                    ),
                                    Text(
                                      slide.specVal1,
                                      style: TextStyle(
                                        color: colors.text,
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                                Divider(height: 20, thickness: 1, color: colors.border),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      slide.specKey2,
                                      style: TextStyle(color: colors.textSecondary, fontSize: 13),
                                    ),
                                    Text(
                                      slide.specVal2,
                                      style: TextStyle(
                                        color: colors.text,
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            // Bottom Navigation Strip
            Padding(
              padding: const EdgeInsets.fromLTRB(28, 12, 28, 24),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 480),
                child: Column(
                  children: [
                    // Clean, minimal progress bar
                    ClipRRect(
                      borderRadius: BorderRadius.circular(2),
                      child: LinearProgressIndicator(
                        value: (_currentPage + 1) / _slides.length,
                        minHeight: 2.5,
                        backgroundColor: colors.border,
                        valueColor: AlwaysStoppedAnimation<Color>(colors.brand),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Primary Action Button
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: colors.brand,
                          foregroundColor: colors.onBrand,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: _nextPage,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              _currentPage == _slides.length - 1 ? "Get Started" : "Continue",
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Icon(Icons.arrow_forward_rounded, size: 18),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SlideData {
  final String step;
  final String category;
  final String title;
  final String description;
  final String specKey1;
  final String specVal1;
  final String specKey2;
  final String specVal2;

  const _SlideData({
    required this.step,
    required this.category,
    required this.title,
    required this.description,
    required this.specKey1,
    required this.specVal1,
    required this.specKey2,
    required this.specVal2,
  });
}
