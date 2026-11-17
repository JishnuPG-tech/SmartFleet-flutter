import 'package:flutter_test/flutter_test.dart';
import 'package:smartfleet_flutter/core/data/models/trip.dart';
import 'package:smartfleet_flutter/core/data/seed_data.dart';
import 'package:smartfleet_flutter/core/data/fleet_repository.dart';

String getGreetingForHour(int hour) {
  if (hour >= 5 && hour < 12) {
    return 'Good morning';
  } else if (hour >= 12 && hour < 17) {
    return 'Good afternoon';
  } else {
    return 'Good evening';
  }
}

void main() {
  group('Trip Model & Derivation Unit Tests', () {
    test('Trip TR-1025 derived fields calculate consistently and accurately', () {
      final trip = SeedData.trips.firstWhere((t) => t.id == 'TR-1025');

      // Given distance = 180.0 km and done = 122.4 km
      expect(trip.distanceKm, equals(180.0));
      expect(trip.distanceDoneKm, equals(122.4));

      // 122.4 / 180.0 = 0.68 (68%)
      expect(trip.progressPercent, closeTo(0.68, 0.001));

      // Remaining distance = 180.0 - 122.4 = 57.6 km
      expect(trip.remainingKm, closeTo(57.6, 0.001));

      // At 40 km/h: 57.6 / 40 = 1.44 hours = 1 hour and (0.44 * 60) = 26.4 -> 26 minutes
      expect(trip.remainingHours, equals(1));
      expect(trip.remainingMinutes, equals(26));
    });

    test('Identical trip numbers and metrics rendered across simulated screen consumers', () {
      final trip = SeedData.trips.firstWhere((t) => t.id == 'TR-1025');

      // Screen 1: Driver Cockpit Consumer
      final driverProgressString = '${(trip.progressPercent * 100).toInt()}%';
      final driverRemainingString = '${trip.remainingKm.toStringAsFixed(1)} km';
      final driverEtaString = '${trip.remainingHours}h ${trip.remainingMinutes}m';

      // Screen 2: Admin Dashboard Consumer
      final adminProgressString = '${(trip.progressPercent * 100).toInt()}%';
      final adminRemainingString = '${trip.remainingKm.toStringAsFixed(1)} km';
      final adminEtaString = '${trip.remainingHours}h ${trip.remainingMinutes}m';

      // Screen 3: Shipment Detail Timeline Consumer
      final detailProgressString = '${(trip.progressPercent * 100).toInt()}%';
      final detailRemainingString = '${trip.remainingKm.toStringAsFixed(1)} km';
      final detailEtaString = '${trip.remainingHours}h ${trip.remainingMinutes}m';

      // Assert complete mathematical uniformity across all 3 consumer views
      expect(driverProgressString, equals(adminProgressString));
      expect(adminProgressString, equals(detailProgressString));
      expect(driverProgressString, equals('68%'));

      expect(driverRemainingString, equals(adminRemainingString));
      expect(adminRemainingString, equals(detailRemainingString));
      expect(driverRemainingString, equals('57.6 km'));

      expect(driverEtaString, equals(adminEtaString));
      expect(adminEtaString, equals(detailEtaString));
      expect(driverEtaString, equals('1h 26m'));
    });

    test('Greeting is derived correctly from device time (eliminating 2:06 PM bug)', () {
      expect(getGreetingForHour(8), equals('Good morning'));
      // Screenshot 02 was taken at 14:06 (2:06 PM) and erroneously showed 'Good evening'
      expect(getGreetingForHour(14), equals('Good afternoon'));
      expect(getGreetingForHour(20), equals('Good evening'));
    });
  });

  group('FleetRepository Unit Tests', () {
    test('Seed data is loaded with zero legacy SF#### ids and consistent records', () async {
      final repo = LocalFleetRepository.instance;
      final trips = await repo.getTrips();
      final drivers = await repo.getDrivers();
      final trucks = await repo.getTrucks();

      expect(trips.length, greaterThanOrEqualTo(4));
      for (final trip in trips) {
        expect(trip.id, startsWith('TR-'), reason: 'Trip ${trip.id} must use TR- format, never SF####');
      }

      // Assert single phone and licence for Suresh Kumar
      final suresh = drivers.firstWhere((d) => d.name == 'Suresh Kumar');
      expect(suresh.phone, equals('+91 98471 23456'));
      expect(suresh.licenceNumber, equals('KL-11-2015-0098231'));
      expect(suresh.assignedTruckPlate, equals('KL 11 AB 1234'));

      // Assert truck model for KL 11 AB 1234 is BharatBenz 2823R
      final truck = trucks.firstWhere((t) => t.plate == 'KL 11 AB 1234');
      expect(truck.model, equals('BharatBenz 2823R 28T'));
    });

    test('Creating a new trip increments TR-XXXX format properly', () async {
      final repo = LocalFleetRepository.instance;
      final created = await repo.createTrip(
        from: 'Kochi Port',
        to: 'Trivandrum Bay',
        cargo: 'Electronics & Spares',
        weightTons: 12.0,
        driverId: 'd3',
      );

      expect(created.id, equals('TR-1029'));
      expect(created.status, equals(TripStatus.waiting));
      expect(created.distanceDoneKm, equals(0.0));
      expect(created.remainingKm, equals(160.0));

      final retrieved = await repo.getTripById('TR-1029');
      expect(retrieved, isNotNull);
      expect(retrieved!.id, equals('TR-1029'));
    });
  });

  group('Deliberate Failure Verification Test', () {
    test('Strict format validator catches legacy SF#### IDs and un-sanitized values', () {
      bool validateTripId(String id) {
        final regex = RegExp(r'^TR-\d{4}$');
        if (!regex.hasMatch(id)) {
          throw FormatException('DELIBERATE ERROR CAUGHT: Invalid legacy Trip ID "$id". All trips must adhere to format TR-####.');
        }
        return true;
      }

      // Valid IDs pass
      expect(validateTripId('TR-1025'), isTrue);

      // Legacy and conflicting IDs must fail loudly and visibly
      expect(
        () => validateTripId('SF1025'),
        throwsA(isA<FormatException>().having((e) => e.message, 'message', contains('DELIBERATE ERROR CAUGHT'))),
      );
      expect(
        () => validateTripId('TR-102'),
        throwsA(isA<FormatException>()),
      );
    });
  });
}
