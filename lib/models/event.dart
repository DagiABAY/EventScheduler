
import 'package:flutter/material.dart';

class Events {
  final int? id;
  final String title;
  final String description;
  final TimeOfDay startTime;
  final TimeOfDay endTime;
  final String type;
 // final List<String> imagePaths;
  final String date;
  Events({
    this.id,
    required this.title,
    required this.description,
    required this.startTime,
    required this.endTime,
    required this.type,
   // required this.imagePaths,
    required this.date,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'startTime': EventUtils.timeOfDayToString(startTime),
      'endTime': EventUtils.timeOfDayToString(endTime),
      'type': type,
      //'imagePaths': jsonEncode(imagePaths),
      'date': date,
    };
  }

  static Events fromMap(Map<String, dynamic> map) {
    return Events(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      startTime: EventUtils.stringToTimeOfDay(map['startTime']),
      endTime: EventUtils.stringToTimeOfDay(map['endTime']),
      type: map['type'],
      //imagePaths: List<String>.from(jsonDecode(map['imagePaths'])),
      date: map['date'],
    );
  }
}

class EventUtils {
  static String timeOfDayToString(TimeOfDay time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }

  static TimeOfDay stringToTimeOfDay(String timeString) {
    final parts = timeString.split(':');
    final hour = int.parse(parts[0]);
    final minute = int.parse(parts[1]);
    return TimeOfDay(hour: hour, minute: minute);
  }
}
