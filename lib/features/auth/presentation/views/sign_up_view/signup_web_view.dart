import 'package:flutter/material.dart';
import 'package:manage_x/core/constants/app_colors.dart';
import 'package:manage_x/core/widgets/spacing.dart';
import 'package:manage_x/core/widgets/custom_design.dart';
import 'package:manage_x/features/auth/presentation/widgets/signup_form.dart';
import 'package:manage_x/features/auth/presentation/widgets/web_background.dart';

class SignupWebView extends StatelessWidget {
  const  SignupWebView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      body: Stack(
        children: [
          const WebBackground(),  
          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                minWidth: 550,
                maxWidth: 550,
                minHeight: 600,
                maxHeight: 600,
              ),
              child: Card(
                color: AppColors.white,
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(40),
                ),
                clipBehavior: Clip.antiAlias,
                child: Stack(
                  children: [
                    Positioned(
                      top: 0,
              
                      right: 0,
                      child: CustomTopRightCircles(),
                    ),
                     Positioned(
                      top: 50,
                      left: 100,
                       child: Text(
                         "Sign Up",
                         style: TextStyle(
                           color: AppColors.black,
                           fontWeight: FontWeight.bold,
                           fontSize: 30,
                         ),
                       ),
                     ),
                              kheight20,

                    Padding(
                      padding: const EdgeInsets.fromLTRB(32, 140, 32, 32),
                      child: Center(
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                             
                          
                              SignupForm(),
                            ],
                          ),
                        ),
                      ),
                    ),

                    const Positioned(
                      bottom: 0,
                      right: 0,
                      child: CustomBottomRightDesign(),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
