import 'package:flutter/material.dart';
import 'package:manage_x/core/responsive/responsive_layout_wrapper.dart';
import 'package:manage_x/features/auth/presentation/views/login_view/pending_approval_mobile.dart';
import 'package:manage_x/features/auth/presentation/views/login_view/pending_approval_web.dart';

class PendingApprovalPage extends StatelessWidget {
  const PendingApprovalPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      mobile: PendingApprovalMobile(),
      web: PendingApprovalWeb(),
    );
  }
}
