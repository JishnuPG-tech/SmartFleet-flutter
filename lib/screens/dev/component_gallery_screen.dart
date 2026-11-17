import "package:flutter/material.dart";
import "../../core/design/tokens/app_colors.dart";
import "../../core/design/tokens/app_typography.dart";
import "../../core/design/theme/theme_controller.dart";
import "../../core/design/components/status_chip.dart";
import "../../core/design/components/buttons.dart";
import "../../core/design/components/live_badge.dart";
import "../../core/design/components/status_headline.dart";
import "../../core/design/components/kpi_tile.dart";
import "../../core/design/components/tracking_timeline.dart";
import "../../core/design/components/trip_card.dart";
import "../../core/design/components/truck_card.dart";
import "../../core/design/components/driver_card.dart";
import "../../core/design/components/skeleton_loader.dart";
import "../../core/design/components/empty_state.dart";
import "../../core/design/components/error_state.dart";
import "../../core/design/components/settings_tile.dart";

class ComponentGalleryScreen extends StatefulWidget {
  const ComponentGalleryScreen({super.key});

  @override
  State<ComponentGalleryScreen> createState() => _ComponentGalleryScreenState();
}

class _ComponentGalleryScreenState extends State<ComponentGalleryScreen> {
  double _fontScale = 1.0;
  bool _isMalayalam = false;
  bool _primaryLoading = false;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final isDark = ThemeController.instance.isDark(context);

    return MediaQuery(
      data: MediaQuery.of(context).copyWith(
        textScaler: TextScaler.linear(_fontScale),
      ),
      child: Scaffold(
        appBar: AppBar(
          title: Text("Design Component Gallery", style: AppTypography.heading(colors.text)),
          actions: [
            // Dark / Light toggle
            IconButton(
              icon: Icon(isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded),
              onPressed: () {
                ThemeController.instance.setThemeMode(
                  isDark ? ThemeMode.light : ThemeMode.dark,
                );
              },
            ),
            // ML / EN toggle
            TextButton(
              onPressed: () => setState(() => _isMalayalam = !_isMalayalam),
              child: Text(
                _isMalayalam ? "മലയാളം" : "EN",
                style: AppTypography.label(colors.brand),
              ),
            ),
            // Scale toggle
            TextButton(
              onPressed: () => setState(() => _fontScale = _fontScale == 1.0 ? 1.5 : 1.0),
              child: Text(
                "${_fontScale}x",
                style: AppTypography.label(colors.brand, isNumber: true),
              ),
            ),
          ],
        ),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _buildSection("1. Status Headline", [
              StatusHeadline(
                headline: _isMalayalam ? "4:30 PM-ന് എത്തിച്ചേരും" : "Arriving by 4:30 PM",
                subtitle: _isMalayalam ? "കോഴിക്കോട് ഹബ്ബിലേക്ക്" : "To Kozhikode Hub (62.4 km remaining)",
              ),
            ]),

            _buildSection("2. Live Badges", [
              const Wrap(
                spacing: 16,
                runSpacing: 10,
                children: [
                  LiveBadge(status: LiveStatus.live, label: "Live · updated 12 s ago"),
                  LiveBadge(status: LiveStatus.stale, label: "Last seen 4 min ago"),
                  LiveBadge(status: LiveStatus.offline, label: "Offline"),
                ],
              ),
            ]),

            _buildSection("3. Status Chips", [
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  StatusChipV2.success(label: _isMalayalam ? "പൂർത്തിയായി" : "Delivered"),
                  StatusChipV2.running(label: _isMalayalam ? "യാത്രയിൽ" : "Running"),
                  StatusChipV2.waiting(label: _isMalayalam ? "കാത്തിരിക്കുന്നു" : "Waiting"),
                  StatusChipV2.danger(label: _isMalayalam ? "വർക്ക്‌ഷോപ്പിൽ" : "In workshop"),
                ],
              ),
            ]),

            _buildSection("4. Action Buttons (56dp)", [
              PrimaryButton(
                label: _isMalayalam ? "ഡെലിവറി പൂർത്തിയാക്കുക" : "Complete Delivery",
                icon: Icons.check_circle_outline_rounded,
                isLoading: _primaryLoading,
                onPressed: () {
                  setState(() => _primaryLoading = true);
                  Future.delayed(const Duration(seconds: 2), () {
                    if (mounted) setState(() => _primaryLoading = false);
                  });
                },
              ),
              const SizedBox(height: 12),
              SecondaryButton(
                label: _isMalayalam ? "ഓഫീസിലേക്ക് വിളിക്കുക" : "Call Fleet Office",
                icon: Icons.phone_outlined,
                onPressed: () {},
              ),
              const SizedBox(height: 12),
              DangerButton(
                label: _isMalayalam ? "ബ്രേക്ക്ഡൗൺ റിപ്പോർട്ട്" : "Report Breakdown",
                icon: Icons.warning_amber_rounded,
                confirmTitle: "Report Vehicle Breakdown?",
                confirmMessage: "This will alert the fleet office that your truck needs immediate assistance.",
                confirmActionLabel: "Yes, Send Alert",
                onConfirmed: () {},
              ),
            ]),

            _buildSection("5. KPI Tile (Animated Count-up)", [
              KpiTile(
                label: _isMalayalam ? "ഓടുന്ന വണ്ടികൾ" : "Active Running Trips",
                count: 24,
                icon: Icons.navigation_rounded,
                accentColor: colors.brand,
                containerColor: colors.statusRunningContainer,
              ),
            ]),

            _buildSection("6. Trip Card", [
              TripCard(
                id: "TR-1025",
                from: "Kochi Port",
                to: "Kozhikode Hub",
                cargo: "Industrial Steel Coils",
                weightTons: 24.5,
                truckPlate: "KL 11 AB 1234",
                statusType: ChipStatusType.running,
                statusLabel: "Running",
                progressPercent: 0.68,
                distanceDoneText: "122.4 of 180 km done",
                onTap: () {},
              ),
            ]),

            _buildSection("7. Truck Card (Resolved Driver Name)", [
              TruckCard(
                plate: "KL 09 EF 9012",
                model: "Ashok Leyland 4220",
                capacityTons: 42.0,
                status: TruckStatusType.available,
                driverName: "Rahim Mohammed",
                onTap: () {},
              ),
            ]),

            _buildSection("8. Driver Card", [
              DriverCard(
                name: "Suresh Kumar",
                phone: "+91 98471 23456",
                licenceNumber: "KL-11-2015-0098231",
                isLicencePlaceholder: false,
                experienceYears: 12,
                assignedTruckPlate: "KL 11 AB 1234",
                onCall: () {},
              ),
            ]),

            _buildSection("9. Tracking Timeline (Amazon/Shiprocket Style)", [
              const TrackingTimeline(
                steps: [
                  TimelineStepData(
                    title: "Trip Dispatched",
                    subtitle: "Assigned to Suresh Kumar · KL 11 AB 1234",
                    timestamp: "08:30 AM",
                    isCompleted: true,
                  ),
                  TimelineStepData(
                    title: "Cargo Loaded & Started",
                    subtitle: "Departed Kochi Port with 24.5T Steel Coils",
                    timestamp: "09:15 AM",
                    isCompleted: true,
                  ),
                  TimelineStepData(
                    title: "In Transit on NH-66",
                    subtitle: "122.4 km completed · Passing Thrissur bypass",
                    timestamp: "11:45 AM",
                    isCurrent: true,
                  ),
                  TimelineStepData(
                    title: "Destination Arrival",
                    subtitle: "Kozhikode Hub bay arrival & OTP sign-off",
                    timestamp: "ETA 04:30 PM",
                  ),
                ],
              ),
            ]),

            _buildSection("10. Skeleton Loader (Shimmer)", [
              const SkeletonLoader(height: 28, width: 220),
              const SizedBox(height: 8),
              const SkeletonLoader(height: 18, width: 140),
              const SizedBox(height: 12),
              const SkeletonLoader(height: 52),
            ]),

            _buildSection("11. Empty State", [
              EmptyState(
                title: _isMalayalam ? "ട്രിപ്പുകൾ ഒന്നും ഇല്ല" : "No Trips Found",
                subtitle: _isMalayalam ? "തിരഞ്ഞെടുത്ത ഫിൽട്ടറിൽ ട്രിപ്പുകൾ ലഭ്യമല്ല" : "There are no trips matching your search filter.",
              ),
            ]),

            _buildSection("12. Error State", [
              ErrorState(
                title: "Failed to load fleet data",
                message: "Please check your network connection and retry.",
                onRetry: () {},
              ),
            ]),

            _buildSection("13. Settings Tile", [
              SettingsTile(
                title: "App Theme",
                subtitle: isDark ? "Dark theme active" : "Light theme active",
                icon: Icons.palette_outlined,
                onTap: () {},
              ),
            ]),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: AppTypography.heading(context.colors.brand)),
          const SizedBox(height: 10),
          ...children,
        ],
      ),
    );
  }
}
