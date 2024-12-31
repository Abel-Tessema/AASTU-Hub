import 'package:aastu_hub/config/pages.dart';
import 'package:aastu_hub/controllers/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final user = UserController.loggedInUser.value;
      final userName = user == null
          ? ""
          : user.userMetadata == null
              ? ""
              : user.userMetadata?['first_name'] ?? '';
      return Scaffold(
        appBar: AppBar(
          title: Text('Hi there${userName.isNotEmpty ? ", $userName" : ""}!'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: GridView.count(
            crossAxisCount: 2,
            crossAxisSpacing: 16.0,
            mainAxisSpacing: 16.0,
            children: [
              _buildCard(context, 'Cafe Schedule', AppRoutes.cafeScheduleRoute,
                  'assets/images/cafe_schedule.svg'),
              _buildCard(
                  context,
                  'Freshman Academic Calendars',
                  AppRoutes.freshmanCalendarRoute,
                  'assets/images/calendar.svg'),
              _buildCard(context, 'Senior Academic Calendar',
                  AppRoutes.seniorCalendarRoute, 'assets/images/calendar.svg'),
              _buildCard(context, 'Lounges and their Menus',
                  AppRoutes.loungeRoute, 'assets/images/lounges.svg'),
              _buildCard(context, 'Departments', AppRoutes.departmentRoute,
                  'assets/images/department.svg'),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildCard(
      BuildContext context, String title, String route, String image) {
    return GestureDetector(
      onTap: () {
        Get.toNamed(route);
      },
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Expanded(
                child: SvgPicture.asset(
                  image,
                  width: MediaQuery.of(context).size.width * 0.2,
                  height: MediaQuery.of(context).size.width * 0.2,
                ),
              ),
              Expanded(
                child: Center(
                  child: Text(
                    title,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
