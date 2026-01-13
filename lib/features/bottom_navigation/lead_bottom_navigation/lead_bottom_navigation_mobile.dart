import 'package:flutter/material.dart';
import 'package:manage_x/features/lead/presentation/pages/lead_homescreen.dart';
import 'package:manage_x/features/lead/presentation/pages/lead_profile.dart';
import 'package:manage_x/features/lead/presentation/pages/lead_stats.dart';

class LeadBottomNavigationMobile extends StatefulWidget {
  const LeadBottomNavigationMobile({super.key});

  @override
  State<LeadBottomNavigationMobile> createState() => _LeadBottomNavigationMobileState();
}

class _LeadBottomNavigationMobileState extends State<LeadBottomNavigationMobile> {
  int _selectedIndex = 0;

  // List of pages corresponding to each tab
  static const List<Widget> _pages = <Widget>[
   LeadHomescreen(),
   LeadStats(),
   LeadProfile()
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
            icon: Icon(Icons.bar_chart),
            label: 'Stats',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.exit_to_app),
            label: 'Exit',
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