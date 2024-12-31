import 'package:aastu_hub/screens/lounges/lounge_screen.dart';
import 'package:flutter/material.dart';

import 'beverage.dart';
import 'food.dart';

class Lounge {
  final int? id;
  final String? name;
  final double? latitude;
  final double? longitude;
  final String? imageUrl;
  final TimeOfDay? startTime;
  final TimeOfDay? endTime;
  final List<LoungeFood>? foods;
  final List<LoungeBeverage>? beverages;

  Lounge(
      {this.id,
      this.startTime,
      this.endTime,
      this.latitude,
      this.imageUrl,
      this.longitude,
      this.name,
      this.foods,
      this.beverages});

  factory Lounge.fromMap(Map<String, dynamic> map) {
    return Lounge(
      id: map['id'],
      name: map['name'],
      latitude: map['latitude'],
      longitude: map['longitude'],
      imageUrl: map['imageUrl'],
      startTime:
          map['startTime'] != null ? parseTimeOfDay(map['startTime']) : null,
      endTime: map['endTime'] != null ? parseTimeOfDay(map['endTime']) : null,
      foods: (map['Lounge_Food'] as List<dynamic>?)
          ?.map((e) => LoungeFood.fromMap(e))
          .toList(),
      beverages: (map['Lounge_Beverage'] as List<dynamic>?)
          ?.map((e) => LoungeBeverage.fromMap(e))
          .toList(),
    );
  }
}
