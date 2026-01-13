import 'package:flutter/material.dart';
import 'package:manage_x/core/responsive/responsive_layout_wrapper.dart';
import 'package:manage_x/features/admin/presentation/view/user_request_screen_mobile.dart';
import 'package:manage_x/features/admin/presentation/view/user_request_screen_web.dart';

class UserRequestScreen extends StatelessWidget {
  const UserRequestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(mobile: UserRequestScreenMobile(), web: UserRequestScreenWeb());
  }
}