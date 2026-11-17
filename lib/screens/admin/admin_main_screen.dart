import 'package:flutter/material.dart';
import 'package:smartfleet_flutter/core/components/lucide_compat.dart';
import '../../core/components/bottom_dock.dart';
import '../../core/theme/app_colors.dart';
import 'tabs/admin_home_tab.dart';
import 'tabs/admin_orders_tab.dart';
import 'tabs/admin_fleet_tab.dart';
import 'tabs/drivers_tab.dart';
import 'tabs/more_tab.dart';

class AdminMainScreen extends StatefulWidget {
  const AdminMainScreen({super.key});

  @override
  State<AdminMainScreen> createState() => _AdminMainScreenState();
}

class _AdminMainScreenState extends State<AdminMainScreen> {
  int _currentIndex = 0;

  late final List<Widget> _tabs;

  @override
  void initState() {
    super.initState();
    _tabs = [
      AdminHomeTab(onNavigateToOrders: () => setState(() => _currentIndex = 1)),
      const AdminOrdersTab(),
      const AdminFleetTab(),
      const DriversTab(),
      const MoreTab(),
    ];
  }

  static const List<BottomNavItem> _navItems = [
    BottomNavItem(icon: LucideIcons.home, label: 'Home'),
    BottomNavItem(icon: LucideIcons.package, label: 'Orders'),
    BottomNavItem(icon: LucideIcons.truck, label: 'Fleet'),
    BottomNavItem(icon: LucideIcons.users, label: 'Drivers'),
    BottomNavItem(icon: LucideIcons.menu, label: 'More'),
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
