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

    return Container(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: AppSpacing.cardBorderRadius,
        border: Border.all(color: colors.border, width: 1.0),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 18,
                  backgroundColor: colors.surfaceAlt,
                  child: Icon(Icons.person_rounded, size: 20, color: colors.brand),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: AppTypography.section(colors.text, fontSize: 16),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        phone,
                        style: AppTypography.supporting(colors.textSecondary, fontSize: 13),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.phone_rounded, color: colors.brand, size: 22),
                  style: IconButton.styleFrom(
                    backgroundColor: colors.surfaceAlt,
                    padding: const EdgeInsets.all(10),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSpacing.radiusChip)),
                  ),
                  onPressed: onCall,
                  tooltip: "Call Driver",
                ),
              ],
            ),
            const SizedBox(height: 10),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              decoration: BoxDecoration(
                color: colors.surfaceAlt,
                borderRadius: BorderRadius.circular(AppSpacing.radiusChip),
              ),
              child: Row(
                children: [
                  Icon(Icons.local_shipping_outlined, size: 16, color: colors.textSecondary),
                  const SizedBox(width: 6),
                  Text(
                    assignedTruckPlate.isNotEmpty ? assignedTruckPlate : "Unassigned",
                    style: AppTypography.supporting(colors.text, fontSize: 12, isNumber: true),
                  ),
                  const Spacer(),
                  Text(
                    "$experienceYears yrs exp",
                    style: AppTypography.supporting(colors.textSecondary, fontSize: 12),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
