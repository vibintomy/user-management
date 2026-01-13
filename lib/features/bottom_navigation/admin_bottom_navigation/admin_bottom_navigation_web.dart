import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:manage_x/core/constants/app_colors.dart';
import 'package:manage_x/core/widgets/spacing.dart';
import 'package:manage_x/features/admin/presentation/pages/home/admin_home_screen.dart';
import 'package:manage_x/features/admin/presentation/pages/user_request/user_request_screen.dart';
import 'package:manage_x/features/auth/presentation/bloc/auth_bloc/auth_bloc.dart';
import 'package:manage_x/features/auth/presentation/bloc/auth_bloc/auth_event.dart';
import 'package:manage_x/features/auth/presentation/bloc/auth_bloc/auth_state.dart';
import 'package:manage_x/features/auth/presentation/pages/login.dart'; // Make sure this path is correct

class AdminBottomNavigationWeb extends StatefulWidget {
  const AdminBottomNavigationWeb({super.key});

  @override
  State<AdminBottomNavigationWeb> createState() => _AdminBottomNavigationWebState();
}

class _AdminBottomNavigationWebState extends State<AdminBottomNavigationWeb> {
  int _selectedIndex = 0;

  final List<IconData> _icons = [
    Icons.home_outlined,
    Icons.bar_chart_outlined,
  ];

  final List<IconData> _selectedIcons = [
    Icons.home,
    Icons.bar_chart,
  ];

  final List<Widget> _pages = const [
    AdminHomeScreen(),
    UserRequestScreen(),
  ];

  // Function to show logout confirmation and perform logout
  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog first

              // Trigger logout event
              // Note: You need the refreshToken. We'll get it from local storage or bloc if possible.
              // Since AuthBloc doesn't expose refreshToken directly, we'll just dispatch LogoutEvent
              // Make sure your logoutUseCase doesn't strictly require refreshToken or handles null gracefully.
              context.read<AuthBloc>().add(const LogoutEvent(refreshToken: ""));
            },
            child: const Text('Logout', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is Unauthenticated) {
          // Successfully logged out → Navigate to Login screen
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => const LoginPage()), // Update with your actual LoginPage widget
          );
        } else if (state is AuthError) {
          // Optional: Show error if logout failed (e.g. network issue)
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Logout failed: ${state.message}"),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      child: Scaffold(
        body: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Pill-shaped sidebar
            Container(
              width: 80,
              margin: const EdgeInsets.all(30),
              child: Center(
                child: Container(
                  height: 610,
                  decoration: BoxDecoration(
                    color: const Color(0xFF5F52A6),
                    borderRadius: BorderRadius.circular(40),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Main navigation icons
                        ...List.generate(_icons.length, (index) {
                          bool isSelected = _selectedIndex == index;
                          return InkWell(
                            onTap: () {
                              setState(() {
                                _selectedIndex = index;
                              });
                            },
                            borderRadius: BorderRadius.circular(40),
                            child: Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? Colors.white.withOpacity(0.3)
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(40),
                              ),
                              child: Icon(
                                isSelected ? _selectedIcons[index] : _icons[index],
                                color: Colors.white,
                                size: 28,
                              ),
                            ),
                          );
                        }),

                        const SizedBox(height: 210),
                        const Divider(color: AppColors.lightBackground),
                        kheight10,

                        // Logout Button
                        InkWell(
                          onTap: _showLogoutDialog,
                          borderRadius: BorderRadius.circular(40),
                          child: Container(
                            width: 80,
                            height: 70,
                            decoration: BoxDecoration(
                              color: Colors.transparent,
                              borderRadius: BorderRadius.circular(40),
                            ),
                            child: const Icon(
                              Icons.logout,
                              color: Colors.white,
                              size: 28,
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // Main content area
            Expanded(
              child: IndexedStack(
                index: _selectedIndex,
                children: _pages,
              ),
            ),
          ],
        ),
      ),
    );
  }
}