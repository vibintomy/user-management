import 'dart:core';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:manage_x/core/constants/app_colors.dart';
import 'package:manage_x/core/widgets/custom_design.dart';
import 'package:manage_x/core/widgets/spacing.dart';
import 'package:manage_x/features/user/presentation/bloc/user_profile_bloc.dart';
import 'package:manage_x/features/user/presentation/bloc/user_profile_event.dart';
import 'package:manage_x/features/user/presentation/bloc/user_profile_state.dart';
import 'package:manage_x/features/user/presentation/pages/user_edit_profile.dart';

class LeadProfileWeb extends StatelessWidget {
  LeadProfileWeb({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(30),
        child: Center(
          child: BlocConsumer<ProfileBloc, ProfileState>(
            listener: (context, state) {
              // Optional: show snackbar on error, etc.
              if (state is ProfileError) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text(state.message)));
              }
            },
            builder: (context, state) {
              // Dispatch the load event when the widget is first built
              if (state is ProfileInitial) {
                context.read<ProfileBloc>().add(LoadProfileEvent());
                return const Center(child: CircularProgressIndicator());
              }

              if (state is ProfileLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (state is ProfileLoaded) {
                final user = state.user;
                return SizedBox(
                  height: 600,
                  width: 900,
                  child: Row(
                    children: [
                      // Left side (blue with avatar)
                      Stack(
                        children: [
                          Container(
                            height: 600,
                            width: 400,
                            decoration: BoxDecoration(
                              color: AppColors.darkBlue,
                              boxShadow: const [
                                BoxShadow(
                                  spreadRadius: 3,
                                  blurRadius: 4,
                                  offset: Offset(0, 4),
                                  color: Colors.grey,
                                ),
                              ],
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(25),
                                bottomLeft: Radius.circular(25),
                              ),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 350),
                                  child: Text(
                                    user.name,
                                    style: TextStyle(
                                      fontSize: 30,
                                      color: AppColors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                kheight20,
                                Text(
                                  'Role',
                                  style: TextStyle(
                                    color: AppColors.lightBackground,
                                  ),
                                ),
                                SizedBox(
                                  width: 300,
                                  child: Divider(color: AppColors.white),
                                ),
                                kheight10,
                                Container(
                                  height: 50,
                                  width: 120,

                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(20),
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        offset: Offset(0, 3),
                                        spreadRadius: 3,
                                        blurRadius: 4,
                                        color: AppColors.black,
                                      ),
                                    ],
                                  ),
                                  child: Center(
                                    child: Text(
                                      user.role,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.darkBlue,
                                        fontSize: 20,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Positioned(
                            top: 60,
                            left: 90,
                            child: CustomColorSplash(),
                          ),
                          Positioned(
                            top: 100,
                            left: 127,
                            child: CircleAvatar(
                              radius: 62.5, // 125 / 2
                              backgroundColor: AppColors.green,
                            ),
                          ),
                          Positioned(
                            top: 104,
                            left: 131,
                            child: CircleAvatar(
                              radius: 58.5, // 117 / 2
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
                          // You can add actual profile image here later
                        ],
                      ),

                      // Right side (white with user details)
                      Container(
                        height: 600,
                        width: 500,
                        padding: const EdgeInsets.all(40),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: const [
                            BoxShadow(
                              spreadRadius: 3,
                              blurRadius: 4,
                              offset: Offset(0, 4),
                              color: Colors.grey,
                            ),
                          ],
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(25),
                            bottomRight: Radius.circular(25),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              user.name,
                              style: const TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 20),
                            _buildInfoRow(Icons.email, user.email),
                            const SizedBox(height: 16),
                            _buildInfoRow(
                              Icons.phone,
                              user.phone ?? 'Not provided',
                            ),
                            const SizedBox(height: 16),
                            _buildInfoRow(Icons.work, user.role.capitalize()),
                            const SizedBox(height: 16),
                            if (user.department != null)
                              _buildInfoRow(Icons.business, user.department!),
                            // Add more fields as needed
                            kheight20,
                            SizedBox(
                              width: 390,
                              child: Divider(color: AppColors.black),
                            ),
                            kheight30,
                            GestureDetector(
                              onTap: () {
                                final result = Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        UserEditProfile(user: user),
                                  ),
                                );
                                if (result == true) {
                                  context.read<ProfileBloc>().add(
                                    LoadProfileEvent(),
                                  );
                                }
                              },
                              child: ListTile(
                                leading: Icon(
                                  Icons.person,
                                  color: AppColors.blue,
                                ),
                                title: Text(
                                  "Edit Profile",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                trailing: Icon(Icons.arrow_forward_ios),
                              ),
                            ),
                            ListTile(
                              leading: Icon(
                                Icons.description,
                                color: AppColors.magenta,
                              ),
                              title: Text(
                                "Terms & Conditons",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              trailing: Icon(Icons.arrow_forward_ios),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }

              // Fallback for error or other states
              return Center(child: Text('Something went wrong'));
            },
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, color: Colors.grey[600]),
        const SizedBox(width: 12),
        Text(text, style: const TextStyle(fontSize: 18)),
      ],
    );
  }
}

// Helper extension to capitalize role
extension LeadStringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}
