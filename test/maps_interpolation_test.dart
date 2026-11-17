import 'package:flutter_test/flutter_test.dart';
import 'package:latlong2/latlong.dart';
import 'package:smartfleet_flutter/core/maps/marker_interpolator.dart';
import 'package:smartfleet_flutter/core/maps/osrm_routing_service.dart';

void main() {
  group('MarkerInterpolator - Heading & Angle Wrap Tests', () {
    test('Shortest angle delta across 359° to 1° boundary is +2°', () {
      final delta = MarkerInterpolator.shortestAngleDelta(359.0, 1.0);
      expect(delta, closeTo(2.0, 0.001));
    });

    test('Shortest angle delta from 1° to 359° is -2°', () {
      final delta = MarkerInterpolator.shortestAngleDelta(1.0, 359.0);
      expect(delta, closeTo(-2.0, 0.001));
    });

    test('Shortest angle delta from 10° to 350° is -20°', () {
      final delta = MarkerInterpolator.shortestAngleDelta(10.0, 350.0);
      expect(delta, closeTo(-20.0, 0.001));
    });

    test('Shortest angle delta from 350° to 10° is +20°', () {
      final delta = MarkerInterpolator.shortestAngleDelta(350.0, 10.0);
      expect(delta, closeTo(20.0, 0.001));
    });

    test('Interpolation at t=0.5 across 359° to 1° resolves to 0°/360°', () {
      final mid = MarkerInterpolator.interpolateAngle(359.0, 1.0, 0.5);
      expect(mid == 0.0 || mid == 360.0, isTrue);
    });

    test('Interpolation at t=0.5 between 90° and 180° resolves to 135°', () {
      final mid = MarkerInterpolator.interpolateAngle(90.0, 180.0, 0.5);
      expect(mid, closeTo(135.0, 0.001));
    });
  });

  group('MarkerInterpolator - LatLng Linear Interpolation Tests', () {
    test('Interpolates exactly halfway between Kochi and Thrissur', () {
      const kochi = LatLng(9.9312, 76.2673);
      const thrissur = LatLng(10.5276, 76.2144);

      final mid = MarkerInterpolator.interpolateLatLng(kochi, thrissur, 0.5);
      expect(mid.latitude, closeTo((9.9312 + 10.5276) / 2.0, 0.0001));
      expect(mid.longitude, closeTo((76.2673 + 76.2144) / 2.0, 0.0001));
    });

    test('Interpolation at t=0 returns start point, t=1 returns end point', () {
      const p1 = LatLng(10.0, 76.0);
      const p2 = LatLng(11.0, 77.0);

      final start = MarkerInterpolator.interpolateLatLng(p1, p2, 0.0);
      final end = MarkerInterpolator.interpolateLatLng(p1, p2, 1.0);

      expect(start.latitude, equals(10.0));
      expect(start.longitude, equals(76.0));
      expect(end.latitude, equals(11.0));
      expect(end.longitude, equals(77.0));
    });
  });

  group('OsrmRoutingService - Cache & Resiliency Tests', () {
    test('Second query for identical coordinates returns cached result', () async {
      final service = OsrmRoutingService.instance;
      service.clearCache();

      const origin = LatLng(9.9312, 76.2673);
      const dest = LatLng(10.5276, 76.2144);

      final res1 = await service.getRoute(origin: origin, destination: dest);
      expect(res1.points.isNotEmpty, isTrue);
      expect(res1.isFromCache, isFalse);

      final res2 = await service.getRoute(origin: origin, destination: dest);
      expect(res2.isFromCache, isTrue);
      expect(res2.points.length, equals(res1.points.length));
    });
  });
}
