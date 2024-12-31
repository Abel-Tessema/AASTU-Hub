import 'package:aastu_hub/controllers/freshman_calendar_data_controller.dart';
import 'package:aastu_hub/screens/calendars/views/table_view.dart';
import 'package:aastu_hub/screens/calendars/views/time_line_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

import '../../controllers/auth_controller.dart';
import '../../controllers/senior_calendar_tab_controller.dart';

class FreshmanCalendarScreen extends StatelessWidget {
  FreshmanCalendarScreen({super.key});

  final FreshmanCalendarTabController controller =
      Get.put(FreshmanCalendarTabController());

  final FreshmanCalendarDataController calendarController =
      Get.put(FreshmanCalendarDataController());

  @override
  Widget build(BuildContext context) {
    Logger().d(UserController.loggedInUser.value!.userMetadata);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Freshman Calendar'),
      ),
      body: Column(
        children: [
          TabBar(
              controller: controller.tabController,
              tabs: const [Tab(text: 'Timeline'), Tab(text: 'Table')]),
          Expanded(
              child:
                  TabBarView(controller: controller.tabController, children: [
            Obx(() {
              if (calendarController.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }
              return TimeLineView(
                events: calendarController.events,
              );
            }),
            Obx(() {
              if (calendarController.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }
              return TableView(
                events: calendarController.events,
              );
            })
          ])),
        ],
      ),
    );
  }
}
