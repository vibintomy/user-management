import 'package:flutter/widgets.dart';
import 'package:manage_x/core/responsive/responsive_layout_wrapper.dart';
import 'package:manage_x/features/auth/domain/entities/user_entities.dart';
import 'package:manage_x/features/user/presentation/view/user_edit_profile_mobile.dart';
import 'package:manage_x/features/user/presentation/view/user_edit_profile_web.dart';

class UserEditProfile extends StatelessWidget {
   final UserEntity user;
  const UserEditProfile({super.key,required this.user});

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      mobile: UserEditProfileMobile(),
      web: UserEditProfileWeb(user: user,),
    );
  }
}
