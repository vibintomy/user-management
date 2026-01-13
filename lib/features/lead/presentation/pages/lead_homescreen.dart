import 'package:flutter/material.dart';
import 'package:manage_x/core/responsive/responsive_layout_wrapper.dart';
import 'package:manage_x/features/lead/presentation/view/lead_homescreen_mobile.dart';
import 'package:manage_x/features/lead/presentation/view/lead_homescreen_web.dart';

class LeadHomescreen extends StatelessWidget {
  const LeadHomescreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      mobile: LeadHomescreenMobile(),
      web: LeadHomescreenWeb(),
    );
  }
}
