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

  factory Task.fromDoc(DocumentSnapshot doc) {
    return Task(
      id: doc.documentID,
      title: doc['title'],
      description: doc['description'],
      date: doc['date'] != null ? (doc['date'] as Timestamp).toDate() : null,
      timestamp: (doc['timeStamp'] as Timestamp).toDate(),
      time: doc['hasTime']
          ? TimeOfDay.fromDateTime(DateTime.parse(doc['time']))
          : null,
      isEveryDay: doc['isEveryDay'],
      hasTime: doc['hasTime'],
      done: doc['done'],
    );
  }
}
