import 'package:flutter/material.dart';
import 'package:manage_x/core/responsive/responsive_layout_wrapper.dart';
import 'package:manage_x/features/user/presentation/view/user_project_details_mobile.dart';
import 'package:manage_x/features/user/presentation/view/user_project_details_web.dart';

class UserProjectDetails extends StatelessWidget {
  final String projectId;
  final String currentUserId;
  const UserProjectDetails({
    super.key,
    required this.projectId,
    required this.currentUserId,
  });

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      mobile: UserProjectDetailsScreenMobile(
        projectId: projectId,
        currentUserId: currentUserId,
      ),
      web: UserProjectDetailsWeb(
        projectId: projectId,
        currentUserId: currentUserId,
      ),
    );
  }
}
