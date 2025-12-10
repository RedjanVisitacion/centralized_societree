import 'package:flutter/material.dart';

class Schedule {
  final String subject;
  final String instructor;
  final String room;
  final String days;
  final TimeOfDay? startTime;
  final TimeOfDay? endTime;

  Schedule({
    required this.subject,
    required this.instructor,
    required this.room,
    required this.days,
    this.startTime,
    this.endTime,
  });
}

class ScheduleStore extends ChangeNotifier {
  final List<Schedule> _schedules = [
    Schedule(
      subject: 'Flutter Development',
      instructor: 'Dr. Jane Smith',
      room: 'Room 101',
      days: 'Mon, Wed, Fri',
    ),
    Schedule(
      subject: 'Data Structures',
      instructor: 'Prof. John Davis',
      room: 'Room 205',
      days: 'Tue, Thu',
    ),
  ];

  List<Schedule> get schedules => List.unmodifiable(_schedules);

  void addSchedule(Schedule schedule) {
    _schedules.add(schedule);
    notifyListeners();
  }

  void removeAt(int index) {
    if (index >= 0 && index < _schedules.length) {
      _schedules.removeAt(index);
      notifyListeners();
    }
  }

  void clear() {
    _schedules.clear();
    notifyListeners();
  }
}

final scheduleStore = ScheduleStore();
