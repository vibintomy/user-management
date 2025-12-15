import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:manage_x/core/constants/app_colors.dart';
import 'package:manage_x/core/widgets/custom_button.dart';
import 'package:manage_x/core/widgets/custom_form_field.dart';
import 'package:manage_x/core/widgets/spacing.dart';
import 'package:manage_x/features/auth/presentation/bloc/auth_form_validation/login_form/login_form_cubit.dart';
import 'package:manage_x/features/auth/presentation/bloc/auth_form_validation/login_form/login_form_state.dart';
import 'package:manage_x/features/auth/presentation/bloc/auth_form_validation/signup_form/signup_form_cubit.dart';
import 'package:manage_x/features/auth/presentation/bloc/password_visibility_bloc/password_visibility_cubit.dart';
import 'package:manage_x/features/auth/presentation/pages/signup.dart';

// ignore: must_be_immutable
class SignupForm extends StatelessWidget {
  SignupForm({super.key});

  final _emailController = TextEditingController();

  final _passwordController = TextEditingController();
  final _iDController = TextEditingController();

  final _roleController = TextEditingController();
 
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginFormCubit, LoginFormState>(
      builder: (context, state) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomTextField(
              label: 'Email',
              controller: _emailController,
              validator: (value) {
                context.read<SignupFormCubit>().emailChanged(value.toString());
              },
            ),
           kheight15,
            BlocBuilder<PasswordVisibilityCubit, bool>(
              builder: (context, isVisible) {
                return CustomTextField(
                  label: 'Password',
                  controller: _passwordController,
                  obscureText: !isVisible,
                  validator: (value) {
                  context.read<SignupFormCubit>().passwordChanged(value.toString());
                  },
                  suffixIcon: IconButton(
                    icon: Icon(
                      isVisible ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed: () {
                      context.read<PasswordVisibilityCubit>().toggle();
                    },
                  ),
                );
              },
            ),
             kheight15,
             CustomTextField(
              label: 'Employe ID',
              controller: _iDController,
              validator: (value) {
                context.read<SignupFormCubit>().idChanged(value.toString());
              },
            ),
             kheight15,
             CustomTextField(
              label: 'Role',
              controller: _roleController,
              validator: (value) {
                context.read<SignupFormCubit>().roleChanged(value.toString());
              },
            ),
            kheight40,
            CustomButton(
              labelColor: AppColors.white,
              backgroundColor: AppColors.darkBlue,
              label: "LOGIN",
              onPressed: () {
                 context.read<LoginFormCubit>().submit();

            if (context.read<LoginFormCubit>().state.isValid) {
              // trigger LoginBloc here
            }
              },
            ),
          kheight20,
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Already have an account?"),
            kwidth05,
                GestureDetector(
                  onTap: () {
                     Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SignupPage()),
                      );
                  },
                  child: Text(
                    "Log In",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.darkBlue,
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
