import "package:flutter/material.dart";
import "../../../core/design/tokens/app_colors.dart";
import "../../../core/design/tokens/app_typography.dart";
import "../../../core/design/tokens/app_spacing.dart";
import "../../../core/design/components/buttons.dart";
import "../../../core/design/theme/theme_controller.dart";
import "../../../core/data/models/driver.dart";
import "../../../core/data/seed_data.dart";
import "../../../core/data/api_client.dart";
import "../../../core/data/fleet_repository.dart";
import "../../../l10n/app_localizations.dart";
import "../../auth/role_select_screen.dart";

class DriverProfileTab extends StatefulWidget {
  final Driver? driver;
  final String? driverId;
  final VoidCallback? onToggleLanguage;

  const DriverProfileTab({
    super.key,
    this.driver,
    this.driverId,
    this.onToggleLanguage,
  });

  @override
  State<DriverProfileTab> createState() => _DriverProfileTabState();
}

class _DriverProfileTabState extends State<DriverProfileTab> {
  late Driver _currentDriver;

  @override
  void initState() {
    super.initState();
    _currentDriver = widget.driver ??
        (ApiClient.instance.currentDriver ??
            SeedData.drivers.firstWhere(
              (d) => d.id == widget.driverId,
              orElse: () => SeedData.drivers.first,
            ));
  }

  void _showEditProfileSheet(BuildContext context) {
    final colors = context.colors;
    final nameCtrl = TextEditingController(text: _currentDriver.name);
    final licenseCtrl = TextEditingController(text: _currentDriver.licenceNumber);
    final truckCtrl = TextEditingController(text: _currentDriver.assignedTruckPlate);
    final expCtrl = TextEditingController(text: _currentDriver.experienceYears.toString());
    bool isSaving = false;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: colors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return Padding(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 20,
                bottom: MediaQuery.of(context).viewInsets.bottom + 24,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Update Pilot Credentials",
                    style: AppTypography.title(colors.text, fontSize: 18),
                  ),
                  const SizedBox(height: 14),
                  _buildEditField(colors, "Full Name", nameCtrl),
                  const SizedBox(height: 10),
                  _buildEditField(colors, "Driving Licence (HMV)", licenseCtrl),
                  const SizedBox(height: 10),
                  _buildEditField(colors, "Assigned Truck Plate", truckCtrl),
                  const SizedBox(height: 10),
                  _buildEditField(colors, "Years of Experience", expCtrl, isNumber: true),
                  const SizedBox(height: 18),
                  PrimaryButton(
                    label: "SAVE & SYNC WITH SUPABASE",
                    isLoading: isSaving,
                    onPressed: () async {
                      final nav = Navigator.of(ctx);
                      final messenger = ScaffoldMessenger.of(context);
                      setSheetState(() => isSaving = true);
                      final exp = int.tryParse(expCtrl.text.trim()) ?? _currentDriver.experienceYears;

                      final updated = Driver(
                        id: _currentDriver.id,
                        name: nameCtrl.text.trim(),
                        phone: _currentDriver.phone,
                        licenceNumber: licenseCtrl.text.trim().toUpperCase(),
                        assignedTruckPlate: truckCtrl.text.trim().toUpperCase(),
                        experienceYears: exp,
                      );

                      await ApiClient.instance.updateDriverProfile(
                        fullName: updated.name,
                        licenseNumber: updated.licenceNumber,
                        assignedTruckPlate: updated.assignedTruckPlate,
                        experienceYears: updated.experienceYears,
                      );

                      LocalFleetRepository.instance.addOrUpdateDriver(updated);

                      if (mounted) {
                        setState(() => _currentDriver = updated);
                      }
                      nav.pop();
                      messenger.showSnackBar(
                        const SnackBar(content: Text("Driver profile synced successfully!")),
                      );
                    },
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildEditField(AppColorsExtension colors, String label, TextEditingController ctrl, {bool isNumber = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTypography.label(colors.textSecondary, fontSize: 11)),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: colors.surfaceAlt,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: colors.border),
          ),
          child: TextField(
            controller: ctrl,
            keyboardType: isNumber ? TextInputType.number : TextInputType.text,
            style: AppTypography.body(colors.text, fontSize: 14),
            decoration: const InputDecoration(
              border: InputBorder.none,
              isDense: true,
              contentPadding: EdgeInsets.symmetric(vertical: 10),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = AppLocalizations.of(context);
    final d = _currentDriver;
    final isDark = ThemeController.instance.isDark(context);

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
      children: [
        // DRIVER IDENTITY CARD
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          decoration: BoxDecoration(
            color: colors.surface,
            borderRadius: AppSpacing.cardBorderRadius,
            border: Border.all(color: colors.border, width: 1.0),
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: colors.surfaceAlt,
                child: Icon(Icons.person_rounded, size: 28, color: colors.brand),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      d.name,
                      style: AppTypography.title(colors.text, fontSize: 18),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      d.phone,
                      style: AppTypography.supporting(colors.textSecondary, fontSize: 13),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 12),

        // VEHICLE & LICENCE DETAILS
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: colors.surface,
            borderRadius: AppSpacing.cardBorderRadius,
            border: Border.all(color: colors.border, width: 1.0),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildInfoRow(context, "Assigned vehicle", d.assignedTruckPlate),
              const Divider(height: 20),
              _buildInfoRow(context, "Driving licence", d.licenceNumber),
              const Divider(height: 20),
              _buildInfoRow(context, "Experience", "${d.experienceYears} Years"),
            ],
          ),
        ),

        const SizedBox(height: 12),

        // EDIT DETAILS ACTION
        SecondaryButton(
          label: "Edit Vehicle & Licence Details",
          icon: Icons.edit_note_rounded,
          height: 48,
          onPressed: () => _showEditProfileSheet(context),
        ),

        const SizedBox(height: 12),

        // THEME PREFERENCE (Midnight Black / Pure White)
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: colors.surface,
            borderRadius: AppSpacing.cardBorderRadius,
            border: Border.all(color: colors.border, width: 1.0),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Icon(
                      isDark ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
                      size: 20,
                      color: colors.brand,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        isDark ? "Midnight Black" : "Pure White",
                        style: AppTypography.section(colors.text, fontSize: 15),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              Switch(
                value: isDark,
                activeColor: colors.brand,
                onChanged: (val) {
                  setState(() {
                    ThemeController.instance.setThemeMode(val ? ThemeMode.dark : ThemeMode.light);
                  });
                },
              ),
            ],
          ),
        ),

        const SizedBox(height: 14),

        // LANGUAGE BUTTON
        SecondaryButton(
          label: "Change language (English / മലയാളം)",
          icon: Icons.language_rounded,
          height: 48,
          onPressed: widget.onToggleLanguage,
        ),

        const SizedBox(height: 10),

        // SIGN OUT
        DangerButton(
          label: l10n.btnLogout,
          icon: Icons.logout_rounded,
          height: 48,
          confirmTitle: "Switch role / Sign out?",
          confirmMessage: "You will return to the role selection screen.",
          confirmActionLabel: "Sign out",
          onConfirmed: () {
            ApiClient.instance.logout();
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => RoleSelectScreen(onToggleLanguage: widget.onToggleLanguage)),
              (route) => false,
            );
          },
        ),
      ],
    );
  }

  Widget _buildInfoRow(BuildContext context, String label, String value) {
    final colors = context.colors;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          flex: 2,
          child: Text(
            label,
            style: AppTypography.supporting(colors.textSecondary, fontSize: 13),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(width: 8),
        Flexible(
          flex: 3,
          child: Text(
            value,
            style: AppTypography.section(colors.text, fontSize: 14, isNumber: true),
            textAlign: TextAlign.end,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
