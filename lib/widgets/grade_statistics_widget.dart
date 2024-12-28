import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../models/grade_data.dart';

class GradeStatisticsWidget extends StatelessWidget {
  final List<GradeData> gradeDataList;

  const GradeStatisticsWidget({super.key, required this.gradeDataList});

  @override
  Widget build(BuildContext context) {
    // Check data availability
    final bool hasOverallGPA = gradeDataList.isNotEmpty;
    final bool hasGradeDistribution = gradeDataList.isNotEmpty;
    final bool hasSemesterGPATrend = _hasMultipleSemesters();
    final bool hasYearlyGPATrend = _hasMultipleYears();
    final bool hasMostCreditHeavySemester = _hasMultipleSemesters();

    return Column(
      children: [
        if (hasOverallGPA) OverallGPAWidget(overallGPA: _calculateOverallGPA()),
        if (hasGradeDistribution)
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.15,
            child: PieChart(
              PieChartData(
                sections: _generateGradeDistributionData(),
                centerSpaceRadius: 40,
                sectionsSpace: 2,
              ),
            ),
          ),
        if (hasSemesterGPATrend)
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.15,
            child: LineChart(
              LineChartData(
                lineBarsData: [_generateSemesterTrendData()],
                titlesData: const FlTitlesData(show: true),
                gridData: const FlGridData(show: false),
              ),
            ),
          ),
        if (hasYearlyGPATrend)
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.15,
            child: LineChart(
              LineChartData(
                lineBarsData: [_generateYearlyTrendData()],
                titlesData: const FlTitlesData(show: true),
                gridData: const FlGridData(show: false),
              ),
            ),
          ),
      ],
    );
  }

  // Helper methods
  bool _hasMultipleSemesters() {
    final semesters =
        gradeDataList.map((grade) => "${grade.year}-${grade.semester}").toSet();
    return semesters.length > 1;
  }

  bool _hasMultipleYears() {
    final years = gradeDataList.map((grade) => grade.year).toSet();
    return years.length > 1;
  }

  double _calculateOverallGPA() {
    if (gradeDataList.isEmpty) return 0.0;
    final totalWeightedGPA = gradeDataList.fold<double>(
      0.0,
      (sum, item) => sum + (item.gpaWeight! * item.creditHour!),
    );
    final totalCreditHours = gradeDataList.fold<double>(
      0.0,
      (sum, item) => sum + item.creditHour!,
    );
    return totalCreditHours > 0 ? totalWeightedGPA / totalCreditHours : 0.0;
  }

  List<PieChartSectionData> _generateGradeDistributionData() {
    final gradeCounts = <String, int>{};
    for (var grade in gradeDataList) {
      gradeCounts[grade.grade.toString()] =
          (gradeCounts[grade.grade.toString()] ?? 0) + 1;
    }
    return gradeCounts.entries.map((entry) {
      return PieChartSectionData(
        title: entry.key,
        value: entry.value.toDouble(),
        color: Colors.primaries[entry.key.hashCode % Colors.primaries.length],
      );
    }).toList();
  }

  LineChartBarData _generateSemesterTrendData() {
    final semesterGPA = <String, double>{};
    final semesterCredits = <String, double>{};

    for (var grade in gradeDataList) {
      final key = "${grade.year}-${grade.semester}";
      semesterGPA[key] =
          (semesterGPA[key] ?? 0.0) + (grade.gpaWeight! * grade.creditHour!);
      semesterCredits[key] = (semesterCredits[key] ?? 0.0) + grade.creditHour!;
    }

    final trendData = semesterGPA.entries
        .map((entry) => FlSpot(
              entry.key.hashCode.toDouble(),
              (entry.value / (semesterCredits[entry.key] ?? 1.0)),
            ))
        .toList();

    return LineChartBarData(
      spots: trendData,
      isCurved: true,
      dotData: const FlDotData(show: true),
      color: const Color(0xFF4B39EF),
    );
  }

  LineChartBarData _generateYearlyTrendData() {
    final yearlyGPA = <int, double>{};
    final yearlyCredits = <int, double>{};

    for (var grade in gradeDataList) {
      yearlyGPA[grade.year!.toInt()] = (yearlyGPA[grade.year!.toInt()] ?? 0.0) +
          (grade.gpaWeight! * grade.creditHour!);
      yearlyCredits[grade.year!.toInt()] =
          (yearlyCredits[grade.year!.toInt()] ?? 0.0) + grade.creditHour!;
    }

    final trendData = yearlyGPA.entries
        .map((entry) => FlSpot(
              entry.key.toDouble(),
              (entry.value / (yearlyCredits[entry.key] ?? 1.0)),
            ))
        .toList();

    return LineChartBarData(
      spots: trendData,
      isCurved: true,
      dotData: const FlDotData(show: true),
      color: const Color(0xFF4B39EF),
    );
  }
}

class OverallGPAWidget extends StatelessWidget {
  final double overallGPA;

  const OverallGPAWidget({super.key, required this.overallGPA});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Overall GPA",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            Text(overallGPA.toStringAsFixed(2),
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}
