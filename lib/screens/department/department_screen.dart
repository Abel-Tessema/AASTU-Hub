import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/department_controller.dart';
import '../../widgets/cards/department_card.dart';

class DepartmentScreen extends StatelessWidget {
  const DepartmentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final DepartmentController controller = Get.put(DepartmentController());

    return Scaffold(
      appBar: AppBar(
        title: const Text("Departments"),
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.departments.isEmpty) {
          return const Center(child: Text("No departments found."));
        }

        return ListView.builder(
          itemCount: controller.departments.length,
          itemBuilder: (context, index) {
            final department = controller.departments[index];
            return DepartmentCard(department: department);
          },
        );
      }),
    );
  }
}
