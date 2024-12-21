class GradeData {
  final String? courseName;
  final num? grade;
  final num? gpaWeight;
  final num? creditHour;
  final String? semester;
  final num? year;

  GradeData({
    this.courseName,
    this.grade,
    this.gpaWeight,
    this.creditHour,
    this.semester,
    this.year,
  });

  factory GradeData.fromJson(Map<String, dynamic> json) {
    return GradeData(
      courseName: json['courseName'],
      grade: _letterToGradeConverter(json['grade']),
      gpaWeight: json['gpaWeight'],
      creditHour: json['creditHour'],
      semester: json['semester'],
      year: json['year'],
    );
  }
  static double _letterToGradeConverter(String letter) {
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
    return gradeScale[letter] ?? 0.0;
  }

  @override
  String toString() {
    return 'GradeData{courseName: $courseName, grade: $grade, gpaWeight: $gpaWeight, creditHour: $creditHour, semester: $semester, year: $year}';
    return super.toString();
  }
}
