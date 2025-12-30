import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:manage_x/core/constants/app_colors.dart';
import 'package:manage_x/core/di/injection.dart';
import 'package:manage_x/core/utils/notification_service.dart';
import 'package:manage_x/core/widgets/custom_button.dart';
import 'package:manage_x/core/widgets/custom_form_field.dart';
import 'package:manage_x/core/widgets/snackbar.dart';
import 'package:manage_x/core/widgets/spacing.dart';
import 'package:manage_x/features/auth/presentation/bloc/auth_bloc/auth_bloc.dart';
import 'package:manage_x/features/auth/presentation/bloc/auth_bloc/auth_event.dart';
import 'package:manage_x/features/auth/presentation/bloc/auth_bloc/auth_state.dart';
import 'package:manage_x/features/auth/presentation/bloc/auth_form_validation/login_form/login_form_cubit.dart';
import 'package:manage_x/features/auth/presentation/bloc/auth_form_validation/login_form/login_form_state.dart';
import 'package:manage_x/features/auth/presentation/bloc/password_visibility_bloc/password_visibility_cubit.dart';
import 'package:manage_x/features/auth/presentation/pages/pending_approval.dart';
import 'package:manage_x/features/auth/presentation/pages/signup.dart';
import 'package:manage_x/features/auth/presentation/views/login_view/pending_approval_web.dart';
import 'package:manage_x/features/bottom_navigation/admin_bottom_navigation/admin_bottom_navigation.dart';
import 'package:manage_x/features/bottom_navigation/admin_bottom_navigation/admin_bottom_navigation_web.dart';
import 'package:manage_x/features/home/homepage.dart';

// ignore: must_be_immutable
class LoginForm extends StatefulWidget {
  LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _emailController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  final _passwordController = TextEditingController();
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  String? _emailValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email is required';
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value.trim())) {
      return 'Enter a valid email address';
    }
    return null;
  }

  String? _passwordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
   void _login() {
  if (_formKey.currentState!.validate()) {
    final fcmToken = sl<NotificationService>().fcmToken;
    final email = _emailController.text.trim();
    
    // Check if admin email
    if (email == 'admin@company.com') {
      // Use Admin Login
      context.read<AuthBloc>().add(
        AdminLoginEvent(
          email: email,
          password: _passwordController.text,
        ),
      );
    } else {
      // Use User/Lead Login
      context.read<AuthBloc>().add(
        LoginEvent(
          email: email,
          password: _passwordController.text,
          fcmToken: fcmToken,
        ),
      );
    }
  }
}

    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is Authenticated) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => const AdminBottomNavigation()),
          );
        } else if (state is PendingApproval) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => PendingApprovalPage()),
          );
        } else if (state is AuthError) {
          ScaffoldMessenger.of(context).showSnackBar(
            showAwesomeSnackBar(
              title: "Error",
              message: "Login Failed!!..",
              contentType: ContentType.failure,
            ),
          );
        }
      },
      builder: (context, state) {
        final isLoading = state is AuthLoading;
        return Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomTextField(
                label: 'Email',
                controller: _emailController,
                validator: (value) {
                  _emailValidator(value);
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
                      _passwordValidator(value);
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
              kheight40,
              CustomButton(
                labelColor: AppColors.white,
                backgroundColor: AppColors.darkBlue,
                label: "LOGIN",
          
                onPressed: () {
                  _login();
                },
              ),
              kheight20,
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Don't have an account?"),
                  kwidth05,
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SignupPage()),
                      );
                    },
                    child: Text(
                      "Create Account",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColors.darkBlue,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
