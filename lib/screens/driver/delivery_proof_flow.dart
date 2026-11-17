import 'package:flutter/material.dart';
import 'package:smartfleet_flutter/core/theme/app_theme.dart';
import 'package:smartfleet_flutter/l10n/app_localizations.dart';
import 'package:smartfleet_flutter/core/data/fleet_repository.dart';

class DeliveryProofFlow extends StatefulWidget {
  final String tripId;

  const DeliveryProofFlow({super.key, required this.tripId});

  @override
  State<DeliveryProofFlow> createState() => _DeliveryProofFlowState();
}

class _DeliveryProofFlowState extends State<DeliveryProofFlow> {
  int _currentStep = 1; // 1, 2, 3
  final TextEditingController _otpController = TextEditingController();
  bool _photoCaptured = false;
  final List<Offset?> _signaturePoints = [];
  String? _errorMessage;

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  void _nextStep() {
    setState(() => _errorMessage = null);

    if (_currentStep == 1) {
      // NOTE: OTP validation is mock/local until real backend exists.
      // Accepts any 4-digit numeric code entered by receiver.
      final code = _otpController.text.trim();
      if (code.length != 4 || int.tryParse(code) == null) {
        setState(() {
          _errorMessage = 'Please enter a valid 4-digit code from receiver';
        });
        return;
      }
      setState(() => _currentStep = 2);
    } else if (_currentStep == 2) {
      if (!_photoCaptured) {
        setState(() {
          _errorMessage = 'Please take a photo of the unloaded cargo';
        });
        return;
      }
      setState(() => _currentStep = 3);
    }
  }

  void _prevStep() {
    if (_currentStep > 1) {
      setState(() {
        _errorMessage = null;
        _currentStep--;
      });
    } else {
      Navigator.pop(context);
    }
  }

  Future<void> _submitProof() async {
    if (_signaturePoints.isEmpty) {
      setState(() {
        _errorMessage = 'Receiver must sign before completing delivery';
      });
      return;
    }

    // Submit to repository
    await LocalFleetRepository.instance.submitProofOfDelivery(
      widget.tripId,
      otp: _otpController.text.trim(),
      photoPath: 'cargo_proof_${widget.tripId}.jpg',
      signatureSvg: 'signature_data_${_signaturePoints.length}_pts',
    );

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: AppColors.accent,
          content: Text(
            AppLocalizations.of(context).proofCompletedToast,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
      );
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.btnUploadProof),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: _prevStep,
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Step indicator
              Container(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                decoration: BoxDecoration(
                  color: AppColors.surfaceCard,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.border),
                ),
                child: Text(
                  l10n.proofStepIndicator(_currentStep),
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 16),

              // Visible Error Banner
              if (_errorMessage != null) ...[
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.statusProblemBg,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppColors.statusProblemText),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.error_outline, color: AppColors.statusProblemText),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          _errorMessage!,
                          style: const TextStyle(
                            color: AppColors.statusProblemText,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
              ],

              // Step Content
              Expanded(
                child: SingleChildScrollView(
                  child: _buildCurrentStep(l10n),
                ),
              ),

              const SizedBox(height: 16),

              // Bottom Navigation Actions
              Row(
                children: [
                  if (_currentStep > 1) ...[
                    Expanded(
                      flex: 1,
                      child: OutlinedButton(
                        onPressed: _prevStep,
                        child: Text(l10n.btnBack),
                      ),
                    ),
                    const SizedBox(width: 12),
                  ],
                  Expanded(
                    flex: 2,
                    child: ElevatedButton(
                      onPressed: _currentStep == 3 ? _submitProof : _nextStep,
                      child: Text(_currentStep == 3 ? l10n.btnSubmitProof : l10n.btnNext),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCurrentStep(AppLocalizations l10n) {
    switch (_currentStep) {
      case 1:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              l10n.proofStep1Title,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _otpController,
              keyboardType: TextInputType.number,
              maxLength: 4,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, letterSpacing: 12),
              decoration: InputDecoration(
                hintText: '••••',
                counterText: '',
                filled: true,
                fillColor: AppColors.surfaceCard,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(color: AppColors.border, width: 2),
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 20),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              l10n.proofStep1Hint,
              style: const TextStyle(fontSize: 16, color: AppColors.textSecondary),
              textAlign: TextAlign.center,
            ),
          ],
        );

      case 2:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              l10n.proofStep2Title,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
            ),
            const SizedBox(height: 20),
            Container(
              height: 220,
              decoration: BoxDecoration(
                color: AppColors.surfaceCard,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.border, width: 2),
              ),
              child: Center(
                child: _photoCaptured
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.check_circle, size: 64, color: AppColors.accent),
                          const SizedBox(height: 12),
                          Text(
                            l10n.proofStep2PhotoTaken,
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
                          ),
                        ],
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.camera_alt, size: 56, color: AppColors.textSecondary),
                          const SizedBox(height: 12),
                          Text(
                            l10n.proofStep2TakePhoto,
                            style: const TextStyle(fontSize: 18, color: AppColors.textSecondary),
                          ),
                        ],
                      ),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () => setState(() => _photoCaptured = true),
              icon: const Icon(Icons.camera),
              label: Text(_photoCaptured ? 'Retake Photo' : l10n.proofStep2TakePhoto),
            ),
          ],
        );

      case 3:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              l10n.proofStep3Title,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
            ),
            const SizedBox(height: 16),
            Container(
              height: 200,
              decoration: BoxDecoration(
                color: AppColors.surfaceCard,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.border, width: 2),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: GestureDetector(
                  onPanUpdate: (details) {
                    final box = context.findRenderObject() as RenderBox?;
                    if (box != null) {
                      setState(() {
                        _signaturePoints.add(details.localPosition);
                      });
                    }
                  },
                  onPanEnd: (_) => setState(() => _signaturePoints.add(null)),
                  child: CustomPaint(
                    painter: _SignaturePainter(_signaturePoints),
                    child: Center(
                      child: _signaturePoints.isEmpty
                          ? Text(
                              l10n.proofStep3SignHint,
                              style: const TextStyle(fontSize: 18, color: AppColors.textSecondary),
                            )
                          : const SizedBox.expand(),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                onPressed: () => setState(() => _signaturePoints.clear()),
                icon: const Icon(Icons.refresh),
                label: Text(l10n.proofStep3Clear),
              ),
            ),
          ],
        );

      default:
        return const SizedBox.shrink();
    }
  }
}

class _SignaturePainter extends CustomPainter {
  final List<Offset?> points;

  _SignaturePainter(this.points);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.textPrimary
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 3.5;

    for (int i = 0; i < points.length - 1; i++) {
      if (points[i] != null && points[i + 1] != null) {
        canvas.drawLine(points[i]!, points[i + 1]!, paint);
      }
    }
  }

  @override
  bool shouldRepaint(_SignaturePainter oldDelegate) => true;
}
