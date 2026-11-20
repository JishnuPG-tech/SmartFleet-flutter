import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "../../core/design/tokens/app_colors.dart";
import "../../core/design/tokens/app_typography.dart";
import "../../core/design/components/buttons.dart";
import "../../core/data/api_client.dart";
import "../../core/data/fleet_repository.dart";
import "../../core/data/seed_data.dart";
import "../driver/driver_main_screen.dart";

class DriverAuthScreen extends StatefulWidget {
  final VoidCallback? onToggleLanguage;

  const DriverAuthScreen({super.key, this.onToggleLanguage});

  @override
  State<DriverAuthScreen> createState() => _DriverAuthScreenState();
}

class _DriverAuthScreenState extends State<DriverAuthScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Sign In Controllers
  final _phoneController = TextEditingController(text: "+91 94471 23456");
  final _pinController = TextEditingController(text: "pilot1234");
  bool _obscurePin = true;

  // Registration Controllers
  final _regNameController = TextEditingController();
  final _regPhoneController = TextEditingController();
  final _regPinController = TextEditingController(text: "pilot1234");
  final _regLicenseController = TextEditingController();
  final _regVehicleTypeController = TextEditingController(text: "16-Wheeler Multi-Axle");
  final _regExpController = TextEditingController(text: "5");

  bool _isLoading = false;
  String? _errorMessage;
  String? _successMessage;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _phoneController.dispose();
    _pinController.dispose();
    _regNameController.dispose();
    _regPhoneController.dispose();
    _regPinController.dispose();
    _regLicenseController.dispose();
    _regVehicleTypeController.dispose();
    _regExpController.dispose();
    super.dispose();
  }

  Future<void> _handleDriverLogin() async {
    final phone = _phoneController.text.trim();
    final pin = _pinController.text.trim();

    if (phone.isEmpty || pin.isEmpty) {
      setState(() => _errorMessage = "Please enter both phone number and PIN.");
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final res = await ApiClient.instance.driverLogin(phone: phone, password: pin);

      if (!mounted) return;
      setState(() => _isLoading = false);

      if (res.isSuccess) {
        final driver = res.driver ?? SeedData.drivers.first;
        LocalFleetRepository.instance.addOrUpdateDriver(driver);

        HapticFeedback.mediumImpact();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => DriverMainScreen(
              driver: driver,
              onToggleLanguage: widget.onToggleLanguage,
            ),
          ),
        );
      } else {
        // Fallback for seed demo drivers
        final matchedDriver = SeedData.drivers.firstWhere(
          (d) => d.phone.replaceAll(RegExp(r'[^0-9]'), '').endsWith(phone.replaceAll(RegExp(r'[^0-9]'), '')),
          orElse: () => SeedData.drivers.first,
        );

        if (phone.contains('94471') || phone.contains('98462') || phone.contains('97453')) {
          HapticFeedback.lightImpact();
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => DriverMainScreen(
                driver: matchedDriver,
                onToggleLanguage: widget.onToggleLanguage,
              ),
            ),
          );
        } else {
          setState(() {
            _errorMessage = res.errorMessage ?? "Invalid mobile credentials. Please try again.";
          });
        }
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _errorMessage = "Connection error: $e";
      });
    }
  }

  Future<void> _handleDriverRegister() async {
    final name = _regNameController.text.trim();
    final phone = _regPhoneController.text.trim();
    final license = _regLicenseController.text.trim();

    if (name.isEmpty || phone.isEmpty || license.isEmpty) {
      setState(() => _errorMessage = "Name, phone number, and driving license are required.");
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _successMessage = null;
    });

    try {
      final res = await ApiClient.instance.driverRegister(
        fullName: name,
        phone: phone,
        password: _regPinController.text.trim().isNotEmpty ? _regPinController.text.trim() : "pilot1234",
        licenseNumber: license,
        experienceYears: int.tryParse(_regExpController.text.trim()) ?? 3,
        assignedTruckPlate: _regVehicleTypeController.text.trim().isNotEmpty ? _regVehicleTypeController.text.trim() : null,
      );

      if (!mounted) return;
      setState(() => _isLoading = false);

      if (res.isSuccess) {
        HapticFeedback.mediumImpact();
        setState(() {
          _successMessage = "Registration successful! You may now sign in.";
          _phoneController.text = phone;
        });
        _tabController.animateTo(0);
      } else {
        setState(() {
          _errorMessage = res.errorMessage ?? "Registration failed. Please check inputs.";
        });
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _errorMessage = "Registration error: $e";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Scaffold(
      backgroundColor: colors.bg,
      appBar: AppBar(
        title: Text("Driver Portal", style: AppTypography.title(colors.text, fontSize: 20)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded, color: colors.text),
          onPressed: () => Navigator.pop(context),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(50.0),
          child: Column(
            children: [
              TabBar(
                controller: _tabController,
                indicatorColor: colors.brand,
                indicatorWeight: 2.5,
                labelColor: colors.brand,
                unselectedLabelColor: colors.textSecondary,
                labelStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
                unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
                tabs: const [
                  Tab(text: "Sign In"),
                  Tab(text: "New Pilot Registration"),
                ],
              ),
              Container(color: colors.border, height: 1.0),
            ],
          ),
        ),
      ),
      body: SafeArea(
        child: TabBarView(
          controller: _tabController,
          children: [
            // TAB 1: DRIVER SIGN IN
            Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 420),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Header Badge
                      Center(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: colors.brand.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(color: colors.brand.withValues(alpha: 0.35), width: 1.0),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.local_shipping_rounded, size: 14, color: colors.brand),
                              const SizedBox(width: 6),
                              Text(
                                "MOBILE COCKPIT HUD",
                                style: AppTypography.mono(colors.brand, fontSize: 10.5).copyWith(
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1.2,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      Text(
                        "Fleet Pilot Sign In",
                        textAlign: TextAlign.center,
                        style: AppTypography.title(colors.text, fontSize: 24).copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                      ),

                      const SizedBox(height: 6),

                      Text(
                        "Enter registered driver phone number and authorization PIN.",
                        textAlign: TextAlign.center,
                        style: AppTypography.body(colors.textSecondary, fontSize: 13.5),
                      ),

                      const SizedBox(height: 24),

                      if (_errorMessage != null) ...[
                        _buildBanner(colors, _errorMessage!, isError: true),
                        const SizedBox(height: 16),
                      ],
                      if (_successMessage != null) ...[
                        _buildBanner(colors, _successMessage!, isError: false),
                        const SizedBox(height: 16),
                      ],

                      // Form Card
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: colors.surface,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: colors.border, width: 1.0),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Mobile Number", style: AppTypography.caption(colors.text).copyWith(fontWeight: FontWeight.w600)),
                            const SizedBox(height: 8),
                            TextField(
                              controller: _phoneController,
                              keyboardType: TextInputType.phone,
                              style: TextStyle(color: colors.text, fontSize: 14),
                              decoration: _inputDecoration(colors, "+91 94471 23456", Icons.phone_android_rounded),
                            ),

                            const SizedBox(height: 18),

                            Text("Driver PIN / Password", style: AppTypography.caption(colors.text).copyWith(fontWeight: FontWeight.w600)),
                            const SizedBox(height: 8),
                            TextField(
                              controller: _pinController,
                              obscureText: _obscurePin,
                              style: TextStyle(color: colors.text, fontSize: 14),
                              decoration: _inputDecoration(
                                colors,
                                "••••••••",
                                Icons.pin_rounded,
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _obscurePin ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                                    color: colors.textSecondary,
                                    size: 20,
                                  ),
                                  onPressed: () => setState(() => _obscurePin = !_obscurePin),
                                ),
                              ),
                            ),

                            const SizedBox(height: 24),

                            PrimaryButton(
                              label: "Launch Cockpit HUD",
                              onPressed: _handleDriverLogin,
                              isLoading: _isLoading,
                              icon: Icons.navigation_rounded,
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),

                      Center(
                        child: Text(
                          "Continuous GPS sync activates automatically upon manifest sign-in",
                          style: AppTypography.mono(colors.textSecondary, fontSize: 10.5),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // TAB 2: DRIVER REGISTRATION
            Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 420),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        "Register New Fleet Pilot",
                        textAlign: TextAlign.center,
                        style: AppTypography.title(colors.text, fontSize: 24).copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        "Submit credentials for Parivahan automated verification.",
                        textAlign: TextAlign.center,
                        style: AppTypography.body(colors.textSecondary, fontSize: 13.5),
                      ),
                      const SizedBox(height: 20),

                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: colors.surface,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: colors.border, width: 1.0),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Full Name", style: AppTypography.caption(colors.text).copyWith(fontWeight: FontWeight.w600)),
                            const SizedBox(height: 6),
                            TextField(
                              controller: _regNameController,
                              style: TextStyle(color: colors.text, fontSize: 14),
                              decoration: _inputDecoration(colors, "Anil Kumar", Icons.person_outline_rounded),
                            ),

                            const SizedBox(height: 14),

                            Text("Phone Number", style: AppTypography.caption(colors.text).copyWith(fontWeight: FontWeight.w600)),
                            const SizedBox(height: 6),
                            TextField(
                              controller: _regPhoneController,
                              keyboardType: TextInputType.phone,
                              style: TextStyle(color: colors.text, fontSize: 14),
                              decoration: _inputDecoration(colors, "+91 98462 78901", Icons.phone_android_rounded),
                            ),

                            const SizedBox(height: 14),

                            Text("Pilot Security PIN", style: AppTypography.caption(colors.text).copyWith(fontWeight: FontWeight.w600)),
                            const SizedBox(height: 6),
                            TextField(
                              controller: _regPinController,
                              obscureText: true,
                              style: TextStyle(color: colors.text, fontSize: 14),
                              decoration: _inputDecoration(colors, "••••", Icons.lock_outline_rounded),
                            ),

                            const SizedBox(height: 14),

                            Text("Driving License Number", style: AppTypography.caption(colors.text).copyWith(fontWeight: FontWeight.w600)),
                            const SizedBox(height: 6),
                            TextField(
                              controller: _regLicenseController,
                              style: TextStyle(color: colors.text, fontSize: 14),
                              decoration: _inputDecoration(colors, "KL-07-2018-0045678", Icons.badge_outlined),
                            ),

                            const SizedBox(height: 14),

                            Text("Vehicle Classification", style: AppTypography.caption(colors.text).copyWith(fontWeight: FontWeight.w600)),
                            const SizedBox(height: 6),
                            TextField(
                              controller: _regVehicleTypeController,
                              style: TextStyle(color: colors.text, fontSize: 14),
                              decoration: _inputDecoration(colors, "16-Wheeler Multi-Axle", Icons.fire_truck_outlined),
                            ),

                            const SizedBox(height: 22),

                            PrimaryButton(
                              label: "Submit Pilot Application",
                              onPressed: _handleDriverRegister,
                              isLoading: _isLoading,
                              icon: Icons.check_circle_outline_rounded,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(AppColorsExtension colors, String hint, IconData icon, {Widget? suffixIcon}) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: colors.textSecondary.withValues(alpha: 0.5)),
      prefixIcon: Icon(icon, color: colors.textSecondary, size: 20),
      suffixIcon: suffixIcon,
      filled: true,
      fillColor: colors.bg,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: colors.border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: colors.border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: colors.brand, width: 1.5),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
    );
  }

  Widget _buildBanner(AppColorsExtension colors, String text, {required bool isError}) {
    final color = isError ? colors.statusDanger : colors.statusSuccess;
    final container = isError ? colors.statusDangerContainer : colors.statusSuccessContainer;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: container,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.35)),
      ),
      child: Row(
        children: [
          Icon(isError ? Icons.error_outline_rounded : Icons.check_circle_outline_rounded, color: color, size: 18),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: TextStyle(color: color, fontSize: 12.5, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}
