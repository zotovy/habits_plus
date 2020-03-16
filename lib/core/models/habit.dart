import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Habit {
  String id;
  String title;
  String description;
  int type; // 0 is uncountable type; 1 is an countable
  bool isDisable; // firstly - false
  bool hasReminder;
  DateTime timeStamp;
  TimeOfDay timeOfDay;
  int colorCode; // more info on github
  List<bool> repeatDays;
  List<dynamic> progressBin;
  Map progressBinByDate;
  List progressDateTimeById;
  int timesADay;

  Habit({
    this.id,
    this.title,
    this.description,
    this.type,
    this.isDisable,
    this.hasReminder,
    this.timeStamp,
    this.timeOfDay,
    this.colorCode,
    this.repeatDays,
    this.timesADay,
    this.progressBin,
    this.progressBinByDate,
    this.progressDateTimeById,
  });

  factory Habit.fromDoc(DocumentSnapshot doc) {
    // Implement repeat days
    String str = doc['repeatDays'];
    List<bool> repeatDays = [];
    for (var i = 0; i < str.length; i++) {
      repeatDays.add(str[i] == '1' ? true : false);
    }

    // Create habit
    return Habit(
      id: doc.documentID,
      title: doc['title'],
      description: doc['description'],
      type: doc['type'],
      isDisable: doc['isDisable'],
      hasReminder: doc['hasReminder'],
      timeStamp: (doc['timeStamp'] as Timestamp).toDate(),
      timeOfDay: doc['timeToRemind'] != '' && doc['timeToRemind'] != null
          ? TimeOfDay.fromDateTime(DateTime.parse(doc['timeToRemind']))
          : null,
      colorCode: doc['colorCode'],
      repeatDays: repeatDays,
      timesADay: doc['timesADay'],
      progressBin: doc['progressBin'].toList(),
      progressBinByDate: doc['progressBinByDate'],
      progressDateTimeById: doc['progressDateTimeById'],
    );
  }
}
