import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';

class MainLayoutController extends GetxController {
  late PersistentTabController controller;

  @override
  void onInit() {
    // UserController.getLoggedInUser();
    controller = PersistentTabController();
    super.onInit();
  }

  final List<PersistentBottomNavBarItem> navBarItems = [
    PersistentBottomNavBarItem(
        icon: const Icon(Icons.home_rounded),
        inactiveIcon: const Icon(Icons.home_outlined),
        activeColorPrimary: const Color(0xFF4B39EF),
        inactiveColorPrimary: Colors.grey),
    PersistentBottomNavBarItem(
      icon: const Icon(Icons.calculate_rounded),
      inactiveIcon: const Icon(Icons.calculate_outlined),
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
