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

  const Truck({
    required this.plate,
    required this.model,
    required this.capacityTons,
    required this.assignedDriverId,
    required this.status,
  });

  Map<String, dynamic> toJson() => {
    'plate': plate,
    'model': model,
    'capacityTons': capacityTons,
    'assignedDriverId': assignedDriverId,
    'status': status.name,
  };

  factory Truck.fromJson(Map<String, dynamic> json) => Truck(
    plate: json['plate'] as String,
    model: json['model'] as String,
    capacityTons: json['capacityTons'] as int,
    assignedDriverId: json['assignedDriverId'] as String,
    status: TruckStatus.values.byName(json['status'] as String),
  );
}
