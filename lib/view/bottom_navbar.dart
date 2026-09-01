import 'package:flutter/material.dart';
import 'package:storio_app/view/customization_screen.dart';
import 'package:storio_app/view/dashboard.dart';
import 'package:storio_app/view/institute_profile_screen.dart';
import 'package:storio_app/view/notice/notice_management_screen.dart';
import 'package:storio_app/view/settings/settings_screen.dart';

import '../utils/app_colors.dart';
import '../utils/theme/theme_ext.dart';

class BottomNavbar extends StatefulWidget {
  const BottomNavbar({super.key});

  @override
  State<BottomNavbar> createState() => _BottomNavbarState();
}

class _BottomNavbarState extends State<BottomNavbar> {
  int index = 0;

  final screens = [
    const Dashboard(),
    const NoticeManagementScreen(),
    const CustomizationScreen(),
    const InstituteProfileScreen(),
    const SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final color = context.Appcolor;
    return Scaffold(
      body: screens[index],
      extendBody: true,
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          iconTheme:  IconThemeData(
            color: color.primary,
          ),
        ),
        child: BottomNavigationBar(
          currentIndex: index,
          onTap: (value) {
            setState(() {
              index = value;
            });
          },
          type: BottomNavigationBarType.fixed,
          backgroundColor: color.cardBackground,
          selectedItemColor: color.primary,
          unselectedItemColor: Colors.grey,
          elevation: 10,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home, size: 20),
              label: "Home",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.notifications, size: 20),
              label: "Notice",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.dashboard_customize, size: 20),
              label: "Customization",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.account_balance, size: 20),
              label: "Institution",
            ),

            BottomNavigationBarItem(
              icon: Icon(Icons.settings, size: 20),
              label: "Settings",
            ),
          ],
        ),
      ),
    );
  }
}