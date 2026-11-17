import 'package:flutter/material.dart';
import 'package:smartfleet_flutter/core/theme/app_theme.dart';
import 'package:smartfleet_flutter/l10n/app_localizations.dart';
import 'package:smartfleet_flutter/screens/admin/create_trip_screen.dart';
import 'package:smartfleet_flutter/screens/admin/tabs/admin_home_tab.dart';
import 'package:smartfleet_flutter/screens/admin/tabs/admin_trips_tab.dart';
import 'package:smartfleet_flutter/screens/admin/tabs/admin_fleet_tab.dart';
import 'package:smartfleet_flutter/screens/admin/tabs/admin_drivers_tab.dart';

class AdminMainScreen extends StatefulWidget {
  final VoidCallback? onToggleLanguage;

  const AdminMainScreen({super.key, this.onToggleLanguage});

  @override
  State<AdminMainScreen> createState() => _AdminMainScreenState();
}

class _AdminMainScreenState extends State<AdminMainScreen> {
  int _currentIndex = 0;

  void _openCreateTrip(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const CreateTripScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.appTitle,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w900,
                color: AppColors.textPrimary,
              ),
            ),
            Text(
              l10n.ownerRole,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
        actions: [
          if (widget.onToggleLanguage != null)
            TextButton.icon(
              onPressed: widget.onToggleLanguage,
              icon: const Icon(Icons.language, color: AppColors.accent, size: 20),
              label: Text(
                l10n.btnChangeLanguage,
                style: const TextStyle(
                  color: AppColors.accent,
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                ),
              ),
            ),
          IconButton(
            icon: const Icon(Icons.logout, color: AppColors.textSecondary),
            tooltip: l10n.btnLogout,
            onPressed: () => Navigator.pop(context),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.5),
          child: Container(color: AppColors.border, height: 1.5),
        ),
      ),
      body: SafeArea(
        child: IndexedStack(
          index: _currentIndex,
          children: [
            AdminHomeTab(
              onNewTrip: () => _openCreateTrip(context),
              onViewAllTrips: () => setState(() => _currentIndex = 1),
            ),
            const AdminTripsTab(),
            const AdminFleetTab(),
            const AdminDriversTab(),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          border: Border(top: BorderSide(color: AppColors.border, width: 1.5)),
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) => setState(() => _currentIndex = index),
          type: BottomNavigationBarType.fixed,
          backgroundColor: AppColors.background,
          selectedItemColor: AppColors.accent,
          unselectedItemColor: AppColors.textSecondary,
          selectedFontSize: 14,
          unselectedFontSize: 14,
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w800),
          unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600),
          showUnselectedLabels: true,
          items: [
            BottomNavigationBarItem(
              icon: const Icon(Icons.dashboard_outlined),
              activeIcon: const Icon(Icons.dashboard),
              label: l10n.tabHome,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.receipt_long_outlined),
              activeIcon: const Icon(Icons.receipt_long),
              label: l10n.tabTrips,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.local_shipping_outlined),
              activeIcon: const Icon(Icons.local_shipping),
              label: l10n.tabTrucks,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.people_outline),
              activeIcon: const Icon(Icons.people),
              label: l10n.tabDrivers,
            ),
          ],
        ),
      ),
    );
  }
}
