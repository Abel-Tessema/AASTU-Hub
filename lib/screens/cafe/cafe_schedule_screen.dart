import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../controllers/cafe_schedule_controller.dart';
import '../../models/cafe_schedule.dart';
import '../../widgets/cards/meal_card.dart';

class CafeScheduleScreen extends StatelessWidget {
  final CafeScheduleController controller = Get.put(CafeScheduleController());

  CafeScheduleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cafe Schedule'),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.schedules.isEmpty) {
          return const Center(child: Text('No schedules available.'));
        }

        // Group schedules by day of the week
        final groupedSchedules = groupByDay(controller.schedules);

        return ListView.builder(
          itemCount: groupedSchedules.length,
          itemBuilder: (context, index) {
            final day = groupedSchedules.keys.elementAt(index);
            final daySchedules = groupedSchedules[day]!;

            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      day,
                      style: Theme.of(context)
                          .textTheme
                          .headlineSmall
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 8),
                  ...daySchedules.map((schedule) {
                    final startTime =
                        DateFormat.jm().format(schedule.startTime);
                    final endTime = DateFormat.jm().format(schedule.endTime);
                    return Padding(
                      padding: const EdgeInsets.only(left: 16.0),
                      child: MealCard(
                        image: schedule.mealImageUrl ?? '',
                        name: schedule.mealName,
                        description: '$startTime - $endTime',
                      ),
                    );
                  }),
                ],
              ),
            );
          },
        );
      }),
    );
  }

  /// Helper function to group schedules by day of the week
  Map<String, List<CafeSchedule>> groupByDay(List<CafeSchedule> schedules) {
    final Map<String, List<CafeSchedule>> grouped = {};

    for (var schedule in schedules) {
      if (!grouped.containsKey(schedule.dayOfWeek)) {
        grouped[schedule.dayOfWeek] = [];
      }
      grouped[schedule.dayOfWeek]!.add(schedule);
    }

    return grouped;
  }
}
