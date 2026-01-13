import 'package:flutter/material.dart';
import 'package:manage_x/core/responsive/responsive_layout_wrapper.dart';
import 'package:manage_x/features/lead/presentation/view/lead_stats_mobile.dart';
import 'package:manage_x/features/lead/presentation/view/lead_stats_web.dart';

class LeadStats extends StatelessWidget {
  const LeadStats({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(mobile: LeadStatsMobile(), web: LeadStatsWeb());
  }
}
