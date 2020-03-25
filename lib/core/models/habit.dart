import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:habits_plus/core/enums/habitType.dart';
import 'package:habits_plus/core/util/constant.dart';

class Habit {
  String id;
  String title;
  String description;
  HabitType type;
  bool isDisable; // firstly - false
  bool hasReminder;
  DateTime timeStamp;
  List<DateTime> duration;
  TimeOfDay timeOfDay;
  bool hasImage;
  List<bool> repeatDays;
  int goalAmount;
  int iconCode;
  int almostDone; // Todo: add to create page
  List<DateTime> progressBin;
  int timesADay;

  Habit({
    this.id,
    this.title,
    this.description,
    this.type,
    this.goalAmount,
    this.iconCode,
    this.almostDone,
    this.isDisable,
    this.hasReminder,
    this.timeStamp,
    this.duration,
    this.timeOfDay,
    this.repeatDays,
    this.timesADay,
    this.progressBin,
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
      type: doc['type'] == 1 ? HabitType.Countable : HabitType.Uncountable,
      goalAmount: doc['goalAmount'],
      almostDone: doc['almostDone'],
      iconCode: doc['iconCode'],
      isDisable: doc['isDisable'],
      hasReminder: doc['hasReminder'],
      timeStamp: (doc['timeStamp'] as Timestamp).toDate(),
      duration: (doc['duration'] as List)
          .map(
            (val) => (val as Timestamp).toDate(),
          )
          .toList(),
      timeOfDay: doc['timeToRemind'] != '' && doc['timeToRemind'] != null
          ? TimeOfDay.fromDateTime(DateTime.parse(doc['timeToRemind']))
          : null,
      repeatDays: repeatDays,
      timesADay: doc['timesADay'],
      progressBin: (doc['progressBin'] as List)
          .map(
            (val) => (val as Timestamp).toDate(),
          )
          .toList(),
    );
  }

  bool getDoneProperty(DateTime date) {
    DateTime _date = dateFormater.parse(date.toString());
    return progressBin.contains(_date);
  }
}
