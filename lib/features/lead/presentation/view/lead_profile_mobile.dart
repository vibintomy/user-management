import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:manage_x/core/constants/app_colors.dart';
import 'package:manage_x/core/widgets/custom_design.dart';
import 'package:manage_x/features/lead/presentation/view/lead_profile_web.dart';
import 'package:manage_x/features/user/presentation/bloc/user_profile_bloc.dart';
import 'package:manage_x/features/user/presentation/bloc/user_profile_event.dart';
import 'package:manage_x/features/user/presentation/bloc/user_profile_state.dart';
import 'package:manage_x/features/user/presentation/pages/user_edit_profile.dart';

class LeadProfileMobile extends StatelessWidget {
  const LeadProfileMobile({super.key});

  @override
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: BlocConsumer<ProfileBloc, ProfileState>(
            listener: (context, state) {
              if (state is ProfileError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.message)),
                );
              }
            },
            builder: (context, state) {
              if (state is ProfileInitial) {
                context.read<ProfileBloc>().add(LoadProfileEvent());
                return const Center(child: CircularProgressIndicator());
              }

              if (state is ProfileLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (state is ProfileLoaded) {
                final user = state.user;

                return Column(
                  children: [
                    // Top decorative section (blue background + avatar + name/role)
                    Stack(
                      clipBehavior: Clip.none,
                      alignment: Alignment.center,
                      children: [
                        Container(
                          height: 280,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: AppColors.darkBlue,
                            borderRadius: BorderRadius.circular(24),
                            boxShadow: const [
                              BoxShadow(
                                spreadRadius: 2,
                                blurRadius: 8,
                                offset: Offset(0, 4),
                                color: Colors.grey,
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const SizedBox(height: 80),
                              Text(
                                user.name,
                                style: const TextStyle(
                                  fontSize: 28,
                                  color: AppColors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Role',
                                style: TextStyle(
                                  color: AppColors.lightBackground,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 16),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 24,
                                  vertical: 12,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(30),
                                  boxShadow: const [
                                    BoxShadow(
                                      offset: Offset(0, 3),
                                      spreadRadius: 1,
                                      blurRadius: 6,
                                      color: Colors.black26,
                                    ),
                                  ],
                                ),
                                child: Text(
                                  user.role,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.darkBlue,
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Splash & Avatar (positioned on top)
                        Positioned(
                          top: -10,
                          child: const CustomColorSplash(),
                        ),
                        Positioned(
                          top: 30,
                          child: CircleAvatar(
                            radius: 62,
                            backgroundColor: AppColors.green,
                            child: CircleAvatar(
                              radius: 58,
                              backgroundColor: Colors.white,
                              child: Text(
                                user.name.isNotEmpty
                                    ? user.name
                                        .trim()
                                        .split(' ')
                                        .first[0]
                                        .toUpperCase()
                                    : '?',
                                style: TextStyle(
                                  fontSize: 60,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.darkBlue,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 40),

                    // White card with details
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: const [
                          BoxShadow(
                            spreadRadius: 2,
                            blurRadius: 10,
                            offset: Offset(0, 6),
                            color: Colors.black12,
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            user.name,
                            style: const TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 24),

                          _buildInfoRow(Icons.email, user.email),
                          const SizedBox(height: 20),

                          _buildInfoRow(
                            Icons.phone,
                            user.phone ?? 'Not provided',
                          ),
                          const SizedBox(height: 20),

                          _buildInfoRow(Icons.work, user.role.capitalize()),
                          const SizedBox(height: 20),

                          if (user.department != null) ...[
                            _buildInfoRow(Icons.business, user.department!),
                            const SizedBox(height: 20),
                          ],

                          const Divider(color: Colors.black38, thickness: 1),
                          const SizedBox(height: 24),

                          // Action tiles
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => UserEditProfile(user: user),
                                ),
                              );
                            },
                            child: ListTile(
                              contentPadding: EdgeInsets.zero,
                              leading: Icon(
                                Icons.person,
                                color: AppColors.blue,
                                size: 28,
                              ),
                              title: const Text(
                                "Edit Profile",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 17,
                                ),
                              ),
                              trailing: const Icon(Icons.arrow_forward_ios, size: 20),
                            ),
                          ),

                          const Divider(height: 32),

                          ListTile(
                            contentPadding: EdgeInsets.zero,
                            leading: Icon(
                              Icons.description,
                              color: AppColors.magenta,
                              size: 28,
                            ),
                            title: const Text(
                              "Terms & Conditions",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 17,
                              ),
                            ),
                            trailing: const Icon(Icons.arrow_forward_ios, size: 20),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 40),
                  ],
                );
              }

              return const Center(child: Text('Something went wrong'));
            },
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, color: Colors.grey[700], size: 26),
        const SizedBox(width: 16),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(fontSize: 17),
          ),
        ),
      ],
    );
  }
}
