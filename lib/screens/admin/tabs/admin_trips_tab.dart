import "package:flutter/material.dart";
import "../../../core/design/tokens/app_colors.dart";
import "../../../core/design/tokens/app_typography.dart";
import "../../../core/design/tokens/app_spacing.dart";
import "../../../core/design/components/status_chip.dart";
import "../../../core/design/components/trip_card.dart";
import "../../../core/data/models/trip.dart";
import "../../../core/data/fleet_repository.dart";
import "../../../l10n/app_localizations.dart";
import "../trip_detail_screen.dart";

class AdminTripsTab extends StatefulWidget {
  const AdminTripsTab({super.key});

  @override
  State<AdminTripsTab> createState() => _AdminTripsTabState();
}

class _AdminTripsTabState extends State<AdminTripsTab> {
  String _searchQuery = "";
  TripStatus? _selectedStatusFilter;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = AppLocalizations.of(context);

    return StreamBuilder<List<Trip>>(
      stream: LocalFleetRepository.instance.watchTrips(),
      builder: (context, snapshot) {
        final allTrips = snapshot.data ?? [];

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
            // SEARCH FIELD (Short & clean placeholder)
            TextField(
              decoration: InputDecoration(
                hintText: l10n.searchTripsHint,
                hintStyle: AppTypography.body(colors.textSecondary),
                prefixIcon: Icon(Icons.search_rounded, color: colors.textSecondary, size: 24),
                filled: true,
                fillColor: colors.surface,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
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
                  borderSide: BorderSide(color: colors.brand, width: 2.0),
                ),
              ),
              onChanged: (val) => setState(() => _searchQuery = val),
            ),

            const SizedBox(height: 16),

            // HORIZONTALLY SCROLLABLE FILTER CHIPS (Never clipped)
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              clipBehavior: Clip.none,
              child: Row(
                children: [
                  _buildFilterChip(
                    context,
                    label: l10n.filterAll,
                    isSelected: _selectedStatusFilter == null,
                    onTap: () => setState(() => _selectedStatusFilter = null),
                  ),
                  const SizedBox(width: 8),
                  _buildFilterChip(
                    context,
                    label: l10n.filterRunning,
                    isSelected: _selectedStatusFilter == TripStatus.running,
                    onTap: () => setState(() => _selectedStatusFilter = TripStatus.running),
                  ),
                  const SizedBox(width: 8),
                  _buildFilterChip(
                    context,
                    label: l10n.filterWaiting,
                    isSelected: _selectedStatusFilter == TripStatus.waiting,
                    onTap: () => setState(() => _selectedStatusFilter = TripStatus.waiting),
                  ),
                  const SizedBox(width: 8),
                  _buildFilterChip(
                    context,
                    label: l10n.filterDelivered,
                    isSelected: _selectedStatusFilter == TripStatus.delivered,
                    onTap: () => setState(() => _selectedStatusFilter = TripStatus.delivered),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // TRIPS LIST
            if (filteredTrips.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 40),
                child: Text(
                  "No trips match your filter",
                  style: AppTypography.body(colors.textSecondary),
                  textAlign: TextAlign.center,
                ),
              )
            else
              ...filteredTrips.map((trip) {
                ChipStatusType statusType;
                String statusLabel;
                switch (trip.status) {
                  case TripStatus.waiting:
                    statusType = ChipStatusType.waiting;
                    statusLabel = l10n.statusWaiting;
                    break;
                  case TripStatus.accepted:
                  case TripStatus.running:
                    statusType = ChipStatusType.running;
                    statusLabel = l10n.statusRunning;
                    break;
                  case TripStatus.delivered:
                    statusType = ChipStatusType.success;
                    statusLabel = l10n.statusDelivered;
                    break;
                }

                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: TripCard(
                    id: trip.id,
                    from: trip.from,
                    to: trip.to,
                    cargo: trip.cargo,
                    weightTons: trip.weightTons,
                    truckPlate: trip.truckPlate,
                    statusType: statusType,
                    statusLabel: statusLabel,
                    progressPercent: trip.progressPercent,
                    distanceDoneText: "${trip.distanceDoneKm.toStringAsFixed(1)} of ${trip.distanceKm.toStringAsFixed(0)} km done",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => TripDetailScreen(tripId: trip.id),
                        ),
                      );
                    },
                  ),
                );
              }),
          ],
        );
      },
    );
  }

  Widget _buildFilterChip(
    BuildContext context, {
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    final colors = context.colors;

    return InkWell(
      onTap: onTap,
      borderRadius: AppSpacing.chipBorderRadius,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? colors.brand : colors.surface,
          borderRadius: AppSpacing.chipBorderRadius,
          border: Border.all(
            color: isSelected ? colors.brand : colors.border,
            width: 1.5,
          ),
        ),
        child: Text(
          label,
          style: AppTypography.label(
            isSelected ? colors.onBrand : colors.text,
          ),
        ),
      ),
    );
  }
}
