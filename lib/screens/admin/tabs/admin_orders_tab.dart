import 'package:flutter/material.dart';
import 'package:smartfleet_flutter/core/components/lucide_compat.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/models/fleet_models.dart';
import '../../../core/state/fleet_state.dart';
import '../../../core/components/compact_shipment_card.dart';
import '../../../core/components/tracking_timeline.dart';
import '../dialogs/create_dispatch_dialog.dart';

class AdminOrdersTab extends StatefulWidget {
  const AdminOrdersTab({super.key});

  @override
  State<AdminOrdersTab> createState() => _AdminOrdersTabState();
}

class _AdminOrdersTabState extends State<AdminOrdersTab> {
  int _selectedFilterIndex = 0;
  String _searchQuery = '';
  final List<String> _filters = ['All', 'In Transit', 'Pending', 'Delivered'];

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: FleetState.instance,
      builder: (context, _) {
        final state = FleetState.instance;

        final filteredTrips = state.trips.where((t) {
          if (_selectedFilterIndex == 1 && t.status != TripStatus.active) return false;
          if (_selectedFilterIndex == 2 && t.status != TripStatus.assigned && t.status != TripStatus.pending) return false;
          if (_selectedFilterIndex == 3 && t.status != TripStatus.completed) return false;
          if (_searchQuery.isNotEmpty) {
            final q = _searchQuery.toLowerCase();
            return t.tripNumber.toLowerCase().contains(q) ||
                t.originCity.toLowerCase().contains(q) ||
                t.destCity.toLowerCase().contains(q) ||
                t.vehiclePlate.toLowerCase().contains(q) ||
                t.cargoTitle.toLowerCase().contains(q);
          }
          return true;
        }).toList();

        return Scaffold(
          backgroundColor: AppColors.midnightBlack,
          appBar: AppBar(
            backgroundColor: AppColors.midnightBlack,
            elevation: 0,
            title: const Text(
              'Orders & Shipments',
              style: TextStyle(
                color: AppColors.pureWhite,
                fontSize: 18,
                fontWeight: FontWeight.w900,
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(LucideIcons.plus, color: AppColors.accent),
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    builder: (_) => const CreateDispatchDialog(),
                  );
                },
              ),
            ],
          ),
          body: Column(
            children: [
              // Search Input
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                child: Container(
                  height: 44,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: AppColors.cardCharcoal,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.hairline),
                  ),
                  child: Row(
                    children: [
                      const Icon(LucideIcons.search, size: 16, color: AppColors.mutedGray),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextField(
                          onChanged: (val) => setState(() => _searchQuery = val),
                          style: const TextStyle(color: AppColors.pureWhite, fontSize: 13),
                          decoration: const InputDecoration(
                            hintText: 'Search shipment #, hub, or truck...',
                            hintStyle: TextStyle(color: AppColors.darkSubtext, fontSize: 13),
                            border: InputBorder.none,
                            isDense: true,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Filter Chips
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: List.generate(_filters.length, (idx) {
                      final isSelected = _selectedFilterIndex == idx;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: GestureDetector(
                          onTap: () => setState(() => _selectedFilterIndex = idx),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 180),
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                            decoration: BoxDecoration(
                              color: isSelected ? AppColors.accent : AppColors.cardCharcoal,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: isSelected ? AppColors.accent : AppColors.hairline),
                            ),
                            child: Text(
                              _filters[idx],
                              style: TextStyle(
                                color: isSelected ? AppColors.midnightBlack : AppColors.mutedGray,
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ),
              ),

              // Shipments List
              Expanded(
                child: filteredTrips.isEmpty
                    ? const Center(
                        child: Text(
                          'No shipments found in this view',
                          style: TextStyle(color: AppColors.mutedGray),
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                        itemCount: filteredTrips.length,
                        itemBuilder: (context, index) {
                          final trip = filteredTrips[index];
                          return CompactShipmentCard(
                            trip: trip,
                            onTap: () {
                              showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                backgroundColor: Colors.transparent,
                                builder: (_) => ShipmentTrackingDetailSheet(trip: trip),
                              );
                            },
                          );
                        },
                      ),
              ),
              const SizedBox(height: 80),
            ],
          ),
        );
      },
    );
  }
}
