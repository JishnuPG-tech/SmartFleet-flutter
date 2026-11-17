import 'package:flutter/material.dart';
import 'package:smartfleet_flutter/core/components/lucide_compat.dart';
import '../../../core/components/trip_ticket_card.dart';
import '../../../core/models/fleet_models.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/state/fleet_state.dart';
import '../../driver/live_tracking_screen.dart';

class TripsTab extends StatefulWidget {
  const TripsTab({super.key});

  @override
  State<TripsTab> createState() => _TripsTabState();
}

class _TripsTabState extends State<TripsTab> {
  String _selectedFilter = 'ALL';
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: FleetState.instance,
      builder: (context, _) {
        final trips = FleetState.instance.trips;
        final filteredTrips = trips.where((t) {
          if (_selectedFilter == 'ACTIVE' && t.status != TripStatus.active) return false;
          if (_selectedFilter == 'ASSIGNED' && t.status != TripStatus.assigned) return false;
          if (_selectedFilter == 'COMPLETED' && t.status != TripStatus.completed) return false;
          if (_searchQuery.isNotEmpty) {
            final q = _searchQuery.toLowerCase();
            final match = t.tripNumber.toLowerCase().contains(q) ||
                t.originCity.toLowerCase().contains(q) ||
                t.destCity.toLowerCase().contains(q) ||
                t.driverName.toLowerCase().contains(q) ||
                t.vehiclePlate.toLowerCase().contains(q);
            if (!match) return false;
          }
          return true;
        }).toList();

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'DISPATCH & TRIPS',
                style: TextStyle(
                  color: AppColors.acidLime,
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 2),
              const Text(
                'Freight Boarding Passes',
                style: TextStyle(
                  color: AppColors.pureWhite,
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 14),
              // Search Input
              Container(
                height: 48,
                padding: const EdgeInsets.symmetric(horizontal: 14),
                decoration: BoxDecoration(
                  color: AppColors.cardCharcoal,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.hairline, width: 0.8),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.search, size: 20, color: AppColors.mutedGray),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        onChanged: (val) => setState(() => _searchQuery = val),
                        style: const TextStyle(color: AppColors.pureWhite, fontSize: 13),
                        decoration: const InputDecoration(
                          hintText: 'Search by trip #, city, or plate...',
                          hintStyle: TextStyle(color: AppColors.darkSubtext, fontSize: 13),
                          border: InputBorder.none,
                          isDense: true,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              // Filter Tabs
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: ['ALL', 'ACTIVE', 'ASSIGNED', 'COMPLETED'].map((filter) {
                    final isSelected = _selectedFilter == filter;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: GestureDetector(
                        onTap: () => setState(() => _selectedFilter = filter),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: isSelected ? AppColors.acidLime : AppColors.cardCharcoal,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: isSelected ? AppColors.acidLime : AppColors.hairline,
                              width: 0.8,
                            ),
                          ),
                          child: Text(
                            filter,
                            style: TextStyle(
                              color: isSelected ? AppColors.midnightBlack : AppColors.mutedGray,
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 16),
              // Trips List
              Expanded(
                child: filteredTrips.isEmpty
                    ? const Center(
                        child: Text(
                          'No trips matching filter',
                          style: TextStyle(color: AppColors.mutedGray),
                        ),
                      )
                    : ListView.builder(
                        itemCount: filteredTrips.length,
                        padding: const EdgeInsets.only(bottom: 80),
                        itemBuilder: (context, index) {
                          final trip = filteredTrips[index];
                          return TripTicketCard(
                            trip: trip,
                            onTap: () => _showTripDetails(context, trip),
                          );
                        },
                      ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showTripDetails(BuildContext context, Trip trip) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.cardCharcoal,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
              const SizedBox(height: 18),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    trip.tripNumber,
                    style: const TextStyle(
                      color: AppColors.pureWhite,
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  Text(
                    trip.eta,
                    style: const TextStyle(
                      color: AppColors.acidLime,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Text(
                '${trip.originCity} (${trip.originCode})  ➔  ${trip.destCity} (${trip.destCode})',
                style: const TextStyle(color: AppColors.mutedGray, fontSize: 14),
              ),
              const SizedBox(height: 18),
              _buildDetailRow('Cargo Description', trip.cargoTitle),
              _buildDetailRow('Payload Weight', trip.cargoWeight),
              _buildDetailRow('Assigned Driver', trip.driverName),
              _buildDetailRow('Vehicle Plate', trip.vehiclePlate),
              _buildDetailRow('Scheduled Time', trip.scheduledDate),
              const SizedBox(height: 20),

              // Live Tracking Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => LiveTrackingScreen(trip: trip),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.acidLime,
                    foregroundColor: AppColors.midnightBlack,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  icon: const Icon(LucideIcons.navigation, size: 18),
                  label: const Text(
                    'TRACK LIVE LORRY ON NH-66',
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 13,
                      letterSpacing: 0.6,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: AppColors.mutedGray, fontSize: 13)),
          Text(value, style: const TextStyle(color: AppColors.pureWhite, fontSize: 13, fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }
}
