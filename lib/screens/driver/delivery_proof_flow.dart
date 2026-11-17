import "package:flutter/material.dart";
import "../../core/design/tokens/app_colors.dart";
import "../../core/design/tokens/app_typography.dart";
import "../../core/design/tokens/app_spacing.dart";
import "../../core/design/components/buttons.dart";
import "../../core/data/fleet_repository.dart";
import "../../l10n/app_localizations.dart";

class DeliveryProofFlow extends StatefulWidget {
  final String tripId;

  const DeliveryProofFlow({super.key, required this.tripId});

  @override
  State<DeliveryProofFlow> createState() => _DeliveryProofFlowState();
}

class _DeliveryProofFlowState extends State<DeliveryProofFlow> {
  int _currentStep = 1;

  final _otpController = TextEditingController();
  bool _photoTaken = false;
  final List<Offset?> _signaturePoints = [];

  bool _isSubmitting = false;

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  void _nextStep() {
    if (_currentStep == 1) {
      if (_otpController.text.trim().length != 4) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please enter a valid 4-digit OTP")),
        );
        return;
      }
    } else if (_currentStep == 2) {
      if (!_photoTaken) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please take a photo of the unloaded cargo")),
        );
        return;
      }
    }
    setState(() => _currentStep++);
  }

  void _prevStep() {
    if (_currentStep > 1) {
      setState(() => _currentStep--);
    } else {
      Navigator.pop(context);
    }
  }

  void _submitProof(AppLocalizations l10n) async {
    if (_signaturePoints.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please ask the receiver to sign in the box")),
      );
      return;
    }

    setState(() => _isSubmitting = true);
    try {
      await LocalFleetRepository.instance.submitProofOfDelivery(
        widget.tripId,
        otp: _otpController.text.trim(),
        photoPath: "cargo_proof_${widget.tripId}.jpg",
        signatureSvg: "sig_points_${_signaturePoints.length}",
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.proofCompletedToast),
            backgroundColor: const Color(0xFF0B6E3A),
          ),
        );
        Navigator.pop(context, true);
      }
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: colors.bg,
      appBar: AppBar(
        title: Text(
          l10n.btnUploadProof,
          style: AppTypography.title(colors.text),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: _prevStep,
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(color: colors.border, height: 1.0),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Step indicator container
              Container(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                decoration: BoxDecoration(
                  color: colors.surfaceAlt,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: colors.border),
                ),
                child: Text(
                  l10n.proofStepIndicator(_currentStep.toString()),
                  style: AppTypography.heading(colors.text),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 20),

              // Step content
              Expanded(
                child: ListView(
                  children: [
                    if (_currentStep == 1) _buildStep1(context, l10n),
                    if (_currentStep == 2) _buildStep2(context, l10n),
                    if (_currentStep == 3) _buildStep3(context, l10n),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Action buttons
              if (_currentStep < 3)
                PrimaryButton(
                  label: l10n.btnNext,
                  icon: Icons.arrow_forward_rounded,
                  onPressed: _nextStep,
                )
              else
                PrimaryButton(
                  label: l10n.btnSubmitProof,
                  icon: Icons.check_circle_rounded,
                  isLoading: _isSubmitting,
                  onPressed: () => _submitProof(l10n),
                ),

              if (_currentStep > 1) ...[
                const SizedBox(height: 12),
                SecondaryButton(
                  label: l10n.btnBack,
                  icon: Icons.arrow_back_rounded,
                  onPressed: _prevStep,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStep1(BuildContext context, AppLocalizations l10n) {
    final colors = context.colors;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.proofStep1Title, style: AppTypography.heading(colors.text)),
            const SizedBox(height: 16),
            TextField(
              controller: _otpController,
              keyboardType: TextInputType.number,
              maxLength: 4,
              textAlign: TextAlign.center,
              style: AppTypography.display(colors.text, isNumber: true),
              decoration: InputDecoration(
                hintText: "••••",
                filled: true,
                fillColor: colors.surfaceAlt,
                border: OutlineInputBorder(
                  borderRadius: AppSpacing.buttonBorderRadius,
                  borderSide: BorderSide(color: colors.border),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStep2(BuildContext context, AppLocalizations l10n) {
    final colors = context.colors;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.proofStep2Title, style: AppTypography.heading(colors.text)),
            const SizedBox(height: 16),
            Container(
              height: 180,
              width: double.infinity,
              decoration: BoxDecoration(
                color: colors.surfaceAlt,
                borderRadius: AppSpacing.cardBorderRadius,
                border: Border.all(color: colors.border),
              ),
              child: _photoTaken
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.check_circle_rounded, size: 48, color: colors.statusSuccess),
                        const SizedBox(height: 8),
                        Text(l10n.proofStep2PhotoTaken, style: AppTypography.heading(colors.statusSuccess)),
                      ],
                    )
                  : InkWell(
                      onTap: () => setState(() => _photoTaken = true),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.camera_alt_outlined, size: 48, color: colors.brand),
                          const SizedBox(height: 8),
                          Text(l10n.proofStep2TakePhoto, style: AppTypography.heading(colors.brand)),
                        ],
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStep3(BuildContext context, AppLocalizations l10n) {
    final colors = context.colors;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(child: Text(l10n.proofStep3Title, style: AppTypography.heading(colors.text))),
                TextButton(
                  onPressed: () => setState(() => _signaturePoints.clear()),
                  child: Text(l10n.proofStep3Clear, style: AppTypography.label(colors.statusDanger)),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              height: 180,
              width: double.infinity,
              decoration: BoxDecoration(
                color: colors.surfaceAlt,
                borderRadius: AppSpacing.cardBorderRadius,
                border: Border.all(color: colors.border),
              ),
              child: GestureDetector(
                onPanUpdate: (details) {
                  setState(() => _signaturePoints.add(details.localPosition));
                },
                onPanEnd: (_) => setState(() => _signaturePoints.add(null)),
                child: CustomPaint(
                  painter: _SignaturePainter(points: _signaturePoints, strokeColor: colors.text),
                  size: Size.infinite,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SignaturePainter extends CustomPainter {
  final List<Offset?> points;
  final Color strokeColor;

  _SignaturePainter({required this.points, required this.strokeColor});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = strokeColor
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 3.0;

    for (int i = 0; i < points.length - 1; i++) {
      if (points[i] != null && points[i + 1] != null) {
        canvas.drawLine(points[i]!, points[i + 1]!, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _SignaturePainter oldDelegate) => true;
}
