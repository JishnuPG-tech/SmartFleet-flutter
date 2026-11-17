import 'package:latlong2/latlong.dart';

enum TruckStatus {
  available,
  onTrip,
  inWorkshop,
}

class Truck {
  final String plate;
  final String model;
  final int capacityTons;
  final String assignedDriverId;
  final TruckStatus status;
  final double? latitude;
  final double? longitude;
  final double heading;
  final DateTime? lastSeen;

  const Truck({
    required this.plate,
    required this.model,
    required this.capacityTons,
    required this.assignedDriverId,
    required this.status,
    this.latitude,
    this.longitude,
    this.heading = 0.0,
    this.lastSeen,
  });

  LatLng get position => LatLng(latitude ?? 10.5276, longitude ?? 76.2144);

  Map<String, dynamic> toJson() => {
    'plate': plate,
    'model': model,
    'capacityTons': capacityTons,
    'assignedDriverId': assignedDriverId,
    'status': status.name,
    if (latitude != null) 'latitude': latitude,
    if (longitude != null) 'longitude': longitude,
    'heading': heading,
    if (lastSeen != null) 'lastSeen': lastSeen!.toIso8601String(),
  };

  factory Truck.fromJson(Map<String, dynamic> json) => Truck(
    plate: json['plate'] as String,
    model: json['model'] as String,
    capacityTons: json['capacityTons'] as int,
    assignedDriverId: json['assignedDriverId'] as String,
    status: TruckStatus.values.byName(json['status'] as String),
    latitude: (json['latitude'] as num?)?.toDouble(),
    longitude: (json['longitude'] as num?)?.toDouble(),
    heading: (json['heading'] as num?)?.toDouble() ?? 0.0,
    lastSeen: json['lastSeen'] != null ? DateTime.parse(json['lastSeen'] as String) : null,
  );
}
