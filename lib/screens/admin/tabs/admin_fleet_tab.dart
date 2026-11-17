import "package:flutter/material.dart";
import "../../../core/design/components/truck_card.dart";
import "../../../core/data/models/truck.dart";
import "../../../core/data/models/trip.dart";
import "../../../core/data/models/driver.dart";
import "../../../core/data/fleet_repository.dart";

class AdminFleetTab extends StatelessWidget {
  const AdminFleetTab({super.key});

  @override
  Widget build(BuildContext context) {
    
    return StreamBuilder<List<Trip>>(
      stream: LocalFleetRepository.instance.watchTrips(),
      builder: (context, tripSnap) {
        return StreamBuilder<List<Driver>>(
          stream: LocalFleetRepository.instance.watchDrivers(),
          builder: (context, driverSnap) {
            return StreamBuilder<List<Truck>>(
              stream: LocalFleetRepository.instance.watchTrucks(),
              builder: (context, truckSnap) {
                final trucks = truckSnap.data ?? [];
                final trips = tripSnap.data ?? [];
                final drivers = driverSnap.data ?? [];

                final driverMap = {for (final d in drivers) d.id: d.name};

                // Active trips reserve the truck
                final activeTruckPlates = trips
                    .where((t) => t.status != TripStatus.delivered)
                    .map((t) => t.truckPlate)
                    .toSet();

                return ListView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                  itemCount: trucks.length,
                  itemBuilder: (context, index) {
                    final truck = trucks[index];
                    final driverName = driverMap[truck.assignedDriverId];

                    TruckStatusType effectiveStatus;
                    if (truck.status == TruckStatus.inWorkshop) {
                      effectiveStatus = TruckStatusType.inWorkshop;
                    } else if (activeTruckPlates.contains(truck.plate) || truck.status == TruckStatus.onTrip) {
                      effectiveStatus = TruckStatusType.onTrip;
                    } else {
                      effectiveStatus = TruckStatusType.available;
                    }

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: TruckCard(
                        plate: truck.plate,
                        model: truck.model,
                        capacityTons: truck.capacityTons.toDouble(),
                        status: effectiveStatus,
                        driverName: driverName,
                      ),
                    );
                  },
                );
              },
            );
          },
        );
      },
    );
  }
}
