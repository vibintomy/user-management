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
import 'package:manage_x/features/auth/presentation/bloc/auth_form_validation/signup_form/signup_form_cubit.dart';
import 'package:manage_x/features/auth/presentation/bloc/password_visibility_bloc/password_visibility_cubit.dart';
import 'package:manage_x/features/auth/presentation/widgets/role_selector.dart';

class SignupForm extends StatefulWidget {
  const SignupForm({super.key});

  @override
  State<SignupForm> createState() => _SignupFormState();
}

class _SignupFormState extends State<SignupForm> {
  final _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  String _selectedUser = 'user';
  String _selectedDepartment = '';
  final _passwordController = TextEditingController();
  final _iDController = TextEditingController();

  // Custom Validators
  String? _nameValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Name is required';
    }
    if (value.trim().length < 3) {
      return 'Name must be at least 3 characters';
    }
    return null;
  }

  String? _emailValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email is required';
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value.trim())) {
      return 'Enter a valid email address';
    }
     final input = value.trim().toLowerCase();

  const blockedValues = [
   
    'admin',
    'company',
  ];

  if (blockedValues.any(input.contains)) {
    return "Can't proceed with this email";
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

  String? _employeeIdValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Employee ID is required';
    }
    if (value.trim().length < 3) {
      return 'Employee ID must be at least 3 characters';
    }
    return null;
  }

  void _submitSignup() {
    // Trigger cubit validation
    context.read<SignupFormCubit>().submit();

    // Check both Form and Cubit validation
    final bool isFormValid = _formKey.currentState?.validate() ?? false;
    final bool isCubitValid = context.read<SignupFormCubit>().state.isValid;

    if (isFormValid && isCubitValid) {
      // Send signup request
      final fcmToken = sl<NotificationService>().fcmToken;
      context.read<AuthBloc>().add(
        RegisterEvent(
          name: _nameController.text.trim(),
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
          role: _selectedUser.trim(),
          fcmToken: fcmToken,
          department: _selectedDepartment.trim(),
          phone: _iDController.text
              .trim(), // or employeeId if backend expects that
        ),
      );

      // Clear form immediately after submission (optimistic UI)
      _clearForm();

      // Show success feedback
      ScaffoldMessenger.of(context).showSnackBar(
        showAwesomeSnackBar(
          title: "Success",
          message: "Registeration Completed Successfully",
          contentType: ContentType.success,
        ),
      );
      Navigator.pop(context);
    }
    // If invalid, errors will show via validators and RoleSelector
  }

  void _clearForm() {
    _nameController.clear();
    _emailController.clear();
    _passwordController.clear();
    _iDController.clear();
    setState(() {
      _selectedUser = 'user';
      _selectedDepartment = '';
    });
    context.read<SignupFormCubit>().reset();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomTextField(
            label: 'Name',
            controller: _nameController,
            validator: _nameValidator,
          ),
          kheight15,
          CustomTextField(
            label: 'Email',
            controller: _emailController,
            validator: _emailValidator,
          ),
          kheight15,
          BlocBuilder<PasswordVisibilityCubit, bool>(
            builder: (context, isVisible) {
              return CustomTextField(
                label: 'Password',
                controller: _passwordController,
                obscureText: !isVisible,
                validator: _passwordValidator,
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
            label: 'Employee ID',
            controller: _iDController,
            validator: _employeeIdValidator,
          ),
          kheight15,
          RoleSelector(
            selectedRole: _selectedUser,
            selectedDepartment: _selectedDepartment,
            roleError: context.watch<SignupFormCubit>().state.roleError,
            departmentError: context
                .watch<SignupFormCubit>()
                .state
                .departmentError,
            onRoleChanged: (role) {
              setState(() {
                _selectedUser = role;
              });
              context.read<SignupFormCubit>().roleChanged(role);
            },
            onDepartmentChanged: (department) {
              setState(() {
                _selectedDepartment = department;
              });
              context.read<SignupFormCubit>().departmentChanged(department);
            },
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.blue.shade200),
            ),
            child: Row(
              children: [
                Icon(Icons.info_outline, color: Colors.blue.shade700, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    _selectedUser == 'user'
                        ? 'User: Basic access to the system'
                        : 'Lead: Can view and manage team members',
                    style: TextStyle(fontSize: 12, color: Colors.blue.shade700),
                  ),
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Already have an account?"),
              kwidth05,
              GestureDetector(
                onTap: () {
                  // TODO: Navigate to Login Page
                  // Navigator.push(context, MaterialPageRoute(builder: (_) => LoginPage()));
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
          kheight40,
          CustomButton(
            labelColor: AppColors.white,
            backgroundColor: AppColors.darkBlue,
            label: "SIGN UP",
            onPressed: _submitSignup, // Clean and direct
          ),
          kheight20,
        ],
      ),
    );
  }
}
