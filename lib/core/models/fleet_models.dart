import 'package:flutter/material.dart';

enum TripStatus { active, assigned, completed, pending }
enum VehicleStatus { available, assigned, onTrip, maintenance }
enum DriverStatus { available, onTrip, offDuty, pending }

class Trip {
  final String id;
  final String tripNumber;
  final String originCity;
  final String originCode;
  final String destCity;
  final String destCode;
  final String cargoTitle;
  final String cargoWeight;
  final String driverName;
  final String vehiclePlate;
  final String scheduledDate;
  final String eta;
  final double progress;
  final TripStatus status;

  const Trip({
    required this.id,
    required this.tripNumber,
    required this.originCity,
    required this.originCode,
    required this.destCity,
    required this.destCode,
    required this.cargoTitle,
    required this.cargoWeight,
    required this.driverName,
    required this.vehiclePlate,
    required this.scheduledDate,
    required this.eta,
    required this.progress,
    required this.status,
  });
}

class Vehicle {
  final String id;
  final String plateNumber;
  final String model;
  final String type;
  final String capacity;
  final String assignedDriver;
  final double fuelLevel;
  final VehicleStatus status;

  const Vehicle({
    required this.id,
    required this.plateNumber,
    required this.model,
    required this.type,
    required this.capacity,
    required this.assignedDriver,
    required this.fuelLevel,
    required this.status,
  });
}

class Driver {
  final String id;
  final String name;
  final String phone;
  final String licenseNumber;
  final int experienceYears;
  final int completedTrips;
  final double rating;
  final DriverStatus status;
  final String assignedVehicle;

  const Driver({
    required this.id,
    required this.name,
    required this.phone,
    required this.licenseNumber,
    required this.experienceYears,
    required this.completedTrips,
    required this.rating,
    required this.status,
    required this.assignedVehicle,
  });
}

class FleetActivity {
  final String id;
  final String title;
  final String subtitle;
  final String timestamp;
  final String statusText;
  final Color statusColor;

  const FleetActivity({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.timestamp,
    required this.statusText,
    required this.statusColor,
  });
}

class MockData {
  static final List<Trip> trips = [
    const Trip(
      id: 'TR-1025',
      tripNumber: 'TR-1025',
      originCity: 'Kochi Port',
      originCode: 'COK',
      destCity: 'Kozhikode Hub',
      destCode: 'CCJ',
      cargoTitle: 'Industrial Steel Coils',
      cargoWeight: '24.5 Tons',
      driverName: 'Suresh Kumar',
      vehiclePlate: 'KL 11 AB 1234',
      scheduledDate: '17 Nov, 08:30 AM',
      eta: '2h 45m remaining',
      progress: 0.68,
      status: TripStatus.active,
    ),
    const Trip(
      id: 'TR-1026',
      tripNumber: 'TR-1026',
      originCity: 'Bangalore Yard',
      originCode: 'BLR',
      destCity: 'Coimbatore Term',
      destCode: 'CJB',
      cargoTitle: 'Auto Components Pack',
      cargoWeight: '18.2 Tons',
      driverName: 'Manoj Varma',
      vehiclePlate: 'KL 07 CD 5678',
      scheduledDate: '17 Nov, 11:00 AM',
      eta: '4h 10m remaining',
      progress: 0.35,
      status: TripStatus.active,
    ),
    const Trip(
      id: 'TR-1027',
      tripNumber: 'TR-1027',
      originCity: 'Chennai Central',
      originCode: 'MAA',
      destCity: 'Palakkad Depo',
      destCode: 'PGT',
      cargoTitle: 'Processed Food Grain',
      cargoWeight: '32.0 Tons',
      driverName: 'Rahim Mohammed',
      vehiclePlate: 'KL 09 EF 9012',
      scheduledDate: '16 Nov, 04:00 PM',
      eta: 'Delivered',
      progress: 1.0,
      status: TripStatus.completed,
    ),
    const Trip(
      id: 'TR-1028',
      tripNumber: 'TR-1028',
      originCity: 'Mangalore Port',
      originCode: 'IXE',
      destCity: 'Kannur Depot',
      destCode: 'CNN',
      cargoTitle: 'Heavy Machinery Unit',
      cargoWeight: '15.0 Tons',
      driverName: 'Vipin Das',
      vehiclePlate: 'KL 13 GH 3456',
      scheduledDate: '18 Nov, 06:00 AM',
      eta: 'Scheduled',
      progress: 0.0,
      status: TripStatus.assigned,
    ),
  ];

  static final List<Vehicle> vehicles = [
    const Vehicle(
      id: 'V-01',
      plateNumber: 'KL 11 AB 1234',
      model: 'BharatBenz 2823R',
      type: 'Heavy Multi-Axle',
      capacity: '28.0 T',
      assignedDriver: 'Suresh Kumar',
      fuelLevel: 0.74,
      status: VehicleStatus.onTrip,
    ),
    const Vehicle(
      id: 'V-02',
      plateNumber: 'KL 07 CD 5678',
      model: 'Tata Signa 3523.TK',
      type: 'Tipper Container',
      capacity: '35.0 T',
      assignedDriver: 'Manoj Varma',
      fuelLevel: 0.88,
      status: VehicleStatus.onTrip,
    ),
    const Vehicle(
      id: 'V-03',
      plateNumber: 'KL 09 EF 9012',
      model: 'Ashok Leyland 4220',
      type: 'Multi-Axle Hauler',
      capacity: '42.0 T',
      assignedDriver: 'Rahim Mohammed',
      fuelLevel: 0.95,
      status: VehicleStatus.available,
    ),
    const Vehicle(
      id: 'V-04',
      plateNumber: 'KL 13 GH 3456',
      model: 'Eicher Pro 6028',
      type: 'Rigid Truck',
      capacity: '28.0 T',
      assignedDriver: 'Vipin Das',
      fuelLevel: 0.60,
      status: VehicleStatus.available,
    ),
    const Vehicle(
      id: 'V-05',
      plateNumber: 'KL 01 JK 7890',
      model: 'Mahindra Blazo X 35',
      type: 'Heavy Hauler',
      capacity: '35.0 T',
      assignedDriver: 'Pending',
      fuelLevel: 0.25,
      status: VehicleStatus.maintenance,
    ),
  ];

  static final List<Driver> drivers = [
    const Driver(
      id: 'D-01',
      name: 'Suresh Kumar',
      phone: '+91 98471 23456',
      licenseNumber: 'KL-11-2015-0098231',
      experienceYears: 12,
      completedTrips: 342,
      rating: 4.9,
      status: DriverStatus.onTrip,
      assignedVehicle: 'KL 11 AB 1234',
    ),
    const Driver(
      id: 'D-02',
      name: 'Manoj Varma',
      phone: '+91 94470 87654',
      licenseNumber: 'KL-07-2017-0043129',
      experienceYears: 8,
      completedTrips: 215,
      rating: 4.8,
      status: DriverStatus.onTrip,
      assignedVehicle: 'KL 07 CD 5678',
    ),
    const Driver(
      id: 'D-03',
      name: 'Rahim Mohammed',
      phone: '+91 97455 11223',
      licenseNumber: 'KL-09-2012-0077654',
      experienceYears: 15,
      completedTrips: 512,
      rating: 4.95,
      status: DriverStatus.available,
      assignedVehicle: 'KL 09 EF 9012',
    ),
    const Driver(
      id: 'D-04',
      name: 'Vipin Das',
      phone: '+91 98950 33445',
      licenseNumber: 'KL-13-2019-0012984',
      experienceYears: 6,
      completedTrips: 128,
      rating: 4.7,
      status: DriverStatus.available,
      assignedVehicle: 'KL 13 GH 3456',
    ),
    const Driver(
      id: 'D-05',
      name: 'Akhil K. Raj',
      phone: '+91 94960 99887',
      licenseNumber: 'KL-01-2023-0056781',
      experienceYears: 4,
      completedTrips: 18,
      rating: 4.6,
      status: DriverStatus.pending,
      assignedVehicle: 'Unassigned',
    ),
  ];

  static final List<FleetActivity> recentActivities = [
    const FleetActivity(
      id: 'A-01',
      title: 'Trip #TR-1025 in transit',
      subtitle: 'KL 11 AB 1234 · Approaching Valanchery',
      timestamp: '12 mins ago',
      statusText: 'ACTIVE',
      statusColor: Color(0xFFC6FF00),
    ),
    const FleetActivity(
      id: 'A-02',
      title: 'Delivery completed #TR-1027',
      subtitle: 'KL 09 EF 9012 · Palakkad Depo',
      timestamp: '45 mins ago',
      statusText: 'DONE',
      statusColor: Color(0xFF10B981),
    ),
    const FleetActivity(
      id: 'A-03',
      title: 'Maintenance alert #V-05',
      subtitle: 'KL 01 JK 7890 · Brake pad inspection due',
      timestamp: '2 hours ago',
      statusText: 'ALERT',
      statusColor: Color(0xFFF59E0B),
    ),
  ];
}
