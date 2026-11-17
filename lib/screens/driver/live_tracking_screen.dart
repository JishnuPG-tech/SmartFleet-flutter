import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../core/theme/app_colors.dart';
import '../../core/models/fleet_models.dart';
import '../../core/state/fleet_state.dart';
import 'pod_completion_dialog.dart';

class LiveTrackingScreen extends StatefulWidget {
  final Trip trip;

  const LiveTrackingScreen({super.key, required this.trip});

  @override
  State<LiveTrackingScreen> createState() => _LiveTrackingScreenState();
}

class _LiveTrackingScreenState extends State<LiveTrackingScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animController;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: FleetState.instance,
      builder: (context, _) {
        final state = FleetState.instance;

        return Scaffold(
          backgroundColor: AppColors.midnightBlack,
          appBar: AppBar(
            backgroundColor: AppColors.midnightBlack,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(LucideIcons.arrowLeft, color: AppColors.pureWhite),
              onPressed: () => Navigator.pop(context),
            ),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${widget.trip.originCode} → ${widget.trip.destCode}',
                  style: const TextStyle(
                    color: AppColors.pureWhite,
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                Text(
                  'MISSION #${widget.trip.tripNumber} · NH-66 CORRIDOR',
                  style: const TextStyle(
                    color: AppColors.accent,
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.8,
                  ),
                ),
              ],
            ),
            actions: [
              Container(
                margin: const EdgeInsets.only(right: 16),
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.green.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.green.withOpacity(0.4)),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(LucideIcons.satellite, size: 12, color: AppColors.green),
                    SizedBox(width: 4),
                    Text(
                      'GPS LOCK',
                      style: TextStyle(
                        color: AppColors.green,
                        fontSize: 9,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          body: SafeArea(
            child: Column(
              children: [
                // Turn-by-Turn Instruction Banner
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.cardCharcoal,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.accent.withOpacity(0.4)),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: AppColors.accent.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(LucideIcons.cornerUpRight, color: AppColors.accent, size: 24),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'In 1.2 km, keep right',
                              style: TextStyle(
                                color: AppColors.pureWhite,
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              state.currentWaypoint,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: AppColors.mutedGray,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // Live Highway Vector Map Visualizer
                Expanded(
                  flex: 3,
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0D110E),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppColors.hairline),
                    ),
                    child: Stack(
                      children: [
                        // Grid Background
                        Positioned.fill(
                          child: CustomPaint(
                            painter: HighwayGridPainter(),
                          ),
                        ),
                        // Moving Vector Highway Spline
                        Positioned.fill(
                          child: AnimatedBuilder(
                            animation: _animController,
                            builder: (context, _) {
                              return CustomPaint(
                                painter: LiveHighwayNavPainter(
                                  progress: state.liveProgress,
                                  animValue: _animController.value,
                                ),
                              );
                            },
                          ),
                        ),

                        // Floating Speedometer & GPS Telemetry Overlay
                        Positioned(
                          top: 14,
                          left: 14,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                            decoration: BoxDecoration(
                              color: AppColors.dockGlass,
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(color: AppColors.hairline),
                            ),
                            child: Row(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'SPEED',
                                      style: TextStyle(
                                        color: AppColors.mutedGray,
                                        fontSize: 9,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.baseline,
                                      textBaseline: TextBaseline.alphabetic,
                                      children: [
                                        Text(
                                          '${state.liveSpeed.toInt()}',
                                          style: const TextStyle(
                                            color: AppColors.accent,
                                            fontSize: 26,
                                            fontWeight: FontWeight.w900,
                                            fontFamily: 'monospace',
                                          ),
                                        ),
                                        const SizedBox(width: 2),
                                        const Text(
                                          'KM/H',
                                          style: TextStyle(
                                            color: AppColors.mutedGray,
                                            fontSize: 10,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                const SizedBox(width: 14),
                                Container(width: 1, height: 28, color: AppColors.border),
                                const SizedBox(width: 14),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'SPEED LIMIT',
                                      style: TextStyle(
                                        color: AppColors.mutedGray,
                                        fontSize: 9,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    const Text(
                                      '80 KM/H',
                                      style: TextStyle(
                                        color: AppColors.pureWhite,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),

                        // Interactive Speed Simulation Controls
                        Positioned(
                          right: 14,
                          top: 14,
                          child: Column(
                            children: [
                              _buildSpeedButton(
                                icon: LucideIcons.plus,
                                onTap: () => state.adjustLiveSpeed(5),
                              ),
                              const SizedBox(height: 8),
                              _buildSpeedButton(
                                icon: LucideIcons.minus,
                                onTap: () => state.adjustLiveSpeed(-5),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Truck Diagnostic Sensors Strip
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: AppColors.cardCharcoal,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.hairline),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildSensorItem(LucideIcons.fuel, 'DIESEL', '74% (420 km)', AppColors.accent),
                      Container(width: 1, height: 28, color: AppColors.border),
                      _buildSensorItem(LucideIcons.gauge, 'TYRES', '115 PSI · OK', AppColors.blue),
                      Container(width: 1, height: 28, color: AppColors.border),
                      _buildSensorItem(LucideIcons.thermometer, 'COOLANT', '88°C · NORM', AppColors.green),
                    ],
                  ),
                ),

                // Destination & Action Panel
                Container(
                  margin: const EdgeInsets.fromLTRB(16, 4, 16, 16),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.cardCharcoal,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppColors.accent.withOpacity(0.3)),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'DESTINATION YARD',
                                style: TextStyle(
                                  color: AppColors.mutedGray,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                '${widget.trip.destCity} (${widget.trip.destCode})',
                                style: const TextStyle(
                                  color: AppColors.pureWhite,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              const Text(
                                'REMAINING DISTANCE',
                                style: TextStyle(
                                  color: AppColors.mutedGray,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                '${state.distanceRemainingKm} km (ETA: 45m)',
                                style: const TextStyle(
                                  color: AppColors.accent,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Arrived / POD Action Button
                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.accent,
                            foregroundColor: AppColors.background,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                            elevation: 0,
                          ),
                          onPressed: () {
                            showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              backgroundColor: Colors.transparent,
                              builder: (_) => PodCompletionDialog(trip: widget.trip),
                            );
                          },
                          icon: const Icon(LucideIcons.packageCheck, size: 20),
                          label: const Text(
                            'ARRIVED AT DOCK · UPLOAD POD (PROOF)',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 0.6,
                            ),
                          ),
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
    );
  }

  Widget _buildSpeedButton({required IconData icon, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          color: AppColors.cardCharcoal,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.hairline),
        ),
        child: Icon(icon, color: AppColors.pureWhite, size: 18),
      ),
    );
  }

  Widget _buildSensorItem(IconData icon, String title, String val, Color color) {
    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 12, color: color),
            const SizedBox(width: 4),
            Text(
              title,
              style: const TextStyle(
                color: AppColors.mutedGray,
                fontSize: 10,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 2),
        Text(
          val,
          style: const TextStyle(
            color: AppColors.pureWhite,
            fontSize: 11,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

class LiveHighwayNavPainter extends CustomPainter {
  final double progress;
  final double animValue;

  LiveHighwayNavPainter({required this.progress, required this.animValue});

  @override
  void paint(Canvas canvas, Size size) {
    final routePaint = Paint()
      ..color = AppColors.hairline
      ..strokeWidth = 6.0
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final p1 = Offset(size.width * 0.15, size.height * 0.85);
    final p2 = Offset(size.width * 0.50, size.height * 0.50);
    final p3 = Offset(size.width * 0.85, size.height * 0.15);

    final path = Path();
    path.moveTo(p1.dx, p1.dy);
    path.quadraticBezierTo(p2.dx + 20, p2.dy, p3.dx, p3.dy);
    canvas.drawPath(path, routePaint);

    // Truck position along the route
    final t = progress.clamp(0.0, 1.0);
    final currentPos = Offset(
      (1 - t) * (1 - t) * p1.dx + 2 * (1 - t) * t * (p2.dx + 20) + t * t * p3.dx,
      (1 - t) * (1 - t) * p1.dy + 2 * (1 - t) * t * p2.dy + t * t * p3.dy,
    );

    // Glowing Pulse Ring around truck
    final pulsePaint = Paint()
      ..color = AppColors.accent.withOpacity((1.0 - animValue) * 0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;
    canvas.drawCircle(currentPos, 14 + (animValue * 14), pulsePaint);

    // Lorry marker
    final lorryPaint = Paint()..color = AppColors.accent;
    canvas.drawCircle(currentPos, 10, lorryPaint);
    final innerPaint = Paint()..color = AppColors.background;
    canvas.drawCircle(currentPos, 4, innerPaint);
  }

  @override
  bool shouldRepaint(covariant LiveHighwayNavPainter oldDelegate) => true;
}

class HighwayGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final gridPaint = Paint()
      ..color = Colors.white.withOpacity(0.03)
      ..strokeWidth = 1.0;

    const step = 28.0;
    for (double x = 0; x < size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), gridPaint);
    }
    for (double y = 0; y < size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
