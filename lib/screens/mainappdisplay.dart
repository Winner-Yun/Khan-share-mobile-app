import 'package:flutter/material.dart';
import 'package:khan_share_mobile_app/screens/createbooklist.dart';
import 'package:khan_share_mobile_app/screens/homepage.dart';
import 'package:khan_share_mobile_app/screens/mappage.dart';
import 'package:khan_share_mobile_app/screens/messagescreen%20.dart';
import 'package:khan_share_mobile_app/screens/profilescreen.dart';

class Mainappdisplay extends StatefulWidget {
  const Mainappdisplay({super.key});

  @override
  State<Mainappdisplay> createState() => _MainappdisplayState();
}

class _MainappdisplayState extends State<Mainappdisplay> {
  @override
  Widget build(BuildContext context) {
    return const BookShareShellScreen();
  }
}

class BookShareShellScreen extends StatefulWidget {
  const BookShareShellScreen({super.key});

  @override
  State<BookShareShellScreen> createState() => _BookShareShellScreenState();
}

class _BookShareShellScreenState extends State<BookShareShellScreen> {
  int _selectedIndex = 0;

  // Add other screens later
  final List<Widget> _screens = const [
    HomepageScreen(),
    MapViewScreen(),
    SizedBox(), // Placeholder for FAB
    MessageScreen(),
    ProfileScreen(),
  ];

  void _onNavTapped(int index) {
    // Prevent navigating to the empty middle slot (FAB location)
    if (index == 2) return;

    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Access the current theme data
    final theme = Theme.of(context);
    return Scaffold(
      // Ensure the body background matches the theme
      backgroundColor: theme.scaffoldBackgroundColor,

      body: _screens[_selectedIndex],

      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        // Use cardColor so it switches between White (Light) and Dark Grey (Dark)
        backgroundColor: theme.cardColor,
        selectedItemColor: Colors.amber, // Amber
        unselectedItemColor: Colors.grey,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        selectedLabelStyle: const TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
        unselectedLabelStyle: const TextStyle(fontSize: 10),
        currentIndex: _selectedIndex,
        onTap: _onNavTapped,
        elevation: 10, // Adds a slight shadow for depth
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.location_on_outlined),
            activeIcon: Icon(Icons.location_on),
            label: 'Map',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add, color: Colors.transparent),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble_outline),
            activeIcon: Icon(Icons.chat_bubble),
            label: 'Chat',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),

      floatingActionButton: Padding(
        padding: const EdgeInsets.only(top: 25),
        child: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const Createbooklist()),
            );
          },
          // Use dynamic primary color (Amber)
          backgroundColor: Colors.amber,
          shape: const CircleBorder(),
          elevation: 4,
          child: const Icon(Icons.add, color: Colors.white, size: 30),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
