import 'package:flutter/material.dart';
import 'package:manage_x/core/responsive/responsive_layout_wrapper.dart';
import 'package:manage_x/features/bottom_navigation/admin_bottom_navigation/admin_bottom_naigation_mobile.dart';
import 'package:manage_x/features/bottom_navigation/admin_bottom_navigation/admin_bottom_navigation_web.dart';

class AdminBottomNavigation extends StatelessWidget {
  const AdminBottomNavigation({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      mobile: AdminBottomNavigationMobile(),
      web: AdminBottomNavigationWeb(),
    );
  }
}
