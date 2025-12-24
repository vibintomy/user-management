import 'package:flutter/material.dart';
import 'package:manage_x/core/constants/app_colors.dart';
import 'package:manage_x/core/widgets/spacing.dart';

class AdminBottomNavigationWeb extends StatefulWidget {
  const AdminBottomNavigationWeb({super.key});

  @override
  State<AdminBottomNavigationWeb> createState() => _AdminBottomNavigationWebState();
}

class _AdminBottomNavigationWebState extends State<AdminBottomNavigationWeb> {
  int _selectedIndex = 1; // Default to home (second icon) - only for main items

  final List<IconData> _icons = [
    Icons.videocam_outlined,
    Icons.home_outlined,
    Icons.bookmark_outline,
    Icons.bar_chart_outlined,
    Icons.chat_bubble_outline,
  ];

  final List<IconData> _selectedIcons = [
    Icons.videocam,
    Icons.home,
    Icons.bookmark,
    Icons.bar_chart,
    Icons.chat_bubble,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Pill-shaped sidebar flush to the left
          Container(
            width: 80,
            margin: const EdgeInsets.all(30), // Spacing from screen edges
            child: Center(
              child: Container(
                height: 610,
                decoration: BoxDecoration(
                  color: const Color(0xFF5865F2),
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
                            // Handle page navigation here
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
                  
                     
                      SizedBox(height: 210),
                      Divider(color: AppColors.lightBackground,),
                      kheight10,
                      InkWell(
                        onTap: () {
                          // Handle logout logic here
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Logout'),
                              content: const Text('Are you sure you want to logout?'),
                              actions: [
                                TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
                                TextButton(
                                  onPressed: () {
                                    // Perform actual logout
                                    Navigator.pop(context);
                                  },
                                  child: const Text('Logout', style: TextStyle(color: Colors.red)),
                                ),
                              ],
                            ),
                          );
                        },
                        borderRadius: BorderRadius.circular(40),
                        child: Container(
                          width: 80,
                          height: 70,
                          decoration: BoxDecoration(
                            color: Colors.transparent, // No selection highlight for logout
                            borderRadius: BorderRadius.circular(40),
                          ),
                          child: const Icon(
                            Icons.logout,
                            color: Colors.white,
                            size: 28,
                          ),
                        ),
                      ),
                  
                      const SizedBox(height: 20), // Small padding at very bottom
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Main content area
          Expanded(
            child: Center(
              child: Text(
                'Main WebView or Content Here\nSelected: $_selectedIndex',
                style: const TextStyle(fontSize: 24),
              ),
            ),
          ),
        ],
      ),
    );
  }
}