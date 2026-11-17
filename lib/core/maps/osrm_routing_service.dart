import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';

class RouteResult {
  final List<LatLng> points;
  final double distanceKm;
  final double durationMinutes;
  final bool isFromCache;
  final bool isFallback;

  const RouteResult({
    required this.points,
    required this.distanceKm,
    required this.durationMinutes,
    this.isFromCache = false,
    this.isFallback = false,
  });
}

/// Service to fetch real road polylines from Open Source Routing Machine (OSRM).
class OsrmRoutingService {
  static final OsrmRoutingService instance = OsrmRoutingService._();
  OsrmRoutingService._();

  final Map<String, RouteResult> _cache = {};

  String _cacheKey(LatLng origin, LatLng destination) {
    return '${origin.latitude.toStringAsFixed(4)},${origin.longitude.toStringAsFixed(4)}->${destination.latitude.toStringAsFixed(4)},${destination.longitude.toStringAsFixed(4)}';
  }

  /// Clears in-memory route cache.
  void clearCache() => _cache.clear();

  /// Fetches the road-following route between [origin] and [destination].
  Future<RouteResult> getRoute({
    required LatLng origin,
    required LatLng destination,
  }) async {
    final key = _cacheKey(origin, destination);
    if (_cache.containsKey(key)) {
      final cached = _cache[key]!;
      return RouteResult(
        points: cached.points,
        distanceKm: cached.distanceKm,
        durationMinutes: cached.durationMinutes,
        isFromCache: true,
        isFallback: cached.isFallback,
      );
    }

    final url = Uri.parse(
      'https://router.project-osrm.org/route/v1/driving/${origin.longitude},${origin.latitude};${destination.longitude},${destination.latitude}?overview=full&geometries=geojson',
    );

    try {
      final response = await http.get(url).timeout(const Duration(seconds: 4));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        final routes = data['routes'] as List<dynamic>?;
        if (routes != null && routes.isNotEmpty) {
          final firstRoute = routes[0] as Map<String, dynamic>;
          final geometry = firstRoute['geometry'] as Map<String, dynamic>;
          final coordinates = geometry['coordinates'] as List<dynamic>;

          final points = coordinates.map((coord) {
            final list = coord as List<dynamic>;
            return LatLng(
              (list[1] as num).toDouble(),
              (list[0] as num).toDouble(),
            );
          }).toList();

          final distanceMeters = (firstRoute['distance'] as num?)?.toDouble() ?? 0.0;
          final durationSecs = (firstRoute['duration'] as num?)?.toDouble() ?? 0.0;

          final result = RouteResult(
            points: points,
            distanceKm: distanceMeters / 1000.0,
            durationMinutes: durationSecs / 60.0,
            isFromCache: false,
            isFallback: false,
          );
          _cache[key] = result;
          return result;
        }
      }
    } catch (_) {
      // Fallback straight line if network is unavailable or times out
    }

    // Direct geometric path fallback when OSRM server is unreachable
    final fallbackResult = RouteResult(
      points: [origin, destination],
      distanceKm: const Distance().as(LengthUnit.Kilometer, origin, destination),
      durationMinutes: 0,
      isFromCache: false,
      isFallback: true,
    );
    _cache[key] = fallbackResult;
    return fallbackResult;
  }
}
