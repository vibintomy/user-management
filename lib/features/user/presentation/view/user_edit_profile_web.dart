import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:manage_x/core/constants/app_colors.dart';
import 'package:manage_x/core/widgets/custom_button.dart';
import 'package:manage_x/core/widgets/custom_form_field.dart';
import 'package:manage_x/features/auth/domain/entities/user_entities.dart';
import 'package:manage_x/features/user/presentation/bloc/user_profile_bloc.dart';
import 'package:manage_x/features/user/presentation/bloc/user_profile_event.dart';
import 'package:manage_x/features/user/presentation/bloc/user_profile_state.dart';

class UserEditProfileWeb extends StatefulWidget {
  final UserEntity user;

  const UserEditProfileWeb({Key? key, required this.user}) : super(key: key);

  @override
  State<UserEditProfileWeb> createState() => _UserEditProfileWebState();
}

class _UserEditProfileWebState extends State<UserEditProfileWeb> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _isPasswordChanged = false;

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.user.name;
    _phoneController.text = widget.user.phone ?? '';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightGreyBackground,
      body: Center(
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.all(Radius.circular(20)),
            boxShadow: [
              BoxShadow(
                offset: Offset(0, 8),
                spreadRadius: 4,
                color: Colors.grey,
                blurRadius: 4,
              ),
            ],
          ),

          child: SizedBox(
            height: 600,
            width: 700,
            child: BlocConsumer<ProfileBloc, ProfileState>(
              listener: (context, state) {
                if (state is ProfileUpdateSuccess) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.message),
                      backgroundColor: Colors.green,
                    ),
                  );
                  context.read<ProfileBloc>().add(LoadProfileEvent());
                  Navigator.pop(context, true);
                }
                if (state is ProfileError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.message),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              builder: (context, state) {
                final isLoading = state is ProfileUpdating;

                return SingleChildScrollView(
                  child: Column(
                    children: [
                      _buildProfileHeader(),
                      const SizedBox(height: 24),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Center(
                                child: _buildSectionTitle(
                                  'Personal Information',
                                ),
                              ),
                              const SizedBox(height: 16),
                              Center(child: _buildNameField()),
                              const SizedBox(height: 16),
                              Center(child: _buildPhoneField()),
                              const SizedBox(height: 24),
                              Center(
                                child: _buildSectionTitle('Change Password'),
                              ),
                              const SizedBox(height: 8),
                              Center(
                                child: Text(
                                  'Leave blank if you don\'t want to change password',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),
                              Center(child: _buildPasswordField()),
                              const SizedBox(height: 16),
                              Center(child: _buildConfirmPasswordField()),
                              const SizedBox(height: 32),
                              Center(child: _buildSaveButton(isLoading)),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(20)),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Theme.of(context).primaryColor,
            Theme.of(context).primaryColor.withOpacity(0.7),
          ],
        ),
      ),
      padding: const EdgeInsets.symmetric(vertical: 32),
      child: Column(
        children: [
          Stack(
            children: [
              CircleAvatar(
                radius: 50,
                backgroundColor: Colors.white,
                child: CircleAvatar(
                  radius: 45,
                  backgroundColor: Colors.blue.shade100,
                  child: Text(
                    widget.user.name.isNotEmpty
                        ? widget.user.name[0].toUpperCase()
                        : 'U',
                    style: const TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.edit,
                    size: 20,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            widget.user.email,
            style: const TextStyle(fontSize: 16, color: Colors.white70),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    );
  }

  // Updated fields using CustomTextField
  Widget _buildNameField() {
    return CustomTextField(
      label: 'Full Name',
      controller: _nameController,
      prefixIcon: const Icon(Icons.person_outline),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Name is required';
        }
        if (value.trim().length < 2) {
          return 'Name must be at least 2 characters';
        }
        return null;
      },
    );
  }

  Widget _buildPhoneField() {
    return CustomTextField(
      label: 'Phone Number',
      controller: _phoneController,
      keyboardType: TextInputType.phone,
      prefixIcon: const Icon(Icons.phone_outlined),
      validator: (value) {
        if (value != null && value.isNotEmpty) {
          if (!RegExp(r'^[0-9]{10,15}$').hasMatch(value)) {
            return 'Please enter a valid phone number';
          }
        }
        return null;
      },
    );
  }

  Widget _buildPasswordField() {
    return CustomTextField(
      label: 'New Password',
      controller: _passwordController,
      obscureText: _obscurePassword,
      prefixIcon: const Icon(Icons.lock_outline),
      suffixIcon: IconButton(
        icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility),
        onPressed: () {
          setState(() {
            _obscurePassword = !_obscurePassword;
          });
        },
      ),
      onChanged: (value) {
        setState(() {
          _isPasswordChanged = value.isNotEmpty;
        });
      },
      validator: (value) {
        if (value != null && value.isNotEmpty) {
          if (value.length < 6) {
            return 'Password must be at least 6 characters';
          }
        }
        return null;
      },
    );
  }

  Widget _buildConfirmPasswordField() {
    return CustomTextField(
      label: 'Confirm New Password',
      controller: _confirmPasswordController,
      obscureText: _obscureConfirmPassword,
      prefixIcon: const Icon(Icons.lock_outline),
      suffixIcon: IconButton(
        icon: Icon(
          _obscureConfirmPassword ? Icons.visibility_off : Icons.visibility,
        ),
        onPressed: () {
          setState(() {
            _obscureConfirmPassword = !_obscureConfirmPassword;
          });
        },
      ),
      validator: (value) {
        if (_isPasswordChanged) {
          if (value == null || value.isEmpty) {
            return 'Please confirm your password';
          }
          if (value != _passwordController.text) {
            return 'Passwords do not match';
          }
        }
        return null;
      },
    );
  }

  Widget _buildSaveButton(bool isLoading) {
    return CustomButton(
      width: 170,
      height: 50,
      backgroundColor: AppColors.darkBlue,
      labelColor: Colors.white,
      borderRadius: 8,
      onPressed: isLoading ? null : _handleSave,
      child: isLoading
          ? const SizedBox(
              height: 24,
              width: 24,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            )
          : const Text(
              'Save Changes',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
    );
  }

  void _handleSave() {
    if (_formKey.currentState!.validate()) {
      final name = _nameController.text.trim() != widget.user.name
          ? _nameController.text.trim()
          : null;

      final phone = _phoneController.text.trim() != (widget.user.phone ?? '')
          ? _phoneController.text.trim()
          : null;

      final password = _passwordController.text.isNotEmpty
          ? _passwordController.text
          : null;

      if (name == null && phone == null && password == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('No changes to save'),
            backgroundColor: Colors.orange,
          ),
        );
        return;
      }

      if (password != null) {
        _showPasswordChangeConfirmation(name, phone, password);
      } else {
        _submitUpdate(name, phone, null);
      }
    }
  }

  void _showPasswordChangeConfirmation(
    String? name,
    String? phone,
    String password,
  ) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Change Password?'),
        content: const Text(
          'Are you sure you want to change your password? You will need to use the new password for your next login.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              _submitUpdate(name, phone, password);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
            ),
            child: const Text('Confirm'),
          ),
        ],
      ),
    );
  }

  void _submitUpdate(String? name, String? phone, String? password) {
    context.read<ProfileBloc>().add(
      UpdateProfileEvent(name: name, phone: phone, password: password),
    );
  }
}
