import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:e_hrm/contraints/colors.dart';
import 'package:e_hrm/screens/payment.dart';
import 'package:e_hrm/screens/users/dashboard.dart';
import 'package:e_hrm/screens/users/home/widget/header_home.dart';
import 'package:e_hrm/screens/users/home/widget/home_content.dart';
import 'package:e_hrm/screens/users/home/widget/information_home.dart';

import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const HomeScreenContent(),
    const Dashboard(), // halaman biasa
    const Payment(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: CurvedNavigationBar(
        key: _bottomNavigationKey,
        index: _selectedIndex,
        items: const [
          Icon(Icons.home, color: Colors.white),
          Icon(Icons.notifications, color: Colors.white),
          Icon(Icons.person, color: Colors.white),
        ],
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        color: AppColors.primaryColor,
        buttonBackgroundColor: AppColors.secondaryColor,
        backgroundColor: Colors.transparent,
        height: 60,
        animationCurve: Curves.easeInOut,
        animationDuration: const Duration(milliseconds: 300),
      ),
    );
  }
}

// Konten untuk tab pertama
class HomeScreenContent extends StatefulWidget {
  const HomeScreenContent({super.key});

  @override
  State<HomeScreenContent> createState() => _HomeScreenContentState();
}

class _HomeScreenContentState extends State<HomeScreenContent> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              child: HeaderHome(),
            ),
            InformationHome(),
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 50),
                child: Text(
                  "Menu",
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textDefaultColor,
                  ),
                ),
              ),
            ),
            SizedBox(height: 15),
            HomeContent(),
            SizedBox(height: 40),
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/absensi-center');
              },
              child: Card(
                color: AppColors.errorColor,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 150, vertical: 15),
                  child: Text(
                    "Masuk",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: AppColors.accentColor,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
