import 'package:flutter/material.dart';

class Task {
  String id;
  String title;
  String description;
  DateTime date;
  DateTime timestamp;
  TimeOfDay time;
  bool isEveryDay;
  bool hasTime;
  bool done;

  Task({
    this.id,
    this.title,
    this.description,
    this.date,
    this.timestamp,
    this.time,
    this.isEveryDay,
    this.hasTime,
    this.done,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      date: DateTime.parse(json['date']),
      timestamp: DateTime.parse(json['timestamp']),
      time: json['hasTime']
          ? TimeOfDay.fromDateTime(
              DateTime.parse(
                json['time'],
              ),
            )
          : null,
      isEveryDay: json['isEveryDay'],
      hasTime: json['hasTime'],
      done: json['done'],
    );
  }

  Map<String, dynamic> toJson() {
    DateTime now = DateTime.now();
    return {
      'id': id,
      'title': title,
      'description': description,
      'date': date.toString(),
      'timestamp': timestamp.toString(),
      'time': hasTime
          ? DateTime(
              now.year,
              now.month,
              now.day,
              time.hour,
              time.minute,
            )
          : '',
      'isEveryDay': isEveryDay,
      'hasTime': hasTime,
      'done': done,
    };
  }
}
