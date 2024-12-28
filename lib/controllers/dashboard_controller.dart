import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/grade_data.dart';
import '../services/dio_service.dart';

class GradesController extends GetxController {
  final grades = <GradeData>[].obs;
  final isLoading = false.obs;
  final error = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchGrades();
  }

  Future<void> fetchGrades() async {
    isLoading.value = true;
    error.value = '';

    final user = Supabase.instance.client.auth.currentUser;

    if (user == null) {
      error.value = 'User not logged in';
      isLoading.value = false;
      return;
    }

    // Construct the URL path
    final path = "/Grades?select=*&userId=eq.${user.id}";

    // Use DioService to fetch grades
    await DioService.dioGet(
      path: path,
      onSuccess: (response) {
        // Parse response data
        final data = response.data as List<dynamic>;
        if (data.isEmpty) {
          error.value = 'No grades found';
          return;
        }
        grades.value = data.map((item) => GradeData.fromJson(item)).toList();
      },
      onFailure: (error, response) {
        // Handle failure
        this.error.value = "Failed to fetch grades: $error";
      },
    );

    isLoading.value = false;
  }
}
