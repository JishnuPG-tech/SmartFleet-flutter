import 'package:flutter/material.dart';
import '../../../core/components/vehicle_card.dart';
import '../../../core/models/fleet_models.dart';
import '../../../core/theme/app_colors.dart';

class VehiclesTab extends StatelessWidget {
  const VehiclesTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'FLEET INVENTORY',
                    style: TextStyle(
                      color: AppColors.acidLime,
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.2,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    'Registered Lorries',
                    style: TextStyle(
                      color: AppColors.pureWhite,
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: AppColors.cardCharcoal,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.hairline, width: 0.8),
                ),
                child: const Text(
                  '128 TOTAL',
                  style: TextStyle(
                    color: AppColors.acidLime,
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: MockData.vehicles.length,
              padding: const EdgeInsets.only(bottom: 80),
              itemBuilder: (context, index) {
                final vehicle = MockData.vehicles[index];
                return VehicleCard(vehicle: vehicle);
              },
            ),
          ),
        ],
      ),
    );
  }
}
