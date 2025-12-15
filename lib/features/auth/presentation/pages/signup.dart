import 'package:flutter/material.dart';
import 'package:manage_x/core/responsive/responsive_layout_wrapper.dart';
import 'package:manage_x/features/auth/presentation/views/sign_up_view/signup_mobile_view.dart';
import 'package:manage_x/features/auth/presentation/views/sign_up_view/signup_web_view.dart';

class SignupPage extends StatelessWidget {
  const SignupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      mobile: const SignupMobileView(),
      web: const SignupWebView(),
    );
  }
}