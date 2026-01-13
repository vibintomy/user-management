import 'package:flutter/material.dart';
import 'package:manage_x/core/responsive/responsive_layout_wrapper.dart';
import 'package:manage_x/features/user/presentation/view/user_homescreen_mobile.dart';
import 'package:manage_x/features/user/presentation/view/user_homescreen_web.dart';

class UserHomescreen extends StatelessWidget {
  const UserHomescreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(mobile: UserHomescreenMobile(), web: UserHomescreenWeb());
  }
}
