class CafeSchedule {
  final int id;
  final String dayOfWeek;
  final String mealName;
  final String? mealImageUrl;
  final String mealTimeName;
  final DateTime startTime;
  final DateTime endTime;

  CafeSchedule({
    required this.id,
    required this.dayOfWeek,
    required this.mealName,
    this.mealImageUrl,
    required this.mealTimeName,
    required this.startTime,
    required this.endTime,
  });

  factory CafeSchedule.fromMap(Map<String, dynamic> data) {
    final now = DateTime.now();
    final startTimeParts =
        (data['CafeMealTime']['startTime'] as String).split(':');
    final endTimeParts = (data['CafeMealTime']['endTime'] as String).split(':');

    return CafeSchedule(
      id: data['id'] as int,
      dayOfWeek: data['DayOfWeek']['name'] as String? ?? 'Unknown Day',
      mealName: data['CafeMeal']['name'] as String? ?? 'Unknown Meal',
      mealImageUrl: data['CafeMeal']['imageUrl'] as String?,
      mealTimeName: data['CafeMealTime']['name'] as String? ?? 'Unknown Time',
      startTime: DateTime(now.year, now.month, now.day,
          int.parse(startTimeParts[0]), int.parse(startTimeParts[1])),
      endTime: DateTime(now.year, now.month, now.day,
          int.parse(endTimeParts[0]), int.parse(endTimeParts[1])),
    );
  }
}
