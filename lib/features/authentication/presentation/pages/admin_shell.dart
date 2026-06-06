import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:moto_manage/core/constants/app_colors.dart';

class AdminShell extends StatelessWidget {
  final StatefulNavigationShell navigationShell;
  const AdminShell({super.key, required this.navigationShell});

  // Updated Tab order: Dashboard -> Owners -> Vehicles -> Profile
  static const _tabs = [
    _TabItem(
        icon: Icons.dashboard_outlined,
        activeIcon: Icons.dashboard,
        label: 'Dashboard'
    ),
    _TabItem(
        icon: Icons.people_alt_outlined,
        activeIcon: Icons.people_alt,
        label: 'Owners'
    ),
    _TabItem(
        icon: Icons.directions_car_outlined,
        activeIcon: Icons.directions_car,
        label: 'Vehicles'
    ),
    _TabItem(
        icon: Icons.person_outline,
        activeIcon: Icons.person,
        label: 'Profile'
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: NavigationBar(
        backgroundColor: Colors.white,
        elevation: 10,
        indicatorColor: AppColors.background,
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: (index) => navigationShell.goBranch(
          index,
          initialLocation: index == navigationShell.currentIndex,
        ),
        destinations: _tabs
            .map((t) => NavigationDestination(
          icon: Icon(t.icon),
          selectedIcon: Icon(t.activeIcon, color: AppColors.primary),
          label: t.label,
        ))
            .toList(),
      ),
    );
  }
}

class _TabItem {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  const _TabItem({required this.icon, required this.activeIcon, required this.label});
}