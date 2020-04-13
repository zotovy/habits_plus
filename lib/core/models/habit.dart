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
  List<bool> repeatDays;
  int goalAmount;
  int iconCode;
  int almostDone; // Todo: add to create page
  List<DateTime> progressBin;

  /// List<DateTime, List>
  Map countableProgress;
  int timesADay;

  double percent;

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
    this.countableProgress,
    this.percent,
  });

  factory Habit.fromDoc(DocumentSnapshot doc) {
    // Implement repeat days
    String str = doc['repeatDays'];
    List<bool> repeatDays = [];
    for (var i = 0; i < str.length; i++) {
      repeatDays.add(str[i] == '1' ? true : false);
    }

    List<DateTime> progressBin = (doc['progressBin'] as List)
        .map(
          (val) => (val as Timestamp).toDate(),
        )
        .toList();
    List<DateTime> duration = (doc['duration'] as List)
        .map(
          (val) => (val as Timestamp).toDate(),
        )
        .toList();
    HabitType type =
        doc['type'] == 1 ? HabitType.Countable : HabitType.Uncountable;
    Map countableProgress =
        doc['countableProgress'] == null ? {} : doc['countableProgress'];

    // Setup percentage
    DateTime now = DateTime.now();
    DateTime weekStart = dateFormater.parse(
      now.subtract(Duration(days: now.weekday - 1)).toString(),
    );
    DateTime weekEnd = now.add(Duration(days: 7 - now.weekday));
    var completions = 0;
    var all = 0;
    if (type == HabitType.Uncountable) {
      for (var j = 0; j < progressBin.length; j++) {
        DateTime date = progressBin[j];
        if (date.isAfter(weekStart) && date.isBefore(weekEnd) ||
            date == weekStart ||
            date == weekEnd) {
          completions++;
        }
      }
    } else {
      for (var item in countableProgress.keys) {
        DateTime date = dateFormater.parse(item);
        if (date.isAfter(weekStart) && date.isBefore(weekEnd) ||
            date == weekStart ||
            date == weekEnd) {
          completions++;
        }
      }
    }

    DateTime start = duration[0], end = duration[1];
    List<DateTime> dates = [];

    // Check is habit off
    if (!doc['disable']) {
      // init start
      if (start.weekday != 1) {
        start = start.subtract(
          Duration(days: start.weekday - 1),
        );
      }

      // init end
      if (end.weekday != 7) {
        end = end.add(
          Duration(days: 7 - end.weekday),
        );
      }

      // start --> end
      for (var j = 0; j < start.difference(end).inDays.abs() + 1; j++) {
        // If j-day (from start) is used i-habit
        if (repeatDays[j % 7]) {
          DateTime currentDate = start.add(Duration(days: j));

          dates.add(dateFormater.parse(currentDate.toString()));
        }
      }
    }

    DateTime _weekStart = weekStart;
    for (var j = 0; j <= 7; j++) {
      if (dates != null) {
        if (dates.contains(_weekStart.add(Duration(days: j)))) {
          all++;
        }
      }
    }

    var percent = all == 0 ? 0 : completions / all;

    // Create habit
    return Habit(
      id: doc.documentID,
      title: doc['title'],
      description: doc['description'],
      type: type,
      goalAmount: doc['goalAmount'],
      almostDone: doc['almostDone'],
      iconCode: doc['iconCode'],
      isDisable: doc['disable'],
      hasReminder: doc['hasReminder'],
      timeStamp: (doc['timeStamp'] as Timestamp).toDate(),
      duration: duration,
      timeOfDay: doc['timeToRemind'] != '' && doc['timeToRemind'] != null
          ? TimeOfDay.fromDateTime((doc['timeToRemind'] as Timestamp).toDate())
          : null,
      repeatDays: repeatDays,
      timesADay: doc['timesADay'],
      progressBin: progressBin,
      countableProgress: countableProgress,
      percent: percent.toDouble(),
    );
  }

  bool getDoneProperty(DateTime date) {
    DateTime _date = dateFormater.parse(date.toString());
    return progressBin.contains(_date);
  }
}
