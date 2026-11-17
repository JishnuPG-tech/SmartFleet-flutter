import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class TelemetryRadarMap extends StatefulWidget {
  final double height;

  const TelemetryRadarMap({super.key, this.height = 190});

  @override
  State<TelemetryRadarMap> createState() => _TelemetryRadarMapState();
}

class _TelemetryRadarMapState extends State<TelemetryRadarMap>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFF0D100E),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.hairline, width: 0.8),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: Stack(
          children: [
            // Radar Canvas
            AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return CustomPaint(
                  size: Size(double.infinity, widget.height),
                  painter: _RadarMapPainter(progress: _controller.value),
                );
              },
            ),
            // Header Info Pill
            Positioned(
              top: 14,
              left: 14,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: AppColors.midnightBlack.withOpacity(0.85),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.hairline, width: 0.8),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.radar, size: 14, color: AppColors.acidLime),
                    SizedBox(width: 6),
                    Text(
                      'NH-66 FREIGHT CORRIDOR',
                      style: TextStyle(
                        color: AppColors.pureWhite,
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.8,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Live Speed & Coordinates Pill
            Positioned(
              bottom: 14,
              right: 14,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: AppColors.midnightBlack.withOpacity(0.85),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.hairline, width: 0.8),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '68 KM/H · 18 LORRIES LIVE',
                      style: TextStyle(
                        color: AppColors.acidLime,
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RadarMapPainter extends CustomPainter {
  final double progress;

  _RadarMapPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    // Grid Lines
    final gridPaint = Paint()
      ..color = Colors.white.withOpacity(0.04)
      ..strokeWidth = 0.8;

    for (double x = 0; x < size.width; x += 35) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), gridPaint);
    }
    for (double y = 0; y < size.height; y += 35) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    // Highway Vector Spline
    final path = Path();
    path.moveTo(size.width * 0.1, size.height * 0.85);
    path.cubicTo(
      size.width * 0.35, size.height * 0.65,
      size.width * 0.55, size.height * 0.40,
      size.width * 0.90, size.height * 0.18,
    );

    // Glow Track
    final glowTrackPaint = Paint()
      ..color = AppColors.acidLime.withOpacity(0.15)
      ..strokeWidth = 6.0
      ..style = PaintingStyle.stroke;
    canvas.drawPath(path, glowTrackPaint);

    // Main Neon Highway Spline
    final trackPaint = Paint()
      ..color = AppColors.acidLime.withOpacity(0.8)
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;
    canvas.drawPath(path, trackPaint);

    // Waypoint Hubs
    _drawWaypoint(canvas, Offset(size.width * 0.1, size.height * 0.85), 'COK');
    _drawWaypoint(canvas, Offset(size.width * 0.45, size.height * 0.52), 'TCR');
    _drawWaypoint(canvas, Offset(size.width * 0.90, size.height * 0.18), 'CCJ');

    // Moving Lorry Marker along the spline
    final metric = path.computeMetrics().first;
    final lorryDistance = metric.length * ((progress + 0.3) % 1.0);
    final tangent = metric.getTangentForOffset(lorryDistance);

    if (tangent != null) {
      // Pulse Circle around moving truck
      final pulseRadius = 10 + 6 * math.sin(progress * 2 * math.pi);
      final pulsePaint = Paint()
        ..color = AppColors.acidLime.withOpacity(0.25)
        ..style = PaintingStyle.fill;
      canvas.drawCircle(tangent.position, pulseRadius, pulsePaint);

      // Core Truck Dot
      final truckPaint = Paint()
        ..color = AppColors.acidLime
        ..style = PaintingStyle.fill;
      canvas.drawCircle(tangent.position, 5, truckPaint);
    }
  }

  void _drawWaypoint(Canvas canvas, Offset offset, String label) {
    // Outer Ring
    final ringPaint = Paint()
      ..color = Colors.white.withOpacity(0.6)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;
    canvas.drawCircle(offset, 4.5, ringPaint);

    // Inner Dot
    final dotPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    canvas.drawCircle(offset, 2.0, dotPaint);

    // Label
    final textPainter = TextPainter(
      text: TextSpan(
        text: label,
        style: const TextStyle(
          color: AppColors.mutedGray,
          fontSize: 9,
          fontWeight: FontWeight.w700,
          fontFamily: 'monospace',
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    textPainter.paint(canvas, Offset(offset.dx - 10, offset.dy + 8));
  }

  @override
  bool shouldRepaint(covariant _RadarMapPainter oldDelegate) => true;
}
