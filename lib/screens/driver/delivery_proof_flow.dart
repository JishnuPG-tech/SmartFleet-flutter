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
  bool _isVerifyingOtp = false;
  String? _otpError;

  bool _photoTaken = false;
  final List<Offset?> _signaturePoints = [];
  bool _isSubmitting = false;

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  Future<void> _verifyAndNext() async {
    final entered = _otpController.text.trim();
    if (entered.length != 4) {
      setState(() => _otpError = "Please enter the 4-digit consignee OTP");
      return;
    }

    setState(() {
      _isVerifyingOtp = true;
      _otpError = null;
    });

    final isValid = await LocalFleetRepository.instance.verifyDeliveryOtp(widget.tripId, entered);

    if (!mounted) return;
    setState(() => _isVerifyingOtp = false);

    if (isValid) {
      setState(() => _currentStep = 2);
    } else {
      setState(() => _otpError = "Incorrect OTP. Please ask consignee for code (Test code: 5821)");
    }
  }

  void _nextStep() {
    if (_currentStep == 1) {
      _verifyAndNext();
    } else if (_currentStep == 2) {
      if (!_photoTaken) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please capture cargo unload proof photo")),
        );
        return;
      }
      setState(() => _currentStep = 3);
    }
  }

  void _prevStep() {
    if (_currentStep > 1) {
      setState(() => _currentStep--);
    } else {
      Navigator.pop(context);
    }
  }

  String _serializeSignatureSvg() {
    if (_signaturePoints.isEmpty) return "";
    final buf = StringBuffer();
    buf.write('<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 300 150"><path d="');
    bool isNewPath = true;
    for (final pt in _signaturePoints) {
      if (pt == null) {
        isNewPath = true;
      } else {
        if (isNewPath) {
          buf.write('M ${pt.dx.toStringAsFixed(1)} ${pt.dy.toStringAsFixed(1)} ');
          isNewPath = false;
        } else {
          buf.write('L ${pt.dx.toStringAsFixed(1)} ${pt.dy.toStringAsFixed(1)} ');
        }
      }
    }
    buf.write('" stroke="#000" stroke-width="2.5" fill="none"/></svg>');
    return buf.toString();
  }

  void _submitProof(AppLocalizations l10n) async {
    if (_signaturePoints.length < 5) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please ask the receiver to sign inside the signature box")),
      );
      return;
    }

    setState(() => _isSubmitting = true);
    try {
      final svg = _serializeSignatureSvg();
      await LocalFleetRepository.instance.submitProofOfDelivery(
        widget.tripId,
        otp: _otpController.text.trim(),
        photoPath: "cargo_proof_${widget.tripId}_delivered.jpg",
        signatureSvg: svg,
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
          "Delivery Proof (${widget.tripId})",
          style: AppTypography.title(colors.text, fontSize: 18),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, size: 20),
          onPressed: _prevStep,
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(color: colors.border, height: 1.0),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // STEP PROGRESS INDICATOR
              Container(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                decoration: BoxDecoration(
                  color: colors.surface,
                  borderRadius: AppSpacing.cardBorderRadius,
                  border: Border.all(color: colors.border, width: 1.0),
                ),
                child: Row(
                  children: [
                    _buildStepDot(1, "OTP", _currentStep >= 1, colors),
                    Expanded(child: Container(height: 1.5, color: _currentStep > 1 ? colors.brand : colors.border)),
                    _buildStepDot(2, "Photo", _currentStep >= 2, colors),
                    Expanded(child: Container(height: 1.5, color: _currentStep > 2 ? colors.brand : colors.border)),
                    _buildStepDot(3, "Sign", _currentStep >= 3, colors),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              Expanded(
                child: SingleChildScrollView(
                  child: _currentStep == 1
                      ? _buildStep1(context, l10n)
                      : (_currentStep == 2 ? _buildStep2(context, l10n) : _buildStep3(context, l10n)),
                ),
              ),

              const SizedBox(height: 12),

              // ACTION CONTROLS
              if (_currentStep < 3)
                PrimaryButton(
                  label: "Continue",
                  icon: Icons.arrow_forward_rounded,
                  isLoading: _isVerifyingOtp,
                  height: 52,
                  onPressed: _nextStep,
                )
              else
                PrimaryButton(
                  label: l10n.btnSubmitProof,
                  icon: Icons.check_circle_rounded,
                  isLoading: _isSubmitting,
                  height: 52,
                  onPressed: () => _submitProof(l10n),
                ),

              if (_currentStep > 1) ...[
                const SizedBox(height: 8),
                SecondaryButton(
                  label: "Back",
                  icon: Icons.arrow_back_rounded,
                  height: 48,
                  onPressed: _prevStep,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStepDot(int step, String label, bool isDone, AppColorsExtension colors) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            color: isDone ? colors.brand : colors.surfaceAlt,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              step.toString(),
              style: AppTypography.supporting(isDone ? colors.onBrand : colors.textSecondary, fontSize: 11).copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: AppTypography.supporting(isDone ? colors.text : colors.textSecondary, fontSize: 11).copyWith(
            fontWeight: isDone ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
      ],
    );
  }

  Widget _buildStep1(BuildContext context, AppLocalizations l10n) {
    final colors = context.colors;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: AppSpacing.cardBorderRadius,
        border: Border.all(color: colors.border, width: 1.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Receiver OTP Verification", style: AppTypography.section(colors.text, fontSize: 16)),
          const SizedBox(height: 6),
          Text(
            "Enter the 4-digit code provided by the consignee upon delivery.",
            style: AppTypography.supporting(colors.textSecondary, fontSize: 13),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _otpController,
            keyboardType: TextInputType.number,
            maxLength: 4,
            textAlign: TextAlign.center,
            style: AppTypography.value(colors.text, fontSize: 28),
            decoration: InputDecoration(
              hintText: "••••",
              filled: true,
              fillColor: colors.surfaceAlt,
              counterText: "",
              errorText: _otpError,
              errorStyle: AppTypography.supporting(colors.statusDanger, fontSize: 12),
              border: OutlineInputBorder(
                borderRadius: AppSpacing.buttonBorderRadius,
                borderSide: BorderSide(color: colors.border, width: 1.0),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: AppSpacing.buttonBorderRadius,
                borderSide: BorderSide(color: colors.border, width: 1.0),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: AppSpacing.buttonBorderRadius,
                borderSide: BorderSide(color: colors.brand, width: 1.5),
              ),
            ),
            onChanged: (_) {
              if (_otpError != null) setState(() => _otpError = null);
            },
          ),
          const SizedBox(height: 12),
          Text(
            "Authorized consignment test code: 5821",
            style: AppTypography.supporting(colors.textSecondary, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildStep2(BuildContext context, AppLocalizations l10n) {
    final colors = context.colors;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: AppSpacing.cardBorderRadius,
        border: Border.all(color: colors.border, width: 1.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Cargo Photo Proof", style: AppTypography.section(colors.text, fontSize: 16)),
          const SizedBox(height: 6),
          Text(
            "Take a clear photo showing the unloaded cargo at the recipient facility.",
            style: AppTypography.supporting(colors.textSecondary, fontSize: 13),
          ),
          const SizedBox(height: 16),
          Container(
            height: 180,
            width: double.infinity,
            decoration: BoxDecoration(
              color: colors.surfaceAlt,
              borderRadius: AppSpacing.cardBorderRadius,
              border: Border.all(color: colors.border, width: 1.0),
            ),
            child: _photoTaken
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.check_circle_rounded, size: 40, color: colors.statusSuccess),
                      const SizedBox(height: 8),
                      Text("Cargo photo captured", style: AppTypography.section(colors.statusSuccess, fontSize: 15)),
                      const SizedBox(height: 6),
                      TextButton.icon(
                        icon: const Icon(Icons.refresh_rounded, size: 16),
                        label: Text("Retake photo", style: AppTypography.supporting(colors.brand, fontSize: 13)),
                        onPressed: () => setState(() => _photoTaken = false),
                      ),
                    ],
                  )
                : InkWell(
                    onTap: () => setState(() => _photoTaken = true),
                    borderRadius: AppSpacing.cardBorderRadius,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.camera_alt_outlined, size: 40, color: colors.brand),
                        const SizedBox(height: 8),
                        Text("Tap to capture cargo photo", style: AppTypography.section(colors.brand, fontSize: 15)),
                        const SizedBox(height: 4),
                        Text("Simulates camera capture", style: AppTypography.supporting(colors.textSecondary, fontSize: 12)),
                      ],
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildStep3(BuildContext context, AppLocalizations l10n) {
    final colors = context.colors;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: AppSpacing.cardBorderRadius,
        border: Border.all(color: colors.border, width: 1.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Consignee Signature", style: AppTypography.section(colors.text, fontSize: 16)),
              TextButton(
                onPressed: () => setState(() => _signaturePoints.clear()),
                child: Text("Clear", style: AppTypography.supporting(colors.statusDanger, fontSize: 13)),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            "Ask the authorized recipient to sign in the box below.",
            style: AppTypography.supporting(colors.textSecondary, fontSize: 13),
          ),
          const SizedBox(height: 14),
          Container(
            height: 160,
            width: double.infinity,
            decoration: BoxDecoration(
              color: colors.surfaceAlt,
              borderRadius: AppSpacing.cardBorderRadius,
              border: Border.all(color: colors.border, width: 1.0),
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
      ..strokeWidth = 2.5;

    for (int i = 0; i < points.length - 1; i++) {
      if (points[i] != null && points[i + 1] != null) {
        canvas.drawLine(points[i]!, points[i + 1]!, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _SignaturePainter oldDelegate) => true;
}
