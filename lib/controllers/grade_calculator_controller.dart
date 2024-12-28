import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../services/dio_service.dart';
import 'dashboard_controller.dart';

class GradeCalculatorController extends GetxController {
  var courses = <Map<String, dynamic>>[
    {'name': '', 'credits': '', 'grade': 'A'},
    {'name': '', 'credits': '', 'grade': 'A'},
    {'name': '', 'credits': '', 'grade': 'A'},
    {'name': '', 'credits': '', 'grade': 'A'},
    {'name': '', 'credits': '', 'grade': 'A'},
  ].obs;

  var semester = ''.obs;
  var year = ''.obs;

  var isLoading = false.obs;

  final gradeScale = {
    'A+': 4.0,
    'A': 4.0,
    'A-': 3.75,
    'B+': 3.5,
    'B': 3.0,
    'B-': 2.75,
    'C+': 2.5,
    'C': 2.0,
    'D': 1.0,
    'F': 0.0,
  };

  double get gpa {
    double totalPoints = 0;
    int totalCredits = 0;

    for (var course in courses) {
      if (course['credits'] != '' && course['grade'] != '') {
        final credits = int.tryParse(course['credits']) ?? 0;
        final gradeValue = gradeScale[course['grade']] ?? 0.0;
        totalPoints += gradeValue * credits;
        totalCredits += credits;
      }
    }

    return totalCredits > 0 ? totalPoints / totalCredits : 0.0;
  }

  void addCourse() {
    courses.add({'name': '', 'credits': '', 'grade': 'A'});
  }

  void removeCourse(int index) {
    if (courses.length > 1) {
      courses.removeAt(index);
    }
  }

  Future<void> saveScores() async {
    isLoading.value = true;
    final currentUser = Supabase.instance.client.auth.currentUser;

    if (currentUser == null) {
      Get.snackbar(
        "Error",
        "You must be logged in to save scores.",
      );
      return;
    }

    if (semester.value.isEmpty || year.value.isEmpty) {
      Get.snackbar(
        "Error",
        "Please provide semester and year.",
      );
      return;
    }

    for (var course in courses) {
      if (course['name'].isEmpty || course['credits'].isEmpty) {
        Get.snackbar(
          "Error",
          "Please fill all fields for all courses.",
        );
        return;
      }

      final credits = int.tryParse(course['credits']) ?? 0;
      final gradeValue = gradeScale[course['grade']] ?? 0.0;

      // Construct the request path
      const path = "/Grades";

      // Create the data payload
      final payload = {
        'userId': currentUser.id,
        'courseName': course['name'],
        'creditHour': credits,
        'grade': course['grade'],
        'semester': semester.value,
        'year': int.tryParse(year.value),
        'gpaWeight': gradeValue * credits,
      };

      await DioService.dioPost(
        path: path,
        data: payload,
        onSuccess: (response) {
          Get.snackbar(
            "Success",
            "Scores saved successfully!",
          );
          Get.find<GradesController>().fetchGrades();
        },
        onFailure: (error, response) {
          Get.snackbar(
            "Error",
            "Failed to save scores: $error",
          );
        },
      );
    }

    isLoading.value = false;
  }
}
