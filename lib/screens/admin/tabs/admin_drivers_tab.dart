import "package:flutter/material.dart";
import "../../../core/design/components/driver_card.dart";
import "../../../core/data/models/driver.dart";
import "../../../core/data/fleet_repository.dart";

class AdminDriversTab extends StatelessWidget {
  const AdminDriversTab({super.key});

  void _callDriver(BuildContext context, String name, String phone) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Calling $name ($phone)...")),
    );
  }

  @override
  Widget build(BuildContext context) {
    
    return StreamBuilder<List<Driver>>(
      stream: LocalFleetRepository.instance.watchDrivers(),
      builder: (context, snapshot) {
        final drivers = snapshot.data ?? [];

        return ListView.builder(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
          itemCount: drivers.length,
          itemBuilder: (context, index) {
            final driver = drivers[index];

            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: DriverCard(
                name: driver.name,
                phone: driver.phone,
                licenceNumber: driver.licenceNumber,
                isLicencePlaceholder: driver.isLicencePlaceholder,
                experienceYears: driver.experienceYears,
                assignedTruckPlate: driver.assignedTruckPlate,
                onCall: () => _callDriver(context, driver.name, driver.phone),
              ),
            );
          },
        );
      },
    );
  }
}
