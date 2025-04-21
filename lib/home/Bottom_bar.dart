import 'package:dairy_management/screen/feed_calculator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:dairy_management/screen/add_cattle.dart';
import 'package:dairy_management/screen/setting.dart';
import '../profile/profile_screen.dart';
import 'home_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
    FeedCalculatorScreen(),
    AddCattle(),
    ProfileScreen(),
    const SettingScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<bool> _onWillPop() async {
    if (_selectedIndex != 0) {
      setState(() {
        _selectedIndex = 0;
      });
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        body: IndexedStack(
          index: _selectedIndex,
          children: _screens,
        ),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Color(0xff7b6de6),
          backgroundColor: Colors.white,
          unselectedItemColor: Colors.grey,
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(
                FeatherIcons.home,
                size: 30,
              ),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.calculate,
                size: 30,
              ),
              label: 'Feed Cal',
            ),
            BottomNavigationBarItem(
              icon: CircleAvatar(
                radius: 25,
                backgroundColor: Color(0xff6C60FE),
                child: Icon(
                  FeatherIcons.plus,
                  size: 35,
                  color: Colors.white,
                ),
              ),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.person_outline_sharp,
                size: 30,
              ),
              label: 'Profile',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                FeatherIcons.settings,
                size: 30,
              ),
              label: 'Setting',
            ),
          ],
        ),
      ),
    );
  }
}
