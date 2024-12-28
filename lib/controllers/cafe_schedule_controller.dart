import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/cafe_schedule.dart';
import '../services/dio_service.dart';

class CafeScheduleController extends GetxController {
  final SupabaseClient supabase = Supabase.instance.client;

  var isLoading = true.obs;
  var schedules = <CafeSchedule>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchCafeSchedules();
  }

  Future<void> fetchCafeSchedules() async {
    isLoading.value = true;

    const path =
        "/CafeSchedule?select=id,createdAt,DayOfWeek(name),CafeMeal(name,imageUrl),CafeMealTime(name,startTime,endTime)";

    await DioService.dioGet(
      path: path,
      onSuccess: (response) {
        if (response.data.isNotEmpty) {
          schedules.value = response.data.map<CafeSchedule>((data) {
            return CafeSchedule.fromMap(data);
          }).toList();
        } else {
          schedules.clear();
        }
        isLoading.value = false;
      },
      onFailure: (error, response) {
        Logger().e("Failed to fetch cafe schedules: $error");
        isLoading.value = false;
      },
    );
  }
}
