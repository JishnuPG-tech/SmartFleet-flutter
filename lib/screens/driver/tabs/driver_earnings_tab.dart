import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../core/theme/app_colors.dart';

class DriverEarningsTab extends StatelessWidget {
  const DriverEarningsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.midnightBlack,
      appBar: AppBar(
        backgroundColor: AppColors.midnightBlack,
        elevation: 0,
        title: const Text(
          'Earnings & Bata',
          style: TextStyle(
            color: AppColors.pureWhite,
            fontSize: 18,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        children: [
          // Hero Balance Card
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: AppColors.cardCharcoal,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.accent.withOpacity(0.4)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'TOTAL BATA EARNED (THIS WEEK)',
                      style: TextStyle(
                        color: AppColors.mutedGray,
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.8,
                      ),
                    ),
                    Icon(LucideIcons.wallet, size: 16, color: AppColors.accent),
                  ],
                ),
                const SizedBox(height: 8),
                const Text(
                  '₹18,450',
                  style: TextStyle(
                    color: AppColors.pureWhite,
                    fontSize: 32,
                    fontWeight: FontWeight.w900,
                    letterSpacing: -1.0,
                    fontFamily: 'monospace',
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Pending Auto-Transfer: ₹4,800 · Friday 6:00 PM',
                  style: TextStyle(
                    color: AppColors.accent,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.midnightBlack,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.hairline),
                  ),
                  child: const Row(
                    children: [
                      Icon(LucideIcons.landmark, size: 16, color: AppColors.mutedGray),
                      SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'Federal Bank A/C Ending in **8192 · Verified',
                          style: TextStyle(color: AppColors.pureWhite, fontSize: 12, fontWeight: FontWeight.w600),
                        ),
                      ),
                      Icon(LucideIcons.checkCircle2, size: 14, color: AppColors.green),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Payout History Header
          const Text(
            'Recent trip payouts',
            style: TextStyle(
              color: AppColors.pureWhite,
              fontSize: 15,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 10),

          _buildPayoutTile('Shipment #SF1025', 'Kochi Port → Kozhikode Hub', '₹4,800', 'In Progress', AppColors.accent),
          _buildPayoutTile('Shipment #SF1027', 'Chennai Central → Palakkad Depot', '₹5,200', 'Settled to Bank', AppColors.green),
          _buildPayoutTile('Shipment #SF1021', 'Kochi Port → Trivandrum Bay', '₹3,800', 'Settled to Bank', AppColors.green),
          _buildPayoutTile('Shipment #SF1014', 'Bangalore Yard → Kochi SEZ', '₹6,400', 'Settled to Bank', AppColors.green),

          const SizedBox(height: 80),
        ],
      ),
    );
  }

  Widget _buildPayoutTile(String trip, String route, String amount, String status, Color statusColor) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.cardCharcoal,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.hairline),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  trip,
                  style: const TextStyle(
                    color: AppColors.pureWhite,
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  route,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: AppColors.mutedGray, fontSize: 11),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                amount,
                style: const TextStyle(
                  color: AppColors.accent,
                  fontSize: 14,
                  fontWeight: FontWeight.w900,
                  fontFamily: 'monospace',
                ),
              ),
              const SizedBox(height: 2),
              Text(
                status,
                style: TextStyle(color: statusColor, fontSize: 10, fontWeight: FontWeight.w700),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
