import 'package:flutter/material.dart';
import 'package:smartfleet_flutter/core/components/status_chip.dart';
import 'package:smartfleet_flutter/core/data/models/trip.dart';
import 'package:smartfleet_flutter/core/data/fleet_repository.dart';
import 'package:smartfleet_flutter/core/theme/app_theme.dart';
import 'package:smartfleet_flutter/l10n/app_localizations.dart';
import 'package:smartfleet_flutter/screens/admin/trip_detail_screen.dart';

class AdminTripsTab extends StatefulWidget {
  const AdminTripsTab({super.key});

  @override
  State<AdminTripsTab> createState() => _AdminTripsTabState();
}

class _AdminTripsTabState extends State<AdminTripsTab> {
  String _searchQuery = '';
  TripStatus? _selectedStatusFilter; // null means 'All'

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return StreamBuilder<List<Trip>>(
      stream: LocalFleetRepository.instance.watchTrips(),
      builder: (context, snapshot) {
        final allTrips = snapshot.data ?? [];

        // Apply search filter and status filter
        final filteredTrips = allTrips.where((trip) {
          if (_selectedStatusFilter != null && trip.status != _selectedStatusFilter) {
            return false;
          }
          if (_searchQuery.trim().isNotEmpty) {
            final q = _searchQuery.toLowerCase();
            final matchesId = trip.id.toLowerCase().contains(q);
            final matchesRoute = trip.from.toLowerCase().contains(q) || trip.to.toLowerCase().contains(q);
            final matchesTruck = trip.truckPlate.toLowerCase().contains(q);
            final matchesCargo = trip.cargo.toLowerCase().contains(q);
            return matchesId || matchesRoute || matchesTruck || matchesCargo;
          }
          return true;
        }).toList();

        return ListView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
          children: [
            // SEARCH FIELD
            TextField(
              decoration: InputDecoration(
                hintText: l10n.searchTripsHint,
                prefixIcon: const Icon(Icons.search, color: AppColors.textSecondary, size: 26),
                filled: true,
                fillColor: AppColors.surfaceCard,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(color: AppColors.border, width: 1.5),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(color: AppColors.border, width: 1.5),
                ),
              ),
              onChanged: (val) => setState(() => _searchQuery = val),
            ),

            const SizedBox(height: 16),

            // FILTER CHIPS (All, Running, Waiting, Delivered)
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildFilterChip(
                    label: l10n.filterAll,
                    isSelected: _selectedStatusFilter == null,
                    onTap: () => setState(() => _selectedStatusFilter = null),
                  ),
                  const SizedBox(width: 8),
                  _buildFilterChip(
                    label: l10n.filterRunning,
                    isSelected: _selectedStatusFilter == TripStatus.running,
                    onTap: () => setState(() => _selectedStatusFilter = TripStatus.running),
                  ),
                  const SizedBox(width: 8),
                  _buildFilterChip(
                    label: l10n.filterWaiting,
                    isSelected: _selectedStatusFilter == TripStatus.waiting,
                    onTap: () => setState(() => _selectedStatusFilter = TripStatus.waiting),
                  ),
                  const SizedBox(width: 8),
                  _buildFilterChip(
                    label: l10n.filterDelivered,
                    isSelected: _selectedStatusFilter == TripStatus.delivered,
                    onTap: () => setState(() => _selectedStatusFilter = TripStatus.delivered),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // TRIP CARDS LIST
            if (filteredTrips.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 40),
                child: Center(
                  child: Text(
                    'No trips found',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
              )
            else
              ...filteredTrips.map((trip) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 14),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(14),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => TripDetailScreen(tripId: trip.id),
                        ),
                      );
                    },
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(18),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // ID + Status Chip
                            Wrap(
                              alignment: WrapAlignment.spaceBetween,
                              crossAxisAlignment: WrapCrossAlignment.center,
                              spacing: 8,
                              runSpacing: 8,
                              children: [
                                Text(
                                  trip.id,
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w900,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                                StatusChip.forTrip(context, trip.status),
                              ],
                            ),
                            const Divider(height: 24, color: AppColors.border),

                            // Route
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Column(
                                  children: [
                                    Icon(Icons.trip_origin, size: 20, color: AppColors.accent),
                                    SizedBox(height: 14),
                                    Icon(Icons.location_on, size: 20, color: AppColors.statusProblemText),
                                  ],
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        trip.from,
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w800,
                                          color: AppColors.textPrimary,
                                        ),
                                        maxLines: 2,
                                      ),
                                      const SizedBox(height: 12),
                                      Text(
                                        trip.to,
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w800,
                                          color: AppColors.textPrimary,
                                        ),
                                        maxLines: 2,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 14),

                            // Truck & Cargo
                            Text(
                              '${trip.truckPlate} · ${trip.cargo} (${trip.weightTons}T)',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textSecondary,
                              ),
                            ),

                            const SizedBox(height: 12),

                            // Progress Bar
                            ClipRRect(
                              borderRadius: BorderRadius.circular(6),
                              child: LinearProgressIndicator(
                                value: trip.progressPercent,
                                minHeight: 8,
                                backgroundColor: AppColors.border,
                                valueColor: const AlwaysStoppedAnimation<Color>(AppColors.accent),
                              ),
                            ),
                            const SizedBox(height: 8),

                            // Progress metric & Remaining
                            Wrap(
                              alignment: WrapAlignment.spaceBetween,
                              spacing: 8,
                              runSpacing: 4,
                              children: [
                                Text(
                                  l10n.kmDoneOfTotal(
                                    trip.distanceDoneKm.toStringAsFixed(1),
                                    trip.distanceKm.toStringAsFixed(0),
                                  ),
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                                Text(
                                  '${(trip.progressPercent * 100).toInt()}%',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w800,
                                    color: AppColors.accent,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }),
          ],
        );
      },
    );
  }

  Widget _buildFilterChip({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.accent : AppColors.surfaceCard,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppColors.accent : AppColors.border,
            width: 1.5,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 16,
            fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
            color: isSelected ? Colors.white : AppColors.textPrimary,
          ),
        ),
      ),
    );
  }
}
