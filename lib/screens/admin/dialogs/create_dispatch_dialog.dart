import 'package:flutter/material.dart';
import 'package:smartfleet_flutter/core/components/lucide_compat.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/state/fleet_state.dart';

class CreateDispatchDialog extends StatefulWidget {
  const CreateDispatchDialog({super.key});

  @override
  State<CreateDispatchDialog> createState() => _CreateDispatchDialogState();
}

class _CreateDispatchDialogState extends State<CreateDispatchDialog> {
  final _originController = TextEditingController(text: 'Kochi Port SEZ');
  final _originCodeController = TextEditingController(text: 'COK');
  final _destController = TextEditingController(text: 'Kozhikode Depot');
  final _destCodeController = TextEditingController(text: 'CCJ');
  final _cargoController = TextEditingController(text: 'Industrial Steel Coils');
  final _weightController = TextEditingController(text: '24.5 Tons');

  String _selectedDriverName = 'Suresh Kumar';
  String _selectedVehicle = 'KL 11 AB 1234';

  @override
  Widget build(BuildContext context) {
    final availableDrivers = FleetState.instance.drivers;

    return Container(
      padding: EdgeInsets.fromLTRB(20, 20, 20, MediaQuery.of(context).viewInsets.bottom + 24),
      decoration: const BoxDecoration(
        color: AppColors.cardCharcoal,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Handle
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.hairline,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'CREATE FREIGHT DISPATCH',
                      style: TextStyle(
                        color: AppColors.accent,
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.0,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'New Transit Mission',
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(LucideIcons.x, color: AppColors.textSecondary),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Origin & Destination Inputs
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: _buildTextField('ORIGIN HUB', _originController, LucideIcons.mapPin),
                ),
                const SizedBox(width: 10),
                Expanded(
                  flex: 2,
                  child: _buildTextField('CODE', _originCodeController, LucideIcons.hash),
                ),
              ],
            ),
            const SizedBox(height: 14),

            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: _buildTextField('DESTINATION HUB', _destController, LucideIcons.flag),
                ),
                const SizedBox(width: 10),
                Expanded(
                  flex: 2,
                  child: _buildTextField('CODE', _destCodeController, LucideIcons.hash),
                ),
              ],
            ),
            const SizedBox(height: 14),

            // Cargo Details
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: _buildTextField('CARGO DESCRIPTION', _cargoController, LucideIcons.package),
                ),
                const SizedBox(width: 10),
                Expanded(
                  flex: 2,
                  child: _buildTextField('GROSS WT', _weightController, LucideIcons.scale),
                ),
              ],
            ),
            const SizedBox(height: 14),

            // Driver Assignment Dropdown
            const Text(
              'ASSIGN AVAILABLE DRIVER',
              style: TextStyle(
                color: AppColors.textMuted,
                fontSize: 10,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.8,
              ),
            ),
            const SizedBox(height: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.midnightBlack,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.border),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _selectedDriverName,
                  isExpanded: true,
                  dropdownColor: AppColors.cardCharcoal,
                  icon: const Icon(LucideIcons.chevronDown, color: AppColors.accent, size: 18),
                  items: availableDrivers.map((driver) {
                    return DropdownMenuItem(
                      value: driver.name,
                      child: Row(
                        children: [
                          const Icon(LucideIcons.user, size: 14, color: AppColors.accent),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              '${driver.name} · ${driver.assignedVehicle}',
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: AppColors.textPrimary,
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                  onChanged: (val) {
                    if (val != null) {
                      setState(() {
                        _selectedDriverName = val;
                        final found = availableDrivers.firstWhere((d) => d.name == val);
                        _selectedVehicle = found.assignedVehicle;
                      });
                    }
                  },
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Submit Button
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.accent,
                  foregroundColor: AppColors.background,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  elevation: 0,
                ),
                onPressed: () {
                  FleetState.instance.createNewTrip(
                    originCity: _originController.text.trim(),
                    originCode: _originCodeController.text.trim().toUpperCase(),
                    destCity: _destController.text.trim(),
                    destCode: _destCodeController.text.trim().toUpperCase(),
                    cargoTitle: _cargoController.text.trim(),
                    cargoWeight: _weightController.text.trim(),
                    assignedDriverName: _selectedDriverName,
                    vehiclePlate: _selectedVehicle,
                  );
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      backgroundColor: AppColors.cardCharcoal,
                      content: Row(
                        children: [
                          const Icon(LucideIcons.checkCircle2, color: AppColors.accent),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              'Trip dispatched to $_selectedDriverName!',
                              style: const TextStyle(color: AppColors.textPrimary),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
                icon: const Icon(LucideIcons.send, size: 18),
                label: const Text(
                  'DISPATCH TRIP TO DRIVER',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 0.8,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, IconData icon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: AppColors.textMuted,
            fontSize: 10,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.8,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: AppColors.midnightBlack,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.border),
          ),
          child: Row(
            children: [
              Icon(icon, size: 14, color: AppColors.textMuted),
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  controller: controller,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
