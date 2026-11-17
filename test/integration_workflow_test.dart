import 'package:flutter_test/flutter_test.dart';
import 'package:smartfleet_flutter/core/data/models/trip.dart';
import 'package:smartfleet_flutter/core/data/fleet_repository.dart';

void main() {
  setUp(() async {
    // Reset/initialize repository
    await LocalFleetRepository.instance.getTrips();
  });

  group('SmartFleet 2.0 End-to-End Workflow Integration Test', () {
    test('Complete Admin Dispatch -> Driver Accept -> In-Transit -> POD Proof Flow', () async {
      final repo = LocalFleetRepository.instance;

      final initialDelivered = await repo.getDeliveredThisMonthCount();

      // Step 1: Admin dispatches new trip to driver d2 (Manoj Chandran)
      final newTrip = await repo.createTrip(
        from: 'Kochi Port',
        to: 'Palakkad Industrial Area',
        cargo: 'Heavy Machinery Transformers',
        weightTons: 22.0,
        driverId: 'd2',
      );

      expect(newTrip.id, startsWith('TR-'));
      expect(newTrip.status, equals(TripStatus.waiting));
      expect(newTrip.driverId, equals('d2'));
      expect(newTrip.truckPlate, equals('KL 07 CD 5678'));
      expect(newTrip.from, equals('Kochi Port'));
      expect(newTrip.to, equals('Palakkad Industrial Area'));

      // Step 2: Driver d2 sees the trip in their cockpit as 'waiting'
      final driverActiveTrip = await repo.getCurrentTripForDriver('d2');
      expect(driverActiveTrip, isNotNull);
      expect(driverActiveTrip!.id, equals(newTrip.id));
      expect(driverActiveTrip.status, equals(TripStatus.waiting));

      // Step 3: Driver accepts trip
      await repo.updateTripStatus(newTrip.id, TripStatus.accepted);
      final tripAccepted = (await repo.getTrips()).firstWhere((t) => t.id == newTrip.id);
      expect(tripAccepted.status, equals(TripStatus.accepted));

      // Step 4: Driver starts the trip
      await repo.updateTripStatus(newTrip.id, TripStatus.running);
      final tripRunning = (await repo.getTrips()).firstWhere((t) => t.id == newTrip.id);
      expect(tripRunning.status, equals(TripStatus.running));

      // Step 5: Driver reaches destination and submits delivery proof
      const testOtp = '4821';
      const testPhoto = 'cargo_drop_proof_4821.jpg';
      const testSig = 'mock_receiver_sign_path';

      await repo.submitProofOfDelivery(
        newTrip.id,
        otp: testOtp,
        photoPath: testPhoto,
        signatureSvg: testSig,
      );

      // Step 6: Verify trip is delivered with attached POD
      final tripDelivered = (await repo.getTrips()).firstWhere((t) => t.id == newTrip.id);
      expect(tripDelivered.status, equals(TripStatus.delivered));
      expect(tripDelivered.podOtp, equals(testOtp));
      expect(tripDelivered.podPhotoPath, equals(testPhoto));
      expect(tripDelivered.podSignatureSvg, equals(testSig));

      // Step 7: Verify Admin metrics reflect completed delivery
      final finalDelivered = await repo.getDeliveredThisMonthCount();
      expect(finalDelivered, equals(initialDelivered + 1));
    });
  });
}
