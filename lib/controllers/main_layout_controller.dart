import 'package:aastu_hub/screens/grade_calculator_screen.dart';
import 'package:aastu_hub/screens/senior_calendar_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';

import '../screens/dashboard_screen.dart';

class MainLayoutController extends GetxController {
  late PersistentTabController controller;

  @override
  void onInit() {
    // UserController.getLoggedInUser();
    controller = PersistentTabController();
    super.onInit();
  }

  final List<Widget> screens = [
    SeniorCalendar(),
    const GradeCalculator(),
    DashboardScreen(),
  ];

  final List<PersistentBottomNavBarItem> navBarItems = [
    PersistentBottomNavBarItem(
        icon: const Icon(Icons.home_rounded),
        inactiveIcon: const Icon(Icons.home_outlined),
        activeColorPrimary: const Color(0xFF4B39EF),
        inactiveColorPrimary: Colors.grey),
    PersistentBottomNavBarItem(
      icon: const Icon(Icons.history_rounded),
      inactiveIcon: const Icon(Icons.history_toggle_off),
      activeColorPrimary: const Color(0xFF4B39EF),
      inactiveColorPrimary: Colors.grey,
    ),
    PersistentBottomNavBarItem(
      icon: const Icon(Icons.settings),
      inactiveIcon: const Icon(Icons.settings_outlined),
      activeColorPrimary: const Color(0xFF4B39EF),
      inactiveColorPrimary: Colors.grey,
    ),
  ];
}
