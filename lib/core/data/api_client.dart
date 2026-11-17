import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'models/trip.dart';
import 'models/truck.dart';
import 'models/driver.dart';

class ApiClient {
  static const String defaultBaseUrl = 'https://jishnupg-opencode-cli.hf.space/preview/8000/api/v1';
  static const String defaultWsUrl = 'wss://jishnupg-opencode-cli.hf.space/preview/8000/ws/v1/fleet';

  final String baseUrl;
  final String wsUrl;
  final http.Client _httpClient;

  ApiClient({
    this.baseUrl = defaultBaseUrl,
    this.wsUrl = defaultWsUrl,
    http.Client? httpClient,
  }) : _httpClient = httpClient ?? http.Client();

  // Helper headers
  Map<String, String> get _headers => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  // 1. GET TRIPS
  Future<List<Trip>> getTrips() async {
    try {
      final response = await _httpClient.get(
        Uri.parse('$baseUrl/trips'),
        headers: _headers,
      ).timeout(const Duration(seconds: 8));

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) {
          return Trip(
            id: json['id'] as String,
            from: json['origin_city'] as String? ?? 'Origin',
            to: json['dest_city'] as String? ?? 'Destination',
            cargo: json['cargo_title'] as String? ?? 'Freight Cargo',
            weightTons: (json['weight_tons'] as num?)?.toDouble() ?? 10.0,
            truckPlate: json['truck_plate'] as String? ?? 'KL 11 AB 1234',
            driverId: json['driver_id'] as String? ?? 'd1',
            status: _parseTripStatus(json['status'] as String?),
            startedAt: json['actual_started_at'] != null 
                ? DateTime.parse(json['actual_started_at']) 
                : DateTime.parse(json['scheduled_start'] as String? ?? DateTime.now().toIso8601String()),
            distanceKm: (json['total_distance_km'] as num?)?.toDouble() ?? 150.0,
            distanceDoneKm: (json['distance_done_km'] as num?)?.toDouble() ?? 0.0,
            allowanceAmount: (json['allowance_amount'] as num?)?.toInt() ?? 1500,
            isPaid: json['is_paid'] as bool? ?? false,
          );
        }).toList();
      }
    } catch (e) {
      // Offline fallback
    }
    return [];
  }

  // 2. GET TRUCKS
  Future<List<Truck>> getTrucks() async {
    try {
      final response = await _httpClient.get(
        Uri.parse('$baseUrl/trucks'),
        headers: _headers,
      ).timeout(const Duration(seconds: 8));

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) {
          final statusStr = json['status'] as String? ?? 'available';
          final status = statusStr == 'on_trip'
              ? TruckStatus.onTrip
              : (statusStr == 'in_workshop' ? TruckStatus.inWorkshop : TruckStatus.available);

          return Truck(
            plate: json['plate'] as String,
            model: json['model'] as String? ?? 'Truck',
            capacityTons: (json['capacity_tons'] as num?)?.toInt() ?? 25,
            assignedDriverId: json['assigned_driver_id'] as String? ?? '',
            status: status,
            latitude: (json['last_latitude'] as num?)?.toDouble(),
            longitude: (json['last_longitude'] as num?)?.toDouble(),
            heading: (json['last_heading'] as num?)?.toDouble() ?? 0.0,
            lastSeen: json['last_telemetry_at'] != null ? DateTime.parse(json['last_telemetry_at']) : null,
          );
        }).toList();
      }
    } catch (e) {
      // Offline fallback
    }
    return [];
  }

  // 3. GET DRIVERS
  Future<List<Driver>> getDrivers() async {
    try {
      final response = await _httpClient.get(
        Uri.parse('$baseUrl/drivers'),
        headers: _headers,
      ).timeout(const Duration(seconds: 8));

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) {
          return Driver(
            id: json['id'] as String,
            name: json['full_name'] as String? ?? 'Driver',
            phone: json['phone'] as String? ?? '',
            licenceNumber: json['license_number'] as String? ?? 'KL-01-2015-001234',
            assignedTruckPlate: json['current_truck_plate'] as String? ?? '',
            experienceYears: (json['experience_years'] as num?)?.toInt() ?? 5,
          );
        }).toList();
      }
    } catch (e) {
      // Offline fallback
    }
    return [];
  }

  // 4. CREATE TRIP
  Future<Trip?> createTrip({
    required String from,
    required String to,
    required String cargo,
    required double weightTons,
    required String driverId,
  }) async {
    try {
      final body = jsonEncode({
        'origin_city': from,
        'dest_city': to,
        'cargo_title': cargo,
        'weight_tons': weightTons,
        'driver_id': driverId,
      });

      final response = await _httpClient.post(
        Uri.parse('$baseUrl/trips'),
        headers: _headers,
        body: body,
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200 || response.statusCode == 201) {
        final json = jsonDecode(response.body);
        return Trip(
          id: json['id'] as String,
          from: json['origin_city'] as String,
          to: json['dest_city'] as String,
          cargo: json['cargo_title'] as String,
          weightTons: (json['weight_tons'] as num).toDouble(),
          truckPlate: json['truck_plate'] as String,
          driverId: json['driver_id'] as String,
          status: _parseTripStatus(json['status'] as String?),
          startedAt: DateTime.parse(json['scheduled_start'] as String),
          distanceKm: (json['total_distance_km'] as num).toDouble(),
          distanceDoneKm: (json['distance_done_km'] as num?)?.toDouble() ?? 0.0,
          allowanceAmount: (json['allowance_amount'] as num?)?.toInt() ?? 1500,
          isPaid: json['is_paid'] as bool? ?? false,
        );
      }
    } catch (e) {
      // Handle error
    }
    return null;
  }

  // 5. UPDATE TRIP STATUS
  Future<bool> updateTripStatus(String tripId, TripStatus status) async {
    try {
      final statusStr = status == TripStatus.waiting
          ? 'waiting'
          : (status == TripStatus.accepted
              ? 'accepted'
              : (status == TripStatus.running ? 'running' : 'delivered'));

      final response = await _httpClient.patch(
        Uri.parse('$baseUrl/trips/$tripId/status'),
        headers: _headers,
        body: jsonEncode({'status': statusStr}),
      ).timeout(const Duration(seconds: 8));

      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  // 6. VERIFY DELIVERY OTP
  Future<bool> verifyDeliveryOtp(String tripId, String otp) async {
    try {
      final response = await _httpClient.post(
        Uri.parse('$baseUrl/pod/$tripId/verify-otp'),
        headers: _headers,
        body: jsonEncode({'otp_code': otp}),
      ).timeout(const Duration(seconds: 8));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['verified'] as bool? ?? false;
      }
    } catch (e) {
      // Fallback
    }
    return false;
  }

  // 7. SUBMIT PROOF OF DELIVERY
  Future<bool> submitProofOfDelivery(
    String tripId, {
    required String otp,
    required String photoPath,
    required String signatureSvg,
  }) async {
    try {
      final request = http.MultipartRequest(
        'POST',
        Uri.parse('$baseUrl/pod/$tripId/complete'),
      );

      request.fields['otp_code'] = otp;
      request.fields['signature_svg'] = signatureSvg;

      if (photoPath.isNotEmpty && File(photoPath).existsSync()) {
        request.files.add(
          await http.MultipartFile.fromPath('photo', photoPath),
        );
      }

      final streamedResponse = await request.send().timeout(const Duration(seconds: 15));
      return streamedResponse.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  TripStatus _parseTripStatus(String? statusStr) {
    switch (statusStr) {
      case 'running':
        return TripStatus.running;
      case 'accepted':
        return TripStatus.accepted;
      case 'delivered':
        return TripStatus.delivered;
      case 'waiting':
      default:
        return TripStatus.waiting;
    }
  }
}
