import 'package:flutter/material.dart';
import '../models/fleet_models.dart';
import '../theme/app_colors.dart';

enum UserRole { admin, driver }

class FleetState extends ChangeNotifier {
  static final FleetState instance = FleetState._internal();
  FleetState._internal() {
    _initializeData();
  }

  UserRole currentRole = UserRole.admin;
  Driver? loggedInDriver;

  List<Trip> trips = [];
  List<Vehicle> vehicles = [];
  List<Driver> drivers = [];
  List<FleetActivity> activities = [];

  // Live GPS Telemetry for Active Driver
  double liveSpeed = 68.0;
  double liveProgress = 0.68;
  int currentWorkflowStep = 1; // 0: Pickup Hub, 1: En Route (Driving), 2: Arrived, 3: POD
  String currentWaypoint = 'Approaching Thrissur Bypass (NH-66)';
  double distanceRemainingKm = 62.4;
  int dieselRangeKm = 420;

  void _initializeData() {
    trips = List.from(MockData.trips);
    vehicles = List.from(MockData.vehicles);
    drivers = List.from(MockData.drivers);
    activities = List.from(MockData.recentActivities);
    loggedInDriver = drivers.first;
  }

  // --- Driver Actions ---
  void loginDriver({required String name, required String phone, required String license, required String vehiclePlate}) {
    loggedInDriver = Driver(
      id: 'DR-${drivers.length + 101}',
      name: name,
      phone: phone,
      licenseNumber: license,
      experienceYears: 8,
      completedTrips: 142,
      rating: 4.9,
      status: DriverStatus.available,
      assignedVehicle: vehiclePlate,
    );
    // Add to drivers roster if not present
    if (!drivers.any((d) => d.phone == phone)) {
      drivers.insert(0, loggedInDriver!);
    }
    notifyListeners();
  }

  void setDriverDuty(bool onDuty) {
    if (loggedInDriver != null) {
      final newStatus = onDuty ? DriverStatus.available : DriverStatus.offDuty;
      final idx = drivers.indexWhere((d) => d.id == loggedInDriver!.id);
      if (idx != -1) {
        drivers[idx] = Driver(
          id: loggedInDriver!.id,
          name: loggedInDriver!.name,
          phone: loggedInDriver!.phone,
          licenseNumber: loggedInDriver!.licenseNumber,
          experienceYears: loggedInDriver!.experienceYears,
          completedTrips: loggedInDriver!.completedTrips,
          rating: loggedInDriver!.rating,
          status: newStatus,
          assignedVehicle: loggedInDriver!.assignedVehicle,
        );
        loggedInDriver = drivers[idx];
      }
      notifyListeners();
    }
  }

  void acceptTrip(String tripId) {
    final idx = trips.indexWhere((t) => t.id == tripId);
    if (idx != -1) {
      final t = trips[idx];
      trips[idx] = Trip(
        id: t.id,
        tripNumber: t.tripNumber,
        originCity: t.originCity,
        originCode: t.originCode,
        destCity: t.destCity,
        destCode: t.destCode,
        cargoTitle: t.cargoTitle,
        cargoWeight: t.cargoWeight,
        driverName: loggedInDriver?.name ?? 'Suresh Kumar',
        vehiclePlate: loggedInDriver?.assignedVehicle ?? 'KL 11 AB 1234',
        scheduledDate: 'Today · Active',
        eta: '3h 15m remaining',
        progress: 0.1,
        status: TripStatus.active,
      );
      currentWorkflowStep = 0;
      activities.insert(
        0,
        FleetActivity(
          id: 'ACT-${DateTime.now().millisecondsSinceEpoch}',
          title: 'Trip ${t.tripNumber} Accepted',
          subtitle: '${loggedInDriver?.name ?? "Driver"} started mission to ${t.destCity}',
          timestamp: 'Just now',
          statusText: 'Active',
          statusColor: AppColors.accent,
        ),
      );
      notifyListeners();
    }
  }

  void declineTrip(String tripId) {
    trips.removeWhere((t) => t.id == tripId);
    notifyListeners();
  }

  void advanceDriverWorkflow() {
    currentWorkflowStep = (currentWorkflowStep + 1) % 4;
    if (currentWorkflowStep == 1) {
      liveProgress = 0.45;
      currentWaypoint = 'In Transit along NH-66 Corridor';
      liveSpeed = 68.0;
    } else if (currentWorkflowStep == 2) {
      liveProgress = 0.95;
      currentWaypoint = 'Arrived at Destination Cargo Bay';
      liveSpeed = 0.0;
    }
    notifyListeners();
  }

  void completeProofOfDelivery({
    required String tripId,
    required String receiverName,
    required String podNotes,
  }) {
    final idx = trips.indexWhere((t) => t.id == tripId);
    if (idx != -1) {
      final t = trips[idx];
      trips[idx] = Trip(
        id: t.id,
        tripNumber: t.tripNumber,
        originCity: t.originCity,
        originCode: t.originCode,
        destCity: t.destCity,
        destCode: t.destCode,
        cargoTitle: t.cargoTitle,
        cargoWeight: t.cargoWeight,
        driverName: t.driverName,
        vehiclePlate: t.vehiclePlate,
        scheduledDate: t.scheduledDate,
        eta: 'Delivered',
        progress: 1.0,
        status: TripStatus.completed,
      );
      currentWorkflowStep = 3;
      liveSpeed = 0.0;
      activities.insert(
        0,
        FleetActivity(
          id: 'ACT-${DateTime.now().millisecondsSinceEpoch}',
          title: 'Delivery Complete #${t.tripNumber}',
          subtitle: 'POD signed by $receiverName at ${t.destCity}',
          timestamp: 'Just now',
          statusText: 'Done',
          statusColor: AppColors.green,
        ),
      );
      notifyListeners();
    }
  }

  // Live GPS Telemetry Simulation Controls
  void adjustLiveSpeed(double delta) {
    liveSpeed = (liveSpeed + delta).clamp(0.0, 100.0);
    notifyListeners();
  }

  // --- Admin Actions ---
  void createNewTrip({
    required String originCity,
    required String originCode,
    required String destCity,
    required String destCode,
    required String cargoTitle,
    required String cargoWeight,
    required String assignedDriverName,
    required String vehiclePlate,
  }) {
    final tripId = 'TR-${1028 + trips.length}';
    final newTrip = Trip(
      id: tripId,
      tripNumber: tripId,
      originCity: originCity,
      originCode: originCode,
      destCity: destCity,
      destCode: destCode,
      cargoTitle: cargoTitle,
      cargoWeight: cargoWeight,
      driverName: assignedDriverName,
      vehiclePlate: vehiclePlate,
      scheduledDate: 'Today · Dispatched',
      eta: 'Assigned',
      progress: 0.0,
      status: TripStatus.assigned,
    );
    trips.insert(0, newTrip);
    activities.insert(
      0,
      FleetActivity(
        id: 'ACT-${DateTime.now().millisecondsSinceEpoch}',
        title: 'New Trip $tripId Dispatched',
        subtitle: '$originCity to $destCity · Assigned to $assignedDriverName',
        timestamp: 'Just now',
        statusText: 'Dispatched',
        statusColor: AppColors.blue,
      ),
    );
    notifyListeners();
  }
}
