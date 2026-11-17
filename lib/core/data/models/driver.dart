class Driver {
  final String id;
  final String name;
  final String phone;
  final String licenceNumber;
  final bool isLicencePlaceholder; // Flag for placeholder licences
  final int experienceYears;
  final String assignedTruckPlate;

  const Driver({
    required this.id,
    required this.name,
    required this.phone,
    required this.licenceNumber,
    this.isLicencePlaceholder = false,
    required this.experienceYears,
    required this.assignedTruckPlate,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'phone': phone,
    'licenceNumber': licenceNumber,
    'isLicencePlaceholder': isLicencePlaceholder,
    'experienceYears': experienceYears,
    'assignedTruckPlate': assignedTruckPlate,
  };

  factory Driver.fromJson(Map<String, dynamic> json) => Driver(
    id: json['id'] as String,
    name: json['name'] as String,
    phone: json['phone'] as String,
    licenceNumber: json['licenceNumber'] as String,
    isLicencePlaceholder: json['isLicencePlaceholder'] as bool? ?? false,
    experienceYears: json['experienceYears'] as int,
    assignedTruckPlate: json['assignedTruckPlate'] as String,
  );
}
