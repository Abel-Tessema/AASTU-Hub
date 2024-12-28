import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../config/constants.dart';
import '../../controllers/dashboard_controller.dart';
import '../../models/grade_data.dart';

class DashboardScreen extends StatelessWidget {
  final GradesController controller = Get.put(GradesController());

  DashboardScreen({super.key});

  Color getUniqueColor(int index, int total) {
    const startColor = Color(0xFF4B39EF);
    const endColor = Color(0xFFEE8B60);
    final t = index / (total - 1);
    return Color.lerp(startColor, endColor, t)!;
  }

  final RxString selectedYear = ''.obs;
  final RxString selectedSemester = ''.obs;
  @override
  Widget build(BuildContext context) {
    controller.grades.sort((a, b) => b.year!.compareTo(a.year!));
    selectedYear.value = controller.grades.first.year.toString();
    return SafeArea(
      child: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        } else if (controller.error.isNotEmpty) {
          return Center(child: Text('Error: ${controller.error.value}'));
        } else if (controller.grades.isEmpty) {
          return const Center(child: Text('No grades available'));
        }
        final groupedByYear = _groupByYear(controller.grades);
        // Handle multiple years
        if (groupedByYear.length > 1) {
          selectedYear.value = selectedYear.value.isNotEmpty
              ? selectedYear.value
              : groupedByYear.keys.last;
          return SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('CGPA Over The Years',
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium!
                            .copyWith(fontWeight: FontWeight.bold)),
                    Flexible(
                        fit: FlexFit.loose,
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Container(
                              height: MediaQuery.of(context).size.height * 0.25,
                              decoration: BoxDecoration(
                                  color: Theme.of(context).cardColor,
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: kCardShadow()),
                              child:
                                  _buildYearBarGraph(context, groupedByYear)),
                        )),
                    const SizedBox(height: 16),
                    Flexible(
                        fit: FlexFit.loose,
                        child: _buildYearDetails(
                            context, groupedByYear[selectedYear.value]!)),
                    const SizedBox(height: 16),
                    // Expanded(
                    //     child:
                    //         GradeStatisticsWidget(gradeDataList: controller.grades))
                  ],
                ),
              ),
            ),
          );
        }

        // Handle single year
        selectedYear.value = groupedByYear.keys.first;
        return SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                  fit: FlexFit.loose,
                  child: _buildYearDetails(
                      context, groupedByYear[selectedYear.value]!)),
              const SizedBox(height: 16),
              // Flexible(
              //     fit: FlexFit.loose,
              //     child:
              //         GradeStatisticsWidget(gradeDataList: controller.grades))
            ],
          ),
        );
      }),
    );
  }

  Widget _buildYearDetails(BuildContext context, List<GradeData> grades) {
    final groupedBySemester = _groupBySemester(grades);

    // Handle multiple semesters
    if (groupedBySemester.length > 1) {
      selectedSemester.value = selectedSemester.value.isNotEmpty
          ? selectedSemester.value
          : groupedBySemester.keys.last;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Semester Analysis',
            style: Theme.of(context)
                .textTheme
                .titleMedium!
                .copyWith(fontWeight: FontWeight.bold),
          ),
          _buildSemesterPieChart(context, groupedBySemester),
          const SizedBox(height: 16),
          _buildCourseBarGraph(
              context, groupedBySemester[selectedSemester.value]!),
        ],
      );
    }

    // Handle single semester
    selectedSemester.value = groupedBySemester.keys.first;
    return _buildCourseBarGraph(
        context, groupedBySemester[selectedSemester.value]!);
  }

  Map<String, List<GradeData>> _groupByYear(List<GradeData> grades) {
    final Map<String, List<GradeData>> grouped = {};
    for (var grade in grades) {
      final year = grade.year?.toString() ?? 'Unknown Year';
      if (!grouped.containsKey(year)) grouped[year] = [];
      grouped[year]!.add(grade);
    }
    return grouped;
  }

  Map<String, List<GradeData>> _groupBySemester(List<GradeData> grades) {
    final Map<String, List<GradeData>> grouped = {};
    for (var grade in grades) {
      final semester = grade.semester ?? 'Unknown Semester';
      if (!grouped.containsKey(semester)) grouped[semester] = [];
      (grouped[semester] ?? []).add(grade);
    }
    return grouped;
  }

  Widget _buildYearBarGraph(
      BuildContext context, Map<String, List<GradeData>> groupedByYear) {
    final colors = List.generate(groupedByYear.length,
        (index) => Colors.primaries[index % Colors.primaries.length]);

    // Calculate CGPA for each year
    final yearCgpa = groupedByYear.entries.map((entry) {
      final totalCredits =
          entry.value.fold(0.0, (sum, grade) => sum + grade.creditHour!);

      final totalWeightedGpa = entry.value
          .fold(0.0, (sum, grade) => sum + (grade.grade! * grade.creditHour!));

      // Compute CGPA for the year
      final cgpa = totalCredits > 0 ? totalWeightedGpa / totalCredits : 0.0;
      return cgpa.toPrecision(2); // This will naturally be out of 4.0
    }).toList();

    final years = groupedByYear.keys.toList();

    return GestureDetector(
      onTapDown: (details) {
        // Detect tapped bar and update the selected year
        final tapIndex = details.localPosition.dx ~/
            (MediaQuery.of(context).size.width / groupedByYear.length);
        selectedYear.value = years[tapIndex];
      },
      child: BarChart(
        BarChartData(
          barTouchData: BarTouchData(touchTooltipData: BarTouchTooltipData()),
          barGroups: yearCgpa
              .asMap()
              .entries
              .map(
                (entry) => BarChartGroupData(
                  x: entry.key,
                  barRods: [
                    BarChartRodData(
                      toY: entry.value,
                      color: colors[entry.key],
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10)),
                      width: MediaQuery.of(context).size.width /
                          groupedByYear.length /
                          2.5,
                    ),
                  ],
                ),
              )
              .toList(),
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: 0.5, // Adjust interval as needed
                getTitlesWidget: (value, meta) {
                  return Text(
                    value.toStringAsFixed(1),
                    style: const TextStyle(fontSize: 10),
                  );
                },
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  if (value.toInt() < years.length) {
                    return Text(
                      years[value.toInt()],
                      style: const TextStyle(fontSize: 10),
                    );
                  }
                  return const Text('');
                },
              ),
            ),
          ),
          gridData: const FlGridData(show: true),
        ),
      ),
    );
  }

  // Build the bar graph for courses in a single semester
  Widget _buildCourseBarGraph(BuildContext context, List<GradeData> grades) {
    Color getUniqueColor(int index, int total) {
      if (total <= 1) {
        return const Color(
            0xFF4B39EF); // Default color when there's only one item
      }
      const startColor = Color(0xFF4B39EF);
      const endColor = Color(0xFFEE8B60);
      final t = index / (total - 1);
      return Color.lerp(startColor, endColor, t)!;
    }

    final colors = List.generate(
        grades.length, (index) => getUniqueColor(index, grades.length));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(12.0),
          child:
              Text('Semester ${selectedSemester.value}, ${selectedYear.value}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  )),
        ),
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Container(
            height: MediaQuery.of(context).size.height * 0.25,
            decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(12),
                boxShadow: kCardShadow()),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: BarChart(
                BarChartData(
                  barGroups: grades
                      .asMap()
                      .entries
                      .map(
                        (entry) => BarChartGroupData(
                          x: entry.key,
                          barRods: [
                            BarChartRodData(
                              toY: entry.value.grade!.toDouble(),
                              color: colors[entry.key],
                              width: 16,
                            ),
                          ],
                        ),
                      )
                      .toList(),
                  titlesData: const FlTitlesData(
                      leftTitles:
                          AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      rightTitles: AxisTitles(
                        sideTitles:
                            SideTitles(showTitles: true, reservedSize: 30),
                      ),
                      topTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      )),
                  borderData: FlBorderData(show: false),
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Wrap(
            spacing: 10.0,
            runSpacing: 10.0,
            children: grades
                .asMap()
                .entries
                .map(
                  (entry) => Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          color: colors[entry.key],
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(entry.value.courseName!),
                    ],
                  ),
                )
                .toList(),
          ),
        ),
      ],
    );
  }

  // Build the pie chart for multiple semesters
  Widget _buildSemesterPieChart(
      BuildContext context, Map<String, List<GradeData>> groupedBySemester) {
    final pieChartSections = groupedBySemester.entries.map((entry) {
      // Calculate total credits and weighted GPA for the semester
      final totalCredits = entry.value
          .fold(0.0, (sum, grade) => sum + (grade.creditHour ?? 0.0));
      final totalWeightedGpa = entry.value.fold(
          0.0,
          (sum, grade) =>
              sum + ((grade.grade ?? 0.0) * (grade.creditHour ?? 0.0)));

      // Calculate CGPA (Grade Point Average per semester)
      final cgpa = totalCredits > 0
          ? (totalWeightedGpa / totalCredits).clamp(0.0, 4.0)
          : 0.0;

      return PieChartSectionData(
        color: Colors.primaries[entry.key.hashCode % Colors.primaries.length],
        value: cgpa,
        title: '${entry.key}: ${cgpa.toStringAsFixed(2)}',
        radius: 100,
        titleStyle:
            const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      );
    }).toList();

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.25,
        child: PieChart(
          PieChartData(
            sections: pieChartSections,
            borderData: FlBorderData(show: false),
            sectionsSpace: 4,
            pieTouchData: PieTouchData(
              touchCallback: (FlTouchEvent event, pieTouchResponse) {
                if (!event.isInterestedForInteractions ||
                    pieTouchResponse == null ||
                    pieTouchResponse.touchedSection == null) {
                  return;
                }

                final touchedIndex = pieTouchResponse.touchedSection!
                    .touchedSectionIndex; // Get the index of the touched section
                final selectedKey =
                    groupedBySemester.keys.toList()[touchedIndex];

                // Update selectedSemester
                selectedSemester.value = selectedKey;
              },
            ),
          ),
        ),
      ),
    );
  }
}
