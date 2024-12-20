import 'package:aastu_hub/screens/table_view.dart';
import 'package:aastu_hub/screens/time_line_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/senior_calendar_tab_controller.dart';

class SeniorCalendar extends StatelessWidget {
  SeniorCalendar({super.key});
  final SeniorCalendarTabController controller =
      Get.put(SeniorCalendarTabController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Senior Calendar'),
      ),
      body: Column(
        children: [
          TabBar(
              controller: controller.tabController,
              tabs: const [Tab(text: 'Timeline'), Tab(text: 'Table')]),
          Expanded(
              child: TabBarView(
                  controller: controller.tabController,
                  children: [TimeLineView(), TableView()])),
        ],
      ),
    );
  }
}
