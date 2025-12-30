import 'package:flutter/material.dart';
import 'package:manage_x/core/responsive/responsive_layout_wrapper.dart';
import 'package:manage_x/features/admin/presentation/view/admin_home_screen_mobile.dart';
import 'package:manage_x/features/admin/presentation/view/admin_home_screen_web.dart';

class AdminHomeScreen extends StatelessWidget {
  const AdminHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      mobile: AdminHomeScreenMobile(),
      web: AdminHomeScreenWeb(),
    );
  }
}
