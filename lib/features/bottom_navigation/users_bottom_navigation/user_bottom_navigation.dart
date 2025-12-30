import 'package:flutter/material.dart';
import 'package:manage_x/core/responsive/responsive_layout_wrapper.dart';
import 'package:manage_x/features/bottom_navigation/users_bottom_navigation/user_bottom_navigation_mobile.dart';
import 'package:manage_x/features/bottom_navigation/users_bottom_navigation/user_bottom_navigation_web.dart';

class UserBottomNavigation extends StatelessWidget {
  const UserBottomNavigation({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      mobile: UserBottomNavigationMobile(),
      web: UserBottomNavigationWeb(),
    );
  }
}
