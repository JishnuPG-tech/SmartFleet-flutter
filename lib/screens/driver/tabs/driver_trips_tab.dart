import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/models/fleet_models.dart';
import '../../../core/components/status_badge.dart';
import '../../../core/state/fleet_state.dart';

class DriverTripsTab extends StatefulWidget {
  const DriverTripsTab({super.key});

  @override
  State<DriverTripsTab> createState() => _DriverTripsTabState();
}

class _DriverTripsTabState extends State<DriverTripsTab> {
  int _selectedFilterIndex = 0;
  final List<String> _filters = ['All Dispatches', 'New Offers', 'Active'];

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: FleetState.instance,
      builder: (context, _) {
        final state = FleetState.instance;

        List<Trip> displayTrips = state.trips;
        if (_selectedFilterIndex == 1) {
          displayTrips = state.trips.where((t) => t.status == TripStatus.assigned || t.status == TripStatus.pending).toList();
        } else if (_selectedFilterIndex == 2) {
          displayTrips = state.trips.where((t) => t.status == TripStatus.active).toList();
        }

        return Scaffold(
          backgroundColor: AppColors.background,
          body: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 14, 16, 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Trip Dispatches',
                        style: TextStyle(
                          color: AppColors.pureWhite,
                          fontSize: 22,
                          fontWeight: FontWeight.w900,
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: 2),
                      const Text(
                        'Review incoming cargo offers and active waybills',
                        style: TextStyle(
                          color: AppColors.mutedGray,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 14),

                      // Filter Pills
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: List.generate(_filters.length, (index) {
                            final isSelected = _selectedFilterIndex == index;
                            return Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _selectedFilterIndex = index;
                                  });
                                },
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                                  decoration: BoxDecoration(
                                    color: isSelected ? AppColors.accent : AppColors.cardCharcoal,
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      color: isSelected ? AppColors.accent : AppColors.hairline,
                                    ),
                                  ),
                                  child: Text(
                                    _filters[index],
                                    style: TextStyle(
                                      color: isSelected ? AppColors.midnightBlack : AppColors.mutedGray,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }),
                        ),
                      ),
                    ],
                  ),
                ),

                // Trips List
                Expanded(
                  child: displayTrips.isEmpty
                      ? const Center(
                          child: Text(
                            'No dispatches found in this category',
                            style: TextStyle(color: AppColors.mutedGray),
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          itemCount: displayTrips.length,
                          itemBuilder: (context, index) {
                            final trip = displayTrips[index];
                            if (trip.status == TripStatus.assigned || trip.status == TripStatus.pending) {
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 14),
                                child: _buildPendingOfferCard(trip),
                              );
                            }
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 14),
                              child: _buildStandardTripCard(trip),
                            );
                          },
                        ),
                ),
                const SizedBox(height: 80),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildPendingOfferCard(Trip trip) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardCharcoal,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.amberWarning.withOpacity(0.5)),
        boxShadow: [
          BoxShadow(
            color: AppColors.amberWarning.withOpacity(0.08),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Ribbon
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
            decoration: BoxDecoration(
              color: AppColors.amberWarning.withOpacity(0.12),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(17),
                topRight: Radius.circular(17),
              ),
            ),
            child: Row(
              children: [
                const Icon(LucideIcons.bellRing, color: AppColors.amberWarning, size: 14),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'NEW DISPATCH OFFER · ${trip.tripNumber}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: AppColors.amberWarning,
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.6,
                    ),
                  ),
                ),
                const Text(
                  '₹4,800 Bata',
                  style: TextStyle(
                    color: AppColors.accent,
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: 80,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            trip.originCode,
                            style: const TextStyle(
                              color: AppColors.pureWhite,
                              fontSize: 22,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          Text(
                            trip.originCity,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(color: AppColors.mutedGray, fontSize: 11),
                          ),
                        ],
                      ),
                    ),
                    const Icon(LucideIcons.arrowRight, color: AppColors.accent, size: 18),
                    SizedBox(
                      width: 80,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            trip.destCode,
                            style: const TextStyle(
                              color: AppColors.pureWhite,
                              fontSize: 22,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          Text(
                            trip.destCity,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(color: AppColors.mutedGray, fontSize: 11),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Container(height: 1, color: AppColors.hairline),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Cargo: ${trip.cargoTitle} (${trip.cargoWeight})',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(color: AppColors.mutedGray, fontSize: 11),
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(LucideIcons.clock, size: 12, color: AppColors.darkSubtext),
                        SizedBox(width: 4),
                        Text(
                          'Today',
                          style: TextStyle(
                            color: AppColors.pureWhite,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Accept & Decline buttons
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: AppColors.hairline),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        onPressed: () {
                          FleetState.instance.declineTrip(trip.id);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Offer declined')),
                          );
                        },
                        child: const Text('DECLINE', style: TextStyle(color: AppColors.mutedGray, fontWeight: FontWeight.w700)),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      flex: 2,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.accent,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        onPressed: () {
                          FleetState.instance.acceptTrip(trip.id);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              backgroundColor: AppColors.cardCharcoal,
                              content: Text('Trip ${trip.tripNumber} Accepted! Added to Active Cockpit.', style: const TextStyle(color: AppColors.accent)),
                            ),
                          );
                        },
                        child: const Text('ACCEPT TRIP OFFER', style: TextStyle(color: AppColors.midnightBlack, fontWeight: FontWeight.w900)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStandardTripCard(Trip trip) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardCharcoal,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.hairline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                trip.tripNumber,
                style: const TextStyle(
                  color: AppColors.accent,
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                  fontFamily: 'monospace',
                ),
              ),
              StatusBadge(status: trip.status),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Text(
                '${trip.originCode} → ${trip.destCode}',
                style: const TextStyle(
                  color: AppColors.pureWhite,
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const Spacer(),
              Text(
                trip.cargoWeight,
                style: const TextStyle(
                  color: AppColors.mutedGray,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            '${trip.originCity} to ${trip.destCity} · ${trip.cargoTitle}',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: AppColors.darkSubtext, fontSize: 11),
          ),
          const SizedBox(height: 12),
          Container(height: 1, color: AppColors.hairline),
          const SizedBox(height: 10),
          Row(
            children: [
              const Icon(LucideIcons.calendarClock, size: 14, color: AppColors.accent),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  trip.scheduledDate,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: AppColors.pureWhite,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const Icon(LucideIcons.chevronRight, size: 16, color: AppColors.mutedGray),
            ],
          ),
        ],
      ),
    );
  }
}
