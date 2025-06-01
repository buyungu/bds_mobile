import 'package:bds/screens/events/events_screen.dart';
import 'package:bds/screens/home/main_screen.dart';
import 'package:bds/screens/profile/profile_screen.dart';
import 'package:bds/utils/app_colors.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  int _selectedIndex = 0;
  List screens = [
    MainScreen(),
    EventsScreen(),
    ProfileScreen(),
  ];

  void onTapedNav(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: AppColors.primaryRed,
        unselectedItemColor: AppColors.darkGrey,
        currentIndex: _selectedIndex,
        onTap: onTapedNav,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined,),
            label: "Home",
          ), 
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today_outlined,),
            label: "Events",
          ), 
          BottomNavigationBarItem(
            icon: Icon(Icons.person_2_outlined,),
            label: "Profile",
          ), 
        ],
      ),
    );
  }
}