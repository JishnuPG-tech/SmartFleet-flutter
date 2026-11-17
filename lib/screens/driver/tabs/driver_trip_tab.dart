import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:smartfleet_flutter/core/components/status_chip.dart';
import 'package:smartfleet_flutter/core/data/models/trip.dart';
import 'package:smartfleet_flutter/core/data/fleet_repository.dart';
import 'package:smartfleet_flutter/core/theme/app_theme.dart';
import 'package:smartfleet_flutter/l10n/app_localizations.dart';
import 'package:smartfleet_flutter/screens/driver/delivery_proof_flow.dart';

class DriverTripTab extends StatefulWidget {
  final String driverId;

  const DriverTripTab({super.key, required this.driverId});

  @override
  State<DriverTripTab> createState() => _DriverTripTabState();
}

class _DriverTripTabState extends State<DriverTripTab> {
  Future<void> _launchGoogleMaps(String destination) async {
    final query = Uri.encodeComponent(destination);
    final url = Uri.parse('https://www.google.com/maps/dir/?api=1&destination=$query');
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not open Google Maps')),
        );
      }
    }
  }

  Future<void> _callOffice() async {
    final uri = Uri.parse('tel:+919847123456');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  void _showBreakdownDialog(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.background,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: AppColors.statusProblemText, width: 2),
        ),
        title: Row(
          children: [
            const Icon(Icons.warning, color: AppColors.statusProblemText, size: 28),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                l10n.confirmBreakdownTitle,
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.statusProblemText),
              ),
            ),
          ],
        ),
        content: Text(
          l10n.confirmBreakdownMessage,
          style: const TextStyle(fontSize: 18, color: AppColors.textPrimary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(l10n.btnCancel, style: const TextStyle(fontSize: 18)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.statusProblemText,
              foregroundColor: Colors.white,
              minimumSize: const Size(140, 50),
            ),
            onPressed: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  backgroundColor: AppColors.statusProblemText,
                  content: Text('Breakdown alert sent to fleet office!', style: TextStyle(fontSize: 16)),
                ),
              );
            },
            child: Text(l10n.btnConfirm, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return StreamBuilder<List<Trip>>(
      stream: LocalFleetRepository.instance.watchTrips(),
      builder: (context, snapshot) {
        final trips = snapshot.data ?? [];
        Trip? activeTrip;
        try {
          activeTrip = trips.firstWhere(
            (t) => t.driverId == widget.driverId && t.status != TripStatus.delivered,
          );
        } catch (_) {
          activeTrip = null;
        }

        // CALM EMPTY STATE
        if (activeTrip == null) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceCard,
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.border, width: 2),
                    ),
                    child: const Icon(Icons.local_shipping_outlined, size: 72, color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    l10n.noTripTitle,
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    l10n.noTripSubtitle,
                    style: const TextStyle(
                      fontSize: 18,
                      color: AppColors.textSecondary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 36),
                  ElevatedButton.icon(
                    onPressed: _callOffice,
                    icon: const Icon(Icons.phone),
                    label: Text(l10n.btnCallOffice),
                  ),
                ],
              ),
            ),
          );
        }

        // ACTIVE TRIP CARD & WORKFLOW
        return SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header
              Text(
                '${l10n.currentTrip} (${activeTrip.id})',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 12),

              // THE SINGLE TRIP CARD
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Status Chip + Truck
                      Wrap(
                        alignment: WrapAlignment.spaceBetween,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          StatusChip.forTrip(context, activeTrip.status),
                          Text(
                            activeTrip.truckPlate,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ],
                      ),
                      const Divider(height: 28, color: AppColors.border),

                      // Two-line origin and destination (never clipped, wrapping allowed)
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Column(
                            children: [
                              Icon(Icons.trip_origin, size: 24, color: AppColors.accent),
                              SizedBox(height: 20),
                              Icon(Icons.location_on, size: 24, color: AppColors.statusProblemText),
                            ],
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  activeTrip.from,
                                  style: const TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.w800,
                                    color: AppColors.textPrimary,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.visible,
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  activeTrip.to,
                                  style: const TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.w800,
                                    color: AppColors.textPrimary,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.visible,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Cargo & Weight
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.background,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: Text(
                          '${activeTrip.cargo} · ${activeTrip.weightTons} Tons',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),
                      const SizedBox(height: 18),

                      // Progress Bar
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: LinearProgressIndicator(
                          value: activeTrip.progressPercent,
                          minHeight: 12,
                          backgroundColor: AppColors.border,
                          valueColor: const AlwaysStoppedAnimation<Color>(AppColors.accent),
                        ),
                      ),
                      const SizedBox(height: 12),

                      // One line for km done of total + remaining km
                      Wrap(
                        alignment: WrapAlignment.spaceBetween,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        spacing: 8,
                        runSpacing: 4,
                        children: [
                          Text(
                            l10n.kmDoneOfTotal(
                              activeTrip.distanceDoneKm.toStringAsFixed(1),
                              activeTrip.distanceKm.toStringAsFixed(0),
                            ),
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          Text(
                            '${(activeTrip.progressPercent * 100).toInt()}%',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              color: AppColors.accent,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),

                      // ETA line
                      if (activeTrip.status == TripStatus.running)
                        Text(
                          '${l10n.eta}: ${activeTrip.remainingHours}h ${activeTrip.remainingMinutes}m (${activeTrip.remainingKm.toStringAsFixed(1)} km)',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textSecondary,
                          ),
                        ),

                      const SizedBox(height: 16),

                      // Show Route in Google Maps button
                      OutlinedButton(
                        onPressed: () => _launchGoogleMaps(activeTrip!.to),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.map, color: AppColors.accent),
                            const SizedBox(width: 8),
                            Flexible(
                              child: Text(
                                l10n.btnShowRoute,
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // THE ONE GIANT PRIMARY BUTTON CHANGING WITH STEP
              _buildStepButton(context, activeTrip, l10n),

              const SizedBox(height: 16),

              // Under it: Full-width stacked Call Office and Help/Breakdown buttons
              OutlinedButton(
                onPressed: _callOffice,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.phone),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        l10n.btnCallOffice,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.statusProblemText,
                  foregroundColor: Colors.white,
                ),
                onPressed: () => _showBreakdownDialog(context),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.warning, color: Colors.white),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        l10n.btnHelpBreakdown,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStepButton(BuildContext context, Trip trip, AppLocalizations l10n) {
    switch (trip.status) {
      case TripStatus.waiting:
        return Column(
          children: [
            ElevatedButton(
              onPressed: () => LocalFleetRepository.instance.updateTripStatus(trip.id, TripStatus.accepted),
              child: Text(l10n.btnAcceptTrip),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () {
                // Rejecting trip
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Trip rejected')),
                );
              },
              child: Text(
                l10n.btnRejectTrip,
                style: const TextStyle(color: AppColors.statusProblemText),
              ),
            ),
          ],
        );

      case TripStatus.accepted:
        return ElevatedButton(
          onPressed: () => LocalFleetRepository.instance.updateTripStatus(trip.id, TripStatus.running),
          child: Text(l10n.btnStartTrip),
        );

      case TripStatus.running:
        return ElevatedButton(
          onPressed: () {
            // Reached destination bay -> open proof flow
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => DeliveryProofFlow(tripId: trip.id)),
            );
          },
          child: Text(l10n.btnReached),
        );

      case TripStatus.delivered:
        return const SizedBox.shrink();
    }
  }
}
