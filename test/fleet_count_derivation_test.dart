import "package:flutter_test/flutter_test.dart";
import "package:smartfleet_flutter/core/data/models/truck.dart";
import "package:smartfleet_flutter/core/data/models/trip.dart";
import "package:smartfleet_flutter/core/data/seed_data.dart";

/// Unified derivation logic shared between Home Dashboard and Fleet Trucks Tab
int computeFreeTrucksCount(List<Truck> trucks, List<Trip> trips) {
  final activeTruckPlates = trips
      .where((t) => t.status != TripStatus.delivered)
      .map((t) => t.truckPlate)
      .toSet();
  return trucks.where((t) => t.status != TruckStatus.inWorkshop && !activeTruckPlates.contains(t.plate)).length;
}

TruckStatus computeEffectiveTruckStatus(Truck truck, List<Trip> trips) {
  if (truck.status == TruckStatus.inWorkshop) return TruckStatus.inWorkshop;
  final activeTruckPlates = trips
      .where((t) => t.status != TripStatus.delivered)
      .map((t) => t.truckPlate)
      .toSet();
  if (activeTruckPlates.contains(truck.plate) || truck.status == TruckStatus.onTrip) {
    return TruckStatus.onTrip;
  }
  return TruckStatus.available;
}

void main() {
  group("Fleet Count & Status Derivation - Parity Tests", () {
    test("Initial Seed Data: Home count strictly matches Trucks Tab available count", () {
      final trucks = SeedData.trucks;
      final trips = SeedData.trips;

      final homeAvailableCount = computeFreeTrucksCount(trucks, trips);
      final fleetTabAvailableCount = trucks
          .where((t) => computeEffectiveTruckStatus(t, trips) == TruckStatus.available)
          .length;

      // Both must match exactly: 1 free truck (KL 09 EF 9012)
      // Because KL 13 GH 3456 is assigned to waiting trip TR-1028!
      expect(homeAvailableCount, equals(1));
      expect(fleetTabAvailableCount, equals(1));
      expect(homeAvailableCount, equals(fleetTabAvailableCount));
    });

    test("Individual truck statuses in Trucks Tab are derived accurately", () {
      final trucks = SeedData.trucks;
      final trips = SeedData.trips;

      final statusMap = {
        for (final t in trucks) t.plate: computeEffectiveTruckStatus(t, trips)
      };

      // Running trips
      expect(statusMap["KL 11 AB 1234"], equals(TruckStatus.onTrip));
      expect(statusMap["KL 07 CD 5678"], equals(TruckStatus.onTrip));

      // In Workshop
      expect(statusMap["KL 01 JK 7890"], equals(TruckStatus.inWorkshop));

      // Waiting trip TR-1028 reserves truck KL 13 GH 3456
      expect(statusMap["KL 13 GH 3456"], equals(TruckStatus.onTrip));

      // Delivered trip TR-1027 leaves KL 09 EF 9012 Free / Available
      expect(statusMap["KL 09 EF 9012"], equals(TruckStatus.available));
    });

    test("Delivering a trip synchronously frees the truck in both Home and Trucks tab", () {
      final trucks = SeedData.trucks;
      // Mark TR-1028 as delivered
      final updatedTrips = SeedData.trips.map((t) {
        if (t.id == "TR-1028") {
          return t.copyWith(status: TripStatus.delivered);
        }
        return t;
      }).toList();

      final homeCount = computeFreeTrucksCount(trucks, updatedTrips);
      final fleetCount = trucks
          .where((t) => computeEffectiveTruckStatus(t, updatedTrips) == TruckStatus.available)
          .length;

      // Both should now synchronously report 2 free trucks (KL 09 EF 9012 & KL 13 GH 3456)
      expect(homeCount, equals(2));
      expect(fleetCount, equals(2));
      expect(homeCount, equals(fleetCount));
    });

    test("Dispatching a new trip decrements available count in both Home and Trucks tab", () {
      final trucks = SeedData.trucks;
      // Create and dispatch new trip assigning the last free truck KL 09 EF 9012
      final newTrip = Trip(
        id: "TR-1029",
        from: "Kochi Port",
        to: "Trivandrum Bay",
        cargo: "Tiles",
        weightTons: 20.0,
        truckPlate: "KL 09 EF 9012",
        driverId: "d3",
        status: TripStatus.waiting,
        startedAt: DateTime.now(),
        distanceKm: 220.0,
        distanceDoneKm: 0.0,
        allowanceAmount: 4200,
        isPaid: false,
      );

      final updatedTrips = [newTrip, ...SeedData.trips];

      final homeCount = computeFreeTrucksCount(trucks, updatedTrips);
      final fleetCount = trucks
          .where((t) => computeEffectiveTruckStatus(t, updatedTrips) == TruckStatus.available)
          .length;

      // Both should now synchronously report 0 free trucks
      expect(homeCount, equals(0));
      expect(fleetCount, equals(0));
      expect(homeCount, equals(fleetCount));
    });
  });
}
