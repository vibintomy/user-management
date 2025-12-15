import 'package:flutter/material.dart';
import 'package:manage_x/core/responsive/responsive_layout_wrapper.dart';
import 'package:manage_x/features/auth/presentation/views/login_view/login_mobile_view.dart';
import 'package:manage_x/features/auth/presentation/views/login_view/login_web_view.dart';
class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      mobile: const LoginMobileView(),
      web: const LoginWebView(),
    );
  }
}
