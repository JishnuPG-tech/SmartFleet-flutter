import "package:flutter/material.dart";
import "../tokens/app_colors.dart";
import "../tokens/app_typography.dart";
import "../tokens/app_spacing.dart";

class DriverCard extends StatelessWidget {
  final String name;
  final String phone;
  final String licenceNumber;
  final bool isLicencePlaceholder;
  final int experienceYears;
  final String assignedTruckPlate;
  final VoidCallback onCall;

  const DriverCard({
    super.key,
    required this.name,
    required this.phone,
    required this.licenceNumber,
    required this.isLicencePlaceholder,
    required this.experienceYears,
    required this.assignedTruckPlate,
    required this.onCall,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: colors.brand.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(Icons.person_rounded, size: 28, color: colors.brand),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: AppTypography.heading(colors.text),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        "$phone · $experienceYears yrs exp",
                        style: AppTypography.body(colors.textSecondary),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: colors.surfaceAlt,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Truck: $assignedTruckPlate",
                    style: AppTypography.label(colors.text),
                  ),
                  const SizedBox(height: 4),
                  Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: 6,
                    runSpacing: 4,
                    children: [
                      Text(
                        "Licence: $licenceNumber",
                        style: AppTypography.label(
                          isLicencePlaceholder ? colors.statusWaiting : colors.textSecondary,
                        ),
                      ),
                      if (isLicencePlaceholder)
                        Icon(Icons.warning_amber_rounded, size: 16, color: colors.statusWaiting),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),

            SizedBox(
              height: 52,
              width: double.infinity,
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  foregroundColor: colors.brand,
                  side: BorderSide(color: colors.brand.withValues(alpha: 0.5), width: 1.5),
                  shape: RoundedRectangleBorder(borderRadius: AppSpacing.buttonBorderRadius),
                ),
                onPressed: onCall,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.phone_rounded, size: 20),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        "Call Driver",
                        style: AppTypography.heading(colors.brand),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
