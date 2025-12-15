import 'package:flutter/material.dart';
import 'package:manage_x/core/constants/app_colors.dart';
import 'package:manage_x/core/widgets/spacing.dart';
import 'package:manage_x/core/widgets/custom_design.dart';
import 'package:manage_x/features/auth/presentation/widgets/login_form.dart';

class LoginMobileView extends StatelessWidget {
  const LoginMobileView({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          clipBehavior: Clip.none,
          children: [
            Column(
              children: [
                IgnorePointer(child: CustomTopDesign()),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.bottomLeft,
                        child: Text(
                          "Welcome \nBack",
                          style: TextStyle(
                            color: AppColors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 30,
                          ),
                        ),
                      ),
                   kheight20,
                      LoginForm(),
                    ],
                  ),
                ),
              ],
            ),
            const Positioned(
              bottom: 0,
              right: 0,
              child: IgnorePointer(child: CustomBottomRightDesign()),
            ),
          ],
        ),
      ),
    );
  }
}
