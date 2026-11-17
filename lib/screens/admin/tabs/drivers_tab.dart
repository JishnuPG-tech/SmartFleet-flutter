import 'package:flutter/material.dart';
import '../../../core/components/driver_card.dart';
import '../../../core/models/fleet_models.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/state/fleet_state.dart';
import '../dialogs/driver_details_dialog.dart';

class DriversTab extends StatelessWidget {
  const DriversTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: FleetState.instance,
      builder: (context, _) {
        final drivers = FleetState.instance.drivers;
        final pendingCount = drivers.where((d) => d.status == DriverStatus.pending).length;

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
                        'PERSONNEL & ROSTER',
                        style: TextStyle(
                          color: AppColors.acidLime,
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1.2,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'Certified Drivers',
                        style: TextStyle(
                          color: AppColors.pureWhite,
                          fontSize: 22,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ],
                  ),
                  if (pendingCount > 0)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: AppColors.amberWarning.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: AppColors.amberWarning.withOpacity(0.4), width: 0.8),
                      ),
                      child: Text(
                        '$pendingCount PENDING',
                        style: const TextStyle(
                          color: AppColors.amberWarning,
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
                  itemCount: drivers.length,
                  padding: const EdgeInsets.only(bottom: 80),
                  itemBuilder: (context, index) {
                    final driver = drivers[index];
                    return GestureDetector(
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent,
                          builder: (_) => DriverDetailsDialog(driver: driver),
                        );
                      },
                      child: DriverCard(driver: driver),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
