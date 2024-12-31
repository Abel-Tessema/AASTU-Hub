import 'package:aastu_hub/config/config_prefs.dart';
import 'package:aastu_hub/screens/lounges/lounge_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/lounge_controller.dart';
import '../../widgets/cards/lounge_card.dart';

class LoungeScreen extends StatelessWidget {
  LoungeScreen({super.key});

  final LoungeController _controller = Get.put(LoungeController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Lounges"),
      ),
      body: Obx(() {
        if (_controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (_controller.lounges.isEmpty) {
          return const Center(
            child: Text("No lounges available."),
          );
        }

        return ListView.builder(
          itemCount: _controller.lounges.length,
          itemBuilder: (context, index) {
            final lounge = _controller.lounges[index];
            String? startHour = lounge.startTime!.hour <= 9
                ? "0${lounge.startTime?.hour}"
                : lounge.startTime?.hour.toString();
            String? startMinute = lounge.startTime!.minute <= 9
                ? "0${lounge.startTime?.minute}"
                : lounge.startTime?.minute.toString();
            String? endHour = lounge.endTime!.hour <= 9
                ? "0${lounge.endTime?.hour}"
                : lounge.endTime?.hour.toString();
            String? endMinute = lounge.endTime!.minute <= 9
                ? "0${lounge.endTime?.minute}"
                : lounge.endTime?.minute.toString();
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                onTap: () {
                  _controller.selectedLounge.value = lounge;
                  Get.to(() => LoungeDetailScreen());
                },
                child: LoungeCard(
                  name: lounge.name ?? 'Unnamed Lounge',
                  location: Location(
                    latitude: lounge.latitude ?? 0.0,
                    longitude: lounge.longitude ?? 0.0,
                  ),
                  image: lounge.imageUrl ??
                      'assets/images/logo_${ConfigPreference.getThemeIsLight() ? "light" : 'dark'}.png',
                  activeHours:
                      '${startHour ?? 0}:${startMinute ?? 0} - ${endHour ?? 0}:${endMinute ?? 0}',
                  isAvailable: isLoungeOpen(
                      lounge.startTime?.toString(), lounge.endTime?.toString()),
                ),
              ),
            );
          },
        );
      }),
    );
  }
}

bool isLoungeOpen(String? startTime, String? endTime) {
  if (startTime == null || endTime == null) return false;
  startTime.replaceAll('TimeOfDay', '');
  startTime.replaceAll('(', '');
  startTime.replaceAll(')', '');
  endTime.replaceAll('TimeOfDay', '');
  endTime.replaceAll('(', '');
  endTime.replaceAll(')', '');
  final now = TimeOfDay.now();
  final start = parseTimeOfDay(startTime);
  final end = parseTimeOfDay(endTime);

  if (start == null || end == null) return false;

  return (now.hour > start.hour ||
          (now.hour == start.hour && now.minute >= start.minute)) &&
      (now.hour < end.hour ||
          (now.hour == end.hour && now.minute <= end.minute));
}

TimeOfDay? parseTimeOfDay(String time) {
  final parts = time.split(':');
  if (parts.length < 2) return null;

  final hour = int.tryParse(parts[0]);
  final minute = int.tryParse(parts[1]);

  if (hour == null || minute == null) return null;

  return TimeOfDay(hour: hour, minute: minute);
}
