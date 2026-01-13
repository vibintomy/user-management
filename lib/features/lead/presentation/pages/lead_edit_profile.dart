import 'package:flutter/widgets.dart';
import 'package:manage_x/core/responsive/responsive_layout_wrapper.dart';
import 'package:manage_x/features/lead/presentation/view/lead_edit_profile_mobile.dart';
import 'package:manage_x/features/lead/presentation/view/lead_edit_profile_web.dart';

class LeadEditProfile extends StatelessWidget {
  const LeadEditProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      mobile: LeadEditProfileMobile(),
      web: LeadEditProfileWeb(),
    );
  }
}
