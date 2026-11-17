import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../core/theme/app_colors.dart';
import '../../core/models/fleet_models.dart';
import '../../core/state/fleet_state.dart';

class PodCompletionDialog extends StatefulWidget {
  final Trip trip;

  const PodCompletionDialog({super.key, required this.trip});

  @override
  State<PodCompletionDialog> createState() => _PodCompletionDialogState();
}

class _PodCompletionDialogState extends State<PodCompletionDialog> {
  final _receiverController = TextEditingController(text: 'Anil Menon (Yard Officer)');
  final _otpController = TextEditingController(text: '8849');
  final _notesController = TextEditingController(text: 'Seal #KCH-882 intact. All 24.5 MT steel coils unloaded in Bay 3.');
  bool _photoCaptured = true;

  @override
  Widget build(BuildContext context) {
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
            // Handle
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
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'PROOF OF DELIVERY (POD)',
                      style: TextStyle(
                        color: AppColors.green,
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.0,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Mission #${widget.trip.tripNumber}',
                      style: const TextStyle(
                        color: AppColors.pureWhite,
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(LucideIcons.x, color: AppColors.mutedGray),
                ),
              ],
            ),
            const SizedBox(height: 18),

            // Receiver Name Field
            _buildField('RECEIVER / GATE OFFICER NAME', _receiverController, LucideIcons.userCheck),
            const SizedBox(height: 14),

            // 4-Digit Delivery OTP (Amazon Delivery Style)
            _buildField('CONSIGNEE DELIVERY OTP (4 DIGITS)', _otpController, LucideIcons.keyRound),
            const SizedBox(height: 14),

            // Camera Capture Simulation
            const Text(
              'CARGO UNLOAD PHOTO PROOF',
              style: TextStyle(
                color: AppColors.darkSubtext,
                fontSize: 10,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.8,
              ),
            ),
            const SizedBox(height: 6),
            GestureDetector(
              onTap: () {
                setState(() {
                  _photoCaptured = true;
                });
              },
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.midnightBlack,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: _photoCaptured ? AppColors.green.withOpacity(0.5) : AppColors.hairline,
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppColors.green.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(LucideIcons.camera, color: AppColors.green, size: 20),
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'waybill_container_bay3_pod.jpg',
                            style: TextStyle(
                              color: AppColors.pureWhite,
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            'Geotagged: 11.2588° N, 75.7804° E · Kozhikode Bay',
                            style: TextStyle(
                              color: AppColors.green,
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Icon(LucideIcons.checkCircle2, color: AppColors.green, size: 20),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 14),

            // Delivery Notes Field
            _buildField('INSPECTION & SEAL NOTES', _notesController, LucideIcons.fileText),
            const SizedBox(height: 22),

            // Complete Delivery Button
            SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.green,
                  foregroundColor: AppColors.midnightBlack,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 0,
                ),
                onPressed: () {
                  FleetState.instance.completeProofOfDelivery(
                    tripId: widget.trip.id,
                    receiverName: _receiverController.text.trim(),
                    podNotes: _notesController.text.trim(),
                  );
                  Navigator.pop(context); // Close dialog
                  Navigator.pop(context); // Return to Driver Cockpit
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      backgroundColor: AppColors.cardCharcoal,
                      content: Row(
                        children: [
                          Icon(LucideIcons.badgeCheck, color: AppColors.green),
                          SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              'Delivery Completed! Bata credited to driver balance.',
                              style: TextStyle(color: AppColors.pureWhite, fontWeight: FontWeight.w700),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
                icon: const Icon(LucideIcons.checkCheck, size: 22),
                label: const Text(
                  'CONFIRM DELIVERY & SUBMIT POD',
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

  Widget _buildField(String label, TextEditingController controller, IconData icon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: AppColors.darkSubtext,
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
              Icon(icon, size: 14, color: AppColors.mutedGray),
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  controller: controller,
                  style: const TextStyle(
                    color: AppColors.pureWhite,
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
