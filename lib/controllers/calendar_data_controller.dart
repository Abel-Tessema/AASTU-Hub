import 'package:calendar_view/calendar_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CalendarDataController extends GetxController {
  final SupabaseClient supabase = Supabase.instance.client;

  var isLoading = true.obs;
  var events = <CalendarEventData>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchEvents();
  }

  Future<void> fetchEvents() async {
    try {
      isLoading.value = true;

      final response = await supabase
          .from('SeniorCalendar')
          .select('*')
          .order('startDate', ascending: true);

      if (response.isNotEmpty) {
        events.value = response.map<CalendarEventData>((event) {
          final startDate = DateTime.parse(event['startDate']);
          final endDate = event['endDate'] != null
              ? DateTime.parse(event['endDate'])
              : startDate;
          final isSingleDay = startDate.isAtSameMomentAs(endDate);

          return CalendarEventData(
            date: startDate,
            startTime: startDate,
            endTime:
                isSingleDay ? startDate.add(const Duration(hours: 1)) : endDate,
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
    } catch (e) {
      debugPrint('Error fetching events: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
