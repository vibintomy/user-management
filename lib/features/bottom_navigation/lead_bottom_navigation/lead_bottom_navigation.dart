import 'package:flutter/material.dart';
import 'package:manage_x/core/responsive/responsive_layout_wrapper.dart';
import 'package:manage_x/features/bottom_navigation/lead_bottom_navigation/lead_bottom_navigation_mobile.dart';
import 'package:manage_x/features/bottom_navigation/lead_bottom_navigation/lead_bottom_navigation_web.dart';

class LeadBottomNavigation extends StatelessWidget {
  const LeadBottomNavigation({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(mobile: LeadBottomNavigationMobile(), web: LeadBottomNavigationWeb());
  }
}
