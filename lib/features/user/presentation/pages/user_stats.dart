import 'package:flutter/material.dart';
import 'package:manage_x/core/responsive/responsive_layout_wrapper.dart';
import 'package:manage_x/features/user/presentation/view/user_stats_mobile.dart';
import 'package:manage_x/features/user/presentation/view/user_stats_web.dart';

class UserStats extends StatelessWidget {
  const UserStats({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(mobile: UserStatsMobile(), web: UserStatsWeb());
  }
}
