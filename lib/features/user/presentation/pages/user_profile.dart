import 'package:flutter/material.dart';
import 'package:manage_x/core/responsive/responsive_layout_wrapper.dart';
import 'package:manage_x/features/user/presentation/view/user_profile_mobile.dart';
import 'package:manage_x/features/user/presentation/view/user_profile_web.dart';

class UserProfile extends StatelessWidget {
  const UserProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(mobile: UserProfileMobile(), web: UserProfileWeb());
  }
}
