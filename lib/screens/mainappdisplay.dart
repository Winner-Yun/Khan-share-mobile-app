import 'package:flutter/material.dart';
import 'package:khan_share_mobile_app/config/appColors.dart';
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
    return BookShareShellScreen();
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
    SizedBox(),
    MessageScreen(),
    ProfileScreen(),
  ];

  void _onNavTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      selectedItemColor: Colors.amber,
      unselectedItemColor: Colors.grey,
      showSelectedLabels: true,
      showUnselectedLabels: true,
      selectedLabelStyle: const TextStyle(fontSize: 10),
      unselectedLabelStyle: const TextStyle(fontSize: 10),
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'Home'),
        BottomNavigationBarItem(
          icon: Icon(Icons.location_on_outlined),
          label: 'Map',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.add, color: Colors.transparent),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.chat_bubble_outline),
          label: 'Chat',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_outline),
          label: 'Profile',
        ),
      ],
      currentIndex: _selectedIndex,
      onTap: _onNavTapped,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],

      bottomNavigationBar: _buildBottomNavigationBar(),

      floatingActionButton: Padding(
        padding: const EdgeInsets.only(top: 25),
        child: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Createbooklist()),
            );
          },
          backgroundColor: AppColor.primary,
          shape: const CircleBorder(),
          child: const Icon(Icons.add, color: Colors.white, size: 30),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
