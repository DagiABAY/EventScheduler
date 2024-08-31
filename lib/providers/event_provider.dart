import 'dart:math';

import 'package:flutter/material.dart';
import 'package:sample_test_app_for_job/databases/data_base.dart';
import 'package:sample_test_app_for_job/models/event.dart';
import 'package:sample_test_app_for_job/providers/local_notification.dart';

class EventsProvider extends ChangeNotifier {
  List<Events> events = [];
  Map<int, List<Color>> _gradients = {};

  final titleEdditnigController = TextEditingController();
  final descriptionEdditngController = TextEditingController();
  TimeOfDay? startTime;
  TimeOfDay? endTime;

  List<Events> get getEvents => events;

  void addEvent(Events event) async {
    await DatabaseHelper.instance.insert(event);
    events.add(event);
    await LocalNoti.showScheduledForEvent(event);
    notifyListeners();
  }

  Future<void> loadEventsForDate(String date) async {
    events = await DatabaseHelper.instance.getEventsForDate(date);
    notifyListeners();
  }

  List<Color> getGradient(int eventId) {
    if (!_gradients.containsKey(eventId)) {
      _gradients[eventId] = _generateRandomColors(
        3,
        const Color(0xFFd2bb9c),
        const Color(0xFF3c385b),
      );
    }
    return _gradients[eventId]!;
  }

  List<Color> _generateRandomColors(
      int numberOfColors, Color startColor, Color endColor) {
    final Random random = Random();
    final List<Color> colors = [];
    for (int i = 0; i < numberOfColors; i++) {
      double t = random.nextDouble();
      Color color = Color.lerp(startColor, endColor, t)!;
      colors.add(color);
    }
    return colors;
  }

  void deleteEvent(Events event) async {
    await DatabaseHelper.instance.delete(event.id!);
    events.removeWhere((e) => e.id == event.id);
    _gradients.remove(event.id);
    notifyListeners();
  }

  void updateEvent(Events updatedEvent) async {
    await DatabaseHelper.instance.update(updatedEvent);
    final index = events.indexWhere((e) => e.id == updatedEvent.id);
    if (index != -1) {
      events[index] = updatedEvent;
      await LocalNoti.showScheduledForEvent(events[index]);
    }

    notifyListeners();
  }
}
