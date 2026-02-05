import 'package:flutter/material.dart';
import 'package:manage_x/core/responsive/responsive_layout_wrapper.dart';
import 'package:manage_x/features/lead/presentation/view/project_details_screen_mobile.dart';
import 'package:manage_x/features/lead/presentation/view/project_details_screen_web.dart';

class ProjectDetailsScreen extends StatelessWidget {
  final String projectId;
  const ProjectDetailsScreen({super.key, required this.projectId});

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      mobile: ProjectDetailsScreenMobile(projectId: projectId),
      web: ProjectDetailsScreenWeb(projectId: projectId),
    );
  }
}
