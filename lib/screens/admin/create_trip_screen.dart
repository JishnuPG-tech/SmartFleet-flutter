import 'package:flutter/material.dart';
import 'package:smartfleet_flutter/core/data/models/driver.dart';
import 'package:smartfleet_flutter/core/data/seed_data.dart';
import 'package:smartfleet_flutter/core/data/fleet_repository.dart';
import 'package:smartfleet_flutter/core/theme/app_theme.dart';
import 'package:smartfleet_flutter/l10n/app_localizations.dart';

class CreateTripScreen extends StatefulWidget {
  const CreateTripScreen({super.key});

  @override
  State<CreateTripScreen> createState() => _CreateTripScreenState();
}

class _CreateTripScreenState extends State<CreateTripScreen> {
  final _formKey = GlobalKey<FormState>();

  String? _selectedFrom;
  String? _selectedTo;
  final _cargoController = TextEditingController();
  final _weightController = TextEditingController();
  String? _selectedDriverId;

  bool _isSubmitting = false;

  @override
  void dispose() {
    _cargoController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  void _onConfirmAndSubmit(AppLocalizations l10n, List<Driver> drivers) async {
    if (!_formKey.currentState!.validate()) return;

    final driver = drivers.firstWhere((d) => d.id == _selectedDriverId);

    // Show Confirmation Dialog
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor: AppColors.background,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: const BorderSide(color: AppColors.border, width: 2),
          ),
          title: Text(
            l10n.confirmTripTitle,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.confirmTripSubtitle,
                style: const TextStyle(fontSize: 16, color: AppColors.textSecondary),
              ),
              const SizedBox(height: 16),
              Text(
                '$_selectedFrom ➔ $_selectedTo',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: AppColors.accent),
              ),
              const SizedBox(height: 8),
              Text(
                'Cargo: ${_cargoController.text.trim()} (${_weightController.text.trim()} Tons)',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
              ),
              const SizedBox(height: 8),
              Text(
                'Driver: ${driver.name} · ${driver.assignedTruckPlate}',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: Text(
                l10n.btnCancel,
                style: const TextStyle(fontSize: 18, color: AppColors.textSecondary),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(minimumSize: const Size(120, 48)),
              onPressed: () => Navigator.pop(ctx, true),
              child: Text(l10n.btnConfirmAndSend),
            ),
          ],
        );
      },
    );

    if (confirmed == true && mounted) {
      setState(() => _isSubmitting = true);
      try {
        final weight = double.tryParse(_weightController.text.trim()) ?? 10.0;
        final newTrip = await LocalFleetRepository.instance.createTrip(
          from: _selectedFrom!,
          to: _selectedTo!,
          cargo: _cargoController.text.trim(),
          weightTons: weight,
          driverId: _selectedDriverId!,
        );

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Trip ${newTrip.id} sent to ${driver.name}!'),
              backgroundColor: AppColors.accent,
            ),
          );
          Navigator.pop(context);
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to create trip: $e'),
              backgroundColor: AppColors.statusProblemText,
            ),
          );
        }
      } finally {
        if (mounted) setState(() => _isSubmitting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final places = SeedData.places;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          l10n.newTripTitle,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w900,
            color: AppColors.textPrimary,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.5),
          child: Container(color: AppColors.border, height: 1.5),
        ),
      ),
      body: FutureBuilder<List<Driver>>(
        future: LocalFleetRepository.instance.getDrivers(),
        builder: (context, snapshot) {
          final drivers = snapshot.data ?? [];

          return SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 32),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // 1. FROM PLACE
                  Text(
                    l10n.fromPlace,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    isExpanded: true,
                    value: _selectedFrom,
                    hint: Text(l10n.selectPlace),
                    items: places.map((p) {
                      return DropdownMenuItem(value: p, child: Text(p));
                    }).toList(),
                    onChanged: (val) => setState(() => _selectedFrom = val),
                    validator: (val) => val == null ? l10n.errFromRequired : null,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.trip_origin, color: AppColors.accent),
                      filled: true,
                      fillColor: AppColors.surfaceCard,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: const BorderSide(color: AppColors.border, width: 1.5),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // 2. TO PLACE
                  Text(
                    l10n.toPlace,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    isExpanded: true,
                    value: _selectedTo,
                    hint: Text(l10n.selectPlace),
                    items: places.map((p) {
                      return DropdownMenuItem(value: p, child: Text(p));
                    }).toList(),
                    onChanged: (val) => setState(() => _selectedTo = val),
                    validator: (val) {
                      if (val == null) return l10n.errToRequired;
                      if (val == _selectedFrom) return l10n.errSamePlace;
                      return null;
                    },
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.location_on, color: AppColors.statusProblemText),
                      filled: true,
                      fillColor: AppColors.surfaceCard,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: const BorderSide(color: AppColors.border, width: 1.5),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // 3. CARGO DESCRIPTION
                  Text(
                    l10n.cargoTitleLabel,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _cargoController,
                    decoration: InputDecoration(
                      hintText: 'e.g. Industrial Steel Coils, Cement Bags',
                      prefixIcon: const Icon(Icons.inventory_2, color: AppColors.textSecondary),
                      filled: true,
                      fillColor: AppColors.surfaceCard,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: const BorderSide(color: AppColors.border, width: 1.5),
                      ),
                    ),
                    validator: (val) {
                      if (val == null || val.trim().isEmpty) return l10n.errCargoRequired;
                      return null;
                    },
                  ),

                  const SizedBox(height: 20),

                  // 4. WEIGHT IN TONS
                  Text(
                    l10n.cargoWeightLabel,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _weightController,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    decoration: InputDecoration(
                      hintText: 'e.g. 24.5',
                      prefixIcon: const Icon(Icons.scale, color: AppColors.textSecondary),
                      filled: true,
                      fillColor: AppColors.surfaceCard,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: const BorderSide(color: AppColors.border, width: 1.5),
                      ),
                    ),
                    validator: (val) {
                      if (val == null || val.trim().isEmpty) return l10n.errWeightRequired;
                      final n = double.tryParse(val.trim());
                      if (n == null || n <= 0) return l10n.errWeightRequired;
                      return null;
                    },
                  ),

                  const SizedBox(height: 20),

                  // 5. ASSIGN DRIVER
                  Text(
                    l10n.assignDriverLabel,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    isExpanded: true,
                    value: _selectedDriverId,
                    hint: Text(l10n.selectDriverHint),
                    items: drivers.map((d) {
                      return DropdownMenuItem(
                        value: d.id,
                        child: Text('${d.name} (${d.assignedTruckPlate})'),
                      );
                    }).toList(),
                    onChanged: (val) => setState(() => _selectedDriverId = val),
                    validator: (val) => val == null ? l10n.errDriverRequired : null,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.person, color: AppColors.accent),
                      filled: true,
                      fillColor: AppColors.surfaceCard,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: const BorderSide(color: AppColors.border, width: 1.5),
                      ),
                    ),
                  ),

                  const SizedBox(height: 32),

                  // SUBMIT BUTTON
                  ElevatedButton(
                    onPressed: _isSubmitting ? null : () => _onConfirmAndSubmit(l10n, drivers),
                    child: _isSubmitting
                        ? const CircularProgressIndicator(color: Colors.white)
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.send, color: Colors.white),
                              const SizedBox(width: 8),
                              Flexible(
                                child: Text(
                                  l10n.btnSendToDriver,
                                  textAlign: TextAlign.center,
                                ),
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
    );
  }
}
