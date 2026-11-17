import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../core/components/bottom_dock.dart';
import '../../core/theme/app_colors.dart';
import 'tabs/driver_home_tab.dart';
import 'tabs/driver_trips_tab.dart';
import 'tabs/driver_earnings_tab.dart';
import 'tabs/driver_profile_tab.dart';

class DriverMainScreen extends StatefulWidget {
  const DriverMainScreen({super.key});

  @override
  State<DriverMainScreen> createState() => _DriverMainScreenState();
}

class _DriverMainScreenState extends State<DriverMainScreen> {
  int _currentIndex = 0;

  final List<Widget> _tabs = const [
    DriverHomeTab(),
    DriverTripsTab(),
    DriverEarningsTab(),
    DriverProfileTab(),
  ];

  static const List<BottomNavItem> _navItems = [
    BottomNavItem(icon: LucideIcons.home, label: 'Home'),
    BottomNavItem(icon: LucideIcons.route, label: 'My Trips'),
    BottomNavItem(icon: LucideIcons.wallet, label: 'Earnings'),
    BottomNavItem(icon: LucideIcons.user, label: 'Profile'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.midnightBlack,
      body: Stack(
        children: [
          IndexedStack(
            index: _currentIndex,
            children: _tabs,
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: BottomDock(
              currentIndex: _currentIndex,
              items: _navItems,
              onTabSelected: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}
