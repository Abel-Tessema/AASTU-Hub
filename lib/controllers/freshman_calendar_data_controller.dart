import 'package:calendar_view/calendar_view.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../services/dio_service.dart';

class FreshmanCalendarDataController extends GetxController {
  final SupabaseClient supabase = Supabase.instance.client;

  var isLoading = true.obs;
  var events = <CalendarEventData>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchEvents();
  }

  Future<void> fetchEvents() async {
    isLoading.value = true;

    const path = "/FreshmanCalendar?select=*&order=startDate.asc";

    await DioService.dioGet(
      path: path,
      onSuccess: (response) {
        if (response.data.isNotEmpty) {
          events.value = response.data.map<CalendarEventData>((event) {
            final startDate = DateTime.parse(event['startDate']);
            final endDate = event['endDate'] != null
                ? DateTime.parse(event['endDate'])
                : startDate;
            final isSingleDay = startDate.isAtSameMomentAs(endDate);

            return CalendarEventData(
              date: startDate,
              startTime: startDate,
              endTime: isSingleDay
                  ? startDate.add(const Duration(hours: 1))
                  : endDate,
              title: event['event'] ?? 'No Title',
              description: isSingleDay ? 'Single-day event' : 'Multi-day event',
            );
          }).toList();

          // Add "Current Day" if no event exists for today.
          final today = DateTime.now();
          final hasTodayEvent = events.any((event) =>
              event.date.year == today.year &&
              event.date.month == today.month &&
              event.date.day == today.day);
          if (!hasTodayEvent) {
            events.add(CalendarEventData(
              date: today,
              title: 'Current Day',
              description: 'Placeholder for today.',
            ));
          }
        } else {
          events.clear();
        }
        events.sort((event1, event2) => event1.date.compareTo(event2.date));
        isLoading.value = false;
      },
      onFailure: (error, response) {
        Logger().e("Failed to fetch data: $error");
        isLoading.value = false;
      },
    );
  }
}
