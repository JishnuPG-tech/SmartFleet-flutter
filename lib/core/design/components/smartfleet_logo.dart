import "package:flutter/material.dart";
import "../tokens/app_colors.dart";

class SmartFleetLogo extends StatelessWidget {
  final double size;
  final bool animate;

  const SmartFleetLogo({
    super.key,
    this.size = 80.0,
    this.animate = false,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Outer subtle glowing aura
          Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: colors.brand.withValues(alpha: 0.22),
                  blurRadius: size * 0.45,
                  spreadRadius: size * 0.05,
                ),
              ],
            ),
          ),

          // High-precision custom vector painter
          CustomPaint(
            size: Size(size, size),
            painter: _LogoPainter(accentColor: colors.brand, surfaceColor: colors.surface),
          ),
        ],
      ),
    );
  }
}

class _LogoPainter extends CustomPainter {
  final Color accentColor;
  final Color surfaceColor;

  _LogoPainter({required this.accentColor, required this.surfaceColor});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // Background circle container
    final bgPaint = Paint()
      ..color = surfaceColor
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, radius - 2, bgPaint);

    // Outer subtle border
    final borderPaint = Paint()
      ..color = accentColor.withValues(alpha: 0.4)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.8;
    canvas.drawCircle(center, radius - 2, borderPaint);

    // Radar Concentric Arc
    final radarPaint = Paint()
      ..color = accentColor.withValues(alpha: 0.25)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.4;
    canvas.drawCircle(center, radius * 0.68, radarPaint);

    // Fleet Geometric Truck Cabin & Cargo Body
    final truckPaint = Paint()
      ..color = accentColor
      ..style = PaintingStyle.fill;

    final w = size.width;
    final h = size.height;

    // Cargo Box
    final cargoRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(w * 0.24, h * 0.36, w * 0.32, h * 0.28),
      const Radius.circular(3),
    );
    canvas.drawRRect(cargoRect, truckPaint);

    // Cabin Front
    final cabinPath = Path()
      ..moveTo(w * 0.58, h * 0.44)
      ..lineTo(w * 0.70, h * 0.44)
      ..lineTo(w * 0.76, h * 0.52)
      ..lineTo(w * 0.76, h * 0.64)
      ..lineTo(w * 0.58, h * 0.64)
      ..close();
    canvas.drawPath(cabinPath, truckPaint);

    // Cabin Windshield cut-out
    final windowPaint = Paint()
      ..color = surfaceColor
      ..style = PaintingStyle.fill;
    final windowPath = Path()
      ..moveTo(w * 0.60, h * 0.46)
      ..lineTo(w * 0.68, h * 0.46)
      ..lineTo(w * 0.72, h * 0.52)
      ..lineTo(w * 0.60, h * 0.52)
      ..close();
    canvas.drawPath(windowPath, windowPaint);

    // Wheels
    final wheelPaint = Paint()
      ..color = accentColor
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(w * 0.34, h * 0.68), w * 0.055, wheelPaint);
    canvas.drawCircle(Offset(w * 0.67, h * 0.68), w * 0.055, wheelPaint);

    // Radar pulse dot at top right
    final dotPaint = Paint()
      ..color = accentColor
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(w * 0.74, h * 0.28), w * 0.035, dotPaint);
  }

  @override
  bool shouldRepaint(covariant _LogoPainter oldDelegate) {
    return oldDelegate.accentColor != accentColor || oldDelegate.surfaceColor != surfaceColor;
  }
}
