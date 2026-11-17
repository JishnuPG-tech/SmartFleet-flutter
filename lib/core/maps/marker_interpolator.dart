import 'package:latlong2/latlong.dart';

/// Utilities for smooth interpolation of GPS coordinates and heading angles.
class MarkerInterpolator {
  const MarkerInterpolator._();

  /// Calculates the shortest angular distance from [fromDegrees] to [toDegrees] in degrees.
  /// Result is in range [-180, 180].
  ///
  /// Examples:
  /// - shortestAngleDelta(359, 1) -> +2.0
  /// - shortestAngleDelta(1, 359) -> -2.0
  /// - shortestAngleDelta(10, 350) -> -20.0
  static double shortestAngleDelta(double fromDegrees, double toDegrees) {
    double diff = (toDegrees - fromDegrees) % 360.0;
    if (diff > 180.0) {
      diff -= 360.0;
    } else if (diff < -180.0) {
      diff += 360.0;
    }
    return diff;
  }

  /// Interpolates an angle from [fromDegrees] to [toDegrees] by fraction [t] in [0, 1]
  /// using the shortest rotational path across the 0°/360° wrap boundary.
  static double interpolateAngle(double fromDegrees, double toDegrees, double t) {
    final delta = shortestAngleDelta(fromDegrees, toDegrees);
    double result = (fromDegrees + delta * t) % 360.0;
    if (result < 0) {
      result += 360.0;
    }
    return result;
  }

  /// Linearly interpolates between two geographic coordinates [start] and [end]
  /// by fraction [t] in [0, 1].
  static LatLng interpolateLatLng(LatLng start, LatLng end, double t) {
    final lat = start.latitude + (end.latitude - start.latitude) * t;
    final lng = start.longitude + (end.longitude - start.longitude) * t;
    return LatLng(lat, lng);
  }
}
