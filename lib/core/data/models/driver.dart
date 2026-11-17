class Driver {
  final String id;
  final String name;
  final String phone;
  final String licenceNumber;
  final bool isLicencePlaceholder; // Flag for placeholder licences
  final int experienceYears;
  final String assignedTruckPlate;
  final DateTime? licenceExpiryDate;

  const Driver({
    required this.id,
    required this.name,
    required this.phone,
    required this.licenceNumber,
    this.isLicencePlaceholder = false,
    required this.experienceYears,
    required this.assignedTruckPlate,
    this.licenceExpiryDate,
  });

  bool get isLicenceExpiringSoon {
    if (licenceExpiryDate == null) return false;
    final days = licenceExpiryDate!.difference(DateTime.now()).inDays;
    return days >= 0 && days < 30;
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'phone': phone,
    'licenceNumber': licenceNumber,
    'isLicencePlaceholder': isLicencePlaceholder,
    'experienceYears': experienceYears,
    'assignedTruckPlate': assignedTruckPlate,
    if (licenceExpiryDate != null) 'licenceExpiryDate': licenceExpiryDate!.toIso8601String(),
  };

  factory Driver.fromJson(Map<String, dynamic> json) => Driver(
    id: json['id'] as String,
    name: json['name'] as String,
    phone: json['phone'] as String,
    licenceNumber: json['licenceNumber'] as String,
    isLicencePlaceholder: json['isLicencePlaceholder'] as bool? ?? false,
    experienceYears: json['experienceYears'] as int,
    assignedTruckPlate: json['assignedTruckPlate'] as String,
    licenceExpiryDate: json['licenceExpiryDate'] != null ? DateTime.parse(json['licenceExpiryDate'] as String) : null,
  );
}
