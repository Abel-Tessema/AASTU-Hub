import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/grade_calculator_controller.dart';

class GradeCalculator extends StatelessWidget {
  const GradeCalculator({super.key});

  @override
  Widget build(BuildContext context) {
    final GradeCalculatorController controller =
        Get.put(GradeCalculatorController());
    return Scaffold(
      appBar: AppBar(
        title: const Text('Grade Calculator'),
        actions: [
          Obx(() => ElevatedButton(
                onPressed: controller.saveScores,
                style: ElevatedButton.styleFrom(
                  backgroundColor: controller.semester.value == '' ||
                          controller.year.value == ''
                      ? Colors.grey[300]
                      : null,
                ),
                child: Text(
                  'Save Scores',
                  style: TextStyle(
                      color: controller.semester.value == '' ||
                              controller.year.value == ''
                          ? Colors.grey
                          : Colors.white),
                ),
              )),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(children: [
              Expanded(
                child: Obx(
                  () => Text(
                    'GPA: ${controller.gpa.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Obx(
                () => Expanded(
                  child: DropdownButtonFormField<String>(
                    value: controller.semester.value == ''
                        ? null
                        : controller.semester.value,
                    decoration: InputDecoration(
                      labelText: 'Semester',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15)),
                    ),
                    items: const [
                      DropdownMenuItem(value: 'I', child: Text('I')),
                      DropdownMenuItem(value: 'II', child: Text('II'))
                    ],
                    onChanged: (value) => controller.semester.value = value!,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Year',
                    hintText: 'e.g., 2023',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15)),
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: (value) => controller.year.value = value,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a year.';
                    } else if (!value.isNumericOnly) {
                      return 'Year must be in numbers.';
                    } else if (value.length != 4) {
                      return 'Year must be 4 digits.';
                    }
                    return null;
                  },
                ),
              ),
            ]),
            // const SizedBox(height: 16),

            const SizedBox(height: 16),
            Expanded(
              flex: 2,
              child: Obx(
                () => ListView.builder(
                  itemCount: controller.courses.length,
                  itemBuilder: (context, index) {
                    final course = controller.courses[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 3,
                            child: TextFormField(
                              decoration: InputDecoration(
                                labelText: 'Course Name',
                                hintText: 'e.g., Math',
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15)),
                              ),
                              onChanged: (value) {
                                course['name'] = value;
                                controller.courses[index] = course;
                              },
                              initialValue: course['name'],
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            flex: 2,
                            child: TextFormField(
                              decoration: InputDecoration(
                                labelText: 'Credits',
                                hintText: 'e.g., 3',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                              keyboardType: TextInputType.number,
                              onChanged: (value) {
                                course['credits'] = value;
                                controller.courses[index] = course;
                              },
                              initialValue: course['credits'],
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            flex: 2,
                            child: DropdownButtonFormField<String>(
                              value: course['grade'],
                              decoration: InputDecoration(
                                labelText: 'Grade',
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15)),
                              ),
                              items: controller.gradeScale.keys
                                  .map((grade) => DropdownMenuItem(
                                        value: grade,
                                        child: Text(grade),
                                      ))
                                  .toList(),
                              onChanged: (value) {
                                course['grade'] = value!;
                                controller.courses[index] = course;
                              },
                            ),
                          ),
                          IconButton(
                            onPressed: () => controller.removeCourse(index),
                            icon: const Icon(Icons.remove),
                            color: Colors.black45,
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: controller.addCourse,
        child: const Icon(Icons.add),
      ),
    );
  }
}
