import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/departments.dart';
import '../services/dio_service.dart';

class DepartmentController extends GetxController {
  final SupabaseClient supabase = Supabase.instance.client;

  var isLoading = true.obs;
  var departments = <Department>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchDepartments();
  }

  Future<void> fetchDepartments() async {
    isLoading.value = true;

    const path =
        "/Department?select=id,createdAt,name,description,blockNumber,roomNumber,isEngineering";

    await DioService.dioGet(
      path: path,
      onSuccess: (response) {
        if (response.data.isNotEmpty) {
          departments.value = response.data.map<Department>((data) {
            return Department.fromMap(data);
          }).toList();
        } else {
          departments.clear();
        }
        isLoading.value = false;
      },
      onFailure: (error, response) {
        Logger().e("Failed to fetch departments: $error");
        isLoading.value = false;
      },
    );
  }
}
