import 'package:aastu_hub/controllers/auth_controller.dart';
import 'package:aastu_hub/screens/home_screen.dart';
import 'package:aastu_hub/screens/settings/settings_screen.dart';
import 'package:aastu_hub/widgets/login_prompter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';

import '../controllers/main_layout_controller.dart';
import 'grades/grade_calculator_screen.dart';

class MainLayoutScreen extends StatelessWidget {
  MainLayoutScreen({super.key});

  final MainLayoutController controller = Get.put(MainLayoutController());

  List<Widget> buildScreens() {
    return [
      const HomeScreen(),
      const GradeCalculator(),
      Obx(() => UserController.isLoggedIn.value
          ? SettingsScreen()
          : const LoginPrompter()),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return PersistentTabView(
      context,
      popBehaviorOnSelectedNavBarItemPress: PopBehavior.all,
      screens: buildScreens(),
      items: controller.navBarItems,
      confineToSafeArea: true,
      backgroundColor: Theme.of(context).cardColor,
      controller: controller.controller,
      // margin: const EdgeInsets.all(16),
      decoration: NavBarDecoration(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(40),
          topRight: Radius.circular(40),
          // bottomLeft: Radius.circular(40),
          // bottomRight: Radius.circular(40),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            spreadRadius: 5,
            blurRadius: 7,
            offset: const Offset(0, 3), // changes position of shadow
          ),
        ],
        colorBehindNavBar: Theme.of(context).scaffoldBackgroundColor,
      ),
      animationSettings: const NavBarAnimationSettings(
        navBarItemAnimation: ItemAnimationSettings(
          duration: Duration(milliseconds: 200),
          curve: Curves.ease,
        ),
        screenTransitionAnimation: ScreenTransitionAnimationSettings(
          animateTabTransition: true,
          screenTransitionAnimationType: ScreenTransitionAnimationType.slide,
          curve: Curves.ease,
          duration: Duration(milliseconds: 200),
        ),
      ),
      // navBarHeight: 50,
      navBarStyle: NavBarStyle.style6,
    );
  }
}
