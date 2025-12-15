import 'package:flutter/material.dart';
import 'package:manage_x/core/constants/app_colors.dart';
import 'package:manage_x/core/widgets/spacing.dart';
import 'package:manage_x/core/widgets/custom_design.dart';
import 'package:manage_x/features/auth/presentation/widgets/signup_form.dart';

class SignupMobileView extends StatelessWidget {
  const SignupMobileView({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned(
              top: 0,
              right: 0,
              child: CustomTopRightCircles()),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
              
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.bottomLeft,
                        child: Text(
                          "Sign UP",  
                          style: TextStyle(
                            color: AppColors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 30,
                          ),
                        ),
                      ),
                   kheight20,
                      SignupForm(),
                    ],
                  ),
                ),
              ],
            ),
            const Positioned(
              bottom: 0,
              right: 0,
              child: CustomBottomRightDesign(),
            ),
          ],
        ),
      ),
    );
  }
}
