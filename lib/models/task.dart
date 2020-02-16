import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Task {
  String title;
  String description;
  DateTime date;
  DateTime timestamp;
  TimeOfDay time;

  Task({
    this.title,
    this.description,
    this.date,
    this.timestamp,
    this.time,
  });

  factory Task.fromDoc(DocumentSnapshot doc) {
    return Task(
      title: doc['title'],
      description: doc['description'],
      date: (doc['date'] as Timestamp).toDate(),
      timestamp: (doc['timeStamp'] as Timestamp).toDate(),
      time: doc['timeOfDay'],
    );
  }
}
