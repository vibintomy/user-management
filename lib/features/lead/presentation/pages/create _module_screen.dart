import 'package:flutter/material.dart';
import 'package:manage_x/core/responsive/responsive_layout_wrapper.dart';
import 'package:manage_x/features/lead/presentation/view/create_module_screen_mobile.dart';
import 'package:manage_x/features/lead/presentation/view/create_module_screen_web.dart';

class CreateModuleScreen extends StatelessWidget {
  final String projectId;
  const CreateModuleScreen({super.key, required this.projectId});

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      mobile: CreateModuleScreenMobile(projectId: projectId),
      web: CreateModuleScreenWeb(projectId: projectId),
    );
  }
}
