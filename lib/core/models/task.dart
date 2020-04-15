import 'package:cloud_firestore/cloud_firestore.dart';
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

  Task.fromJson(Map<String, dynamic> json) {
    Task(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      date: json['date'] != null ? json['date'] : null,
      timestamp: json['timeStamp'],
      time: json['hasTime'] ? json['time'] : null,
      isEveryDay: json['isEveryDay'],
      hasTime: json['hasTime'],
      done: json['done'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'date': date,
      'timestamp': timestamp,
      'time': time,
      'isEveryDay': isEveryDay,
      'hasTime': hasTime,
      'done': done,
    };
  }
}
