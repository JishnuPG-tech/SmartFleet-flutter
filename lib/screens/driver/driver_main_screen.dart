import 'package:flutter/material.dart';
import 'package:smartfleet_flutter/core/theme/app_theme.dart';
import 'package:smartfleet_flutter/l10n/app_localizations.dart';
import 'package:smartfleet_flutter/screens/driver/tabs/driver_trip_tab.dart';
import 'package:smartfleet_flutter/screens/driver/tabs/driver_earnings_tab.dart';
import 'package:smartfleet_flutter/screens/driver/tabs/driver_profile_tab.dart';

class DriverMainScreen extends StatefulWidget {
  final String driverId;
  final VoidCallback onToggleLanguage;

  const DriverMainScreen({
    super.key,
    required this.driverId,
    required this.onToggleLanguage,
  });

  @override
  State<DriverMainScreen> createState() => _DriverMainScreenState();
}

class _DriverMainScreenState extends State<DriverMainScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    final tabs = [
      DriverTripTab(driverId: widget.driverId),
      DriverEarningsTab(driverId: widget.driverId),
      DriverProfileTab(
        driverId: widget.driverId,
        onToggleLanguage: widget.onToggleLanguage,
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          _currentIndex == 0
              ? l10n.tabTrip
              : _currentIndex == 1
                  ? l10n.tabEarnings
                  : l10n.tabProfile,
        ),
        actions: [
          IconButton(
            tooltip: l10n.btnChangeLanguage,
            icon: const Icon(Icons.language, size: 28),
            onPressed: widget.onToggleLanguage,
          ),
        ],
      ),
      body: SafeArea(
        child: IndexedStack(
          index: _currentIndex,
          children: tabs,
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        // Exactly 3 tabs with mandatory icon + label
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.local_shipping, size: 28),
            label: l10n.tabTrip,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.account_balance_wallet, size: 28),
            label: l10n.tabEarnings,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.person, size: 28),
            label: l10n.tabProfile,
          ),
        ],
      ),
    );
  }
}
