import 'package:flutter/material.dart';
import 'package:manage_x/features/admin/presentation/pages/home/admin_home_screen.dart';
import 'package:manage_x/features/admin/presentation/pages/user_request/user_request_screen.dart';
import 'package:manage_x/features/user/presentation/pages/user_homescreen.dart';
import 'package:manage_x/features/user/presentation/pages/user_profile.dart';
import 'package:manage_x/features/user/presentation/pages/user_stats.dart';
import 'package:manage_x/features/user/presentation/view/user_homescreen_web.dart';

class UserBottomNavigationMobile extends StatefulWidget {
  const UserBottomNavigationMobile({super.key});

  @override
  State<UserBottomNavigationMobile> createState() => _UserBottomNavigationMobileState();
}

class _UserBottomNavigationMobileState extends State<UserBottomNavigationMobile> {
  int _selectedIndex = 0;

  // List of pages corresponding to each tab
  static const List<Widget> _pages = <Widget>[
 UserHomescreen(),
 UserProfile()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex], // Display the selected page
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
         
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Theme.of(context).primaryColor, // or use a fixed color like Colors.blue
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed, // Ensures labels are always shown with 3+ items
      ),
    );
  }
}