import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

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
    final supabase = Supabase.instance.client;

    final currentUser = supabase.auth.currentUser;
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

      final response = await supabase.from('Grades').insert({
        'userId': currentUser.id,
        'courseName': course['name'],
        'creditHour': credits,
        'grade': course['grade'],
        'semester': semester.value,
        'year': int.tryParse(year.value),
        'gpaWeight': gradeValue * credits,
      }).select();

      if (response.isEmpty) {
        Get.snackbar(
          "Error",
          "Failed to save scores",
        );
        return;
      }
    }

    Get.snackbar(
      "Success",
      "Scores saved successfully!",
    );
    Get.find<GradesController>().fetchGrades();
  }
}
