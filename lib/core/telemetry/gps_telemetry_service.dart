import "dart:async";
import "package:flutter/foundation.dart";
import "../data/api_client.dart";

class GpsBreadcrumb {
  final double latitude;
  final double longitude;
  final double heading;
  final double speedKmh;
  final DateTime timestamp;

  const GpsBreadcrumb({
    required this.latitude,
    required this.longitude,
    required this.heading,
    required this.speedKmh,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() => {
    "latitude": latitude,
    "longitude": longitude,
    "heading": heading,
    "speed_kmh": speedKmh,
    "timestamp": timestamp.toIso8601String(),
  };
}

class GpsTelemetryService extends ChangeNotifier {
  static final GpsTelemetryService instance = GpsTelemetryService._();
  GpsTelemetryService._();

  bool _isTracking = false;
  bool get isTracking => _isTracking;

  String? _activeTripId;
  String? get activeTripId => _activeTripId;

  String? _activeTruckPlate;
  String? get activeTruckPlate => _activeTruckPlate;

  double _currentLat = 9.9312;
  double get currentLat => _currentLat;

  double _currentLng = 76.2673;
  double get currentLng => _currentLng;

  double _currentHeading = 0.0;
  double get currentHeading => _currentHeading;

  double _currentSpeedKmh = 0.0;
  double get currentSpeedKmh => _currentSpeedKmh;

  DateTime? _lastPingTime;
  DateTime? get lastPingTime => _lastPingTime;

  Timer? _telemetryTimer;
  final List<GpsBreadcrumb> _breadcrumbBuffer = [];

  // Start telemetry loop for an active driver trip
  void startTracking({
    required String tripId,
    required String truckPlate,
    double initialLat = 9.9312,
    double initialLng = 76.2673,
  }) {
    _activeTripId = tripId;
    _activeTruckPlate = truckPlate;
    _currentLat = initialLat;
    _currentLng = initialLng;
    _isTracking = true;

    _telemetryTimer?.cancel();
    // 5-second interval adaptive telemetry transmission
    _telemetryTimer = Timer.periodic(const Duration(seconds: 5), (_) => _onTelemetryTick());
    _onTelemetryTick();
    notifyListeners();
  }

  void stopTracking() {
    _isTracking = false;
    _activeTripId = null;
    _telemetryTimer?.cancel();
    _telemetryTimer = null;
    notifyListeners();
  }

  void updatePosition({
    required double lat,
    required double lng,
    double heading = 0.0,
    double speedKmh = 45.0,
  }) {
    _currentLat = lat;
    _currentLng = lng;
    _currentHeading = heading;
    _currentSpeedKmh = speedKmh;
    notifyListeners();
  }

  Future<void> _onTelemetryTick() async {
    if (!_isTracking || _activeTruckPlate == null) return;

    final now = DateTime.now();
    _lastPingTime = now;

    final breadcrumb = GpsBreadcrumb(
      latitude: _currentLat,
      longitude: _currentLng,
      heading: _currentHeading,
      speedKmh: _currentSpeedKmh,
      timestamp: now,
    );
    _breadcrumbBuffer.add(breadcrumb);

    final success = await ApiClient.instance.sendTelemetryPing(
      truckPlate: _activeTruckPlate!,
      tripId: _activeTripId,
      latitude: _currentLat,
      longitude: _currentLng,
      heading: _currentHeading,
      speedKmh: _currentSpeedKmh,
      batteryLevel: 92,
    );

    if (success) {
      _breadcrumbBuffer.clear();
    } else {
      // Keep in buffer for next flush (max 50 points to prevent memory overflow)
      if (_breadcrumbBuffer.length > 50) {
        _breadcrumbBuffer.removeAt(0);
      }
    }

    notifyListeners();
  }
}
