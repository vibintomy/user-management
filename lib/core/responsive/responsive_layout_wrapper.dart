import 'package:flutter/material.dart';
import 'responsive.dart';

class ResponsiveLayout extends StatelessWidget {
  final Widget mobile;
  final Widget? tablet;
  final Widget web;

  const ResponsiveLayout({
    super.key,
    required this.mobile,
    this.tablet,
    required this.web,
  });

  @override
  Widget build(BuildContext context) {
    if (Responsive.isWeb(context)) {
      return web;
    }
    if (Responsive.isTablet(context)) {
      return tablet ?? mobile;
    }
    return mobile;
  }
}
