import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/grade_data.dart';

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

    try {
      final supabase = Supabase.instance.client;
      final user = supabase.auth.currentUser;

      if (user == null) {
        throw Exception('User not logged in');
      }

      final response =
          await supabase.from('Grades').select('*').eq('userId', user.id);

      if (response.isEmpty) {
        throw Exception('No grades found');
      }

      final data = response as List<dynamic>;
      grades.value = data.map((item) => GradeData.fromJson(item)).toList();
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }
}
