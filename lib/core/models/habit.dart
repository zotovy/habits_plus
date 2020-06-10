import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:habits_plus/core/enums/habitType.dart';
import 'package:habits_plus/core/models/comment.dart';
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
  int almostDone;
  List<DateTime> progressBin;
  List<Comment> comments;

  /// List<DateTime, List>
  Map countableProgress;
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
    this.countableProgress,
    this.comments,
  });

  factory Habit.fromJson(Map<String, dynamic> json) {
    return Habit(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      type: json['type'] ? HabitType.Countable : HabitType.Uncountable,
      goalAmount: json['goalAmount'],
      iconCode: json['iconCode'],
      almostDone: json['almostDone'],
      isDisable: json['isDisable'],
      hasReminder: json['hasReminder'],
      timeStamp: DateTime.parse(json['timeStamp']),
      duration: json['duration']
          .map(
            (_) => dateFormater.parse(_),
          )
          .toList()
          .cast<DateTime>(),
      timeOfDay: json['timeOfDay'] == null
          ? null
          : TimeOfDay.fromDateTime(DateTime.parse(json['timeOfDay'])),
      repeatDays: json['repeatDays'].cast<bool>(),
      comments: json['comments']
          .map(
            (_) {
              var tmp = Comment.fromJson(_);
              print(tmp.timestamp);
              return tmp;
            },
          )
          .toList()
          .cast<Comment>(),
      countableProgress: (json['countableProgress'] as Map).map(
        (key, val) => MapEntry(dateFormater.parse(key), val),
      ),
      progressBin: json['progressBin']
          .map(
            (val) => dateFormater.parse(val),
          )
          .toList()
          .cast<DateTime>(),
      timesADay: json['timesADay'],
    );
  }

  Map<String, dynamic> toJson() {
    DateTime now = DateTime.now();
    return {
      'id': id,
      'title': title,
      'description': description,
      'type': type == HabitType.Countable,
      'goalAmount': goalAmount,
      'iconCode': iconCode,
      'almostDone': almostDone,
      'isDisable': isDisable,
      'hasReminder': hasReminder,
      'timeStamp': timeStamp.toIso8601String(),
      'duration': duration
          .map(
            (date) => date.toString(),
          )
          .toList(),
      'timeOfDay': timeOfDay == null
          ? null
          : DateTime(
              now.year,
              now.month,
              now.day,
              timeOfDay.hour,
              timeOfDay.minute,
            ).toString(),
      'repeatDays': repeatDays,
      'comments': comments
          .map(
            (val) => val.toJson(),
          )
          .toList(),
      'countableProgress': countableProgress.map(
        (key, val) => MapEntry(key.toString(), val),
      ),
      'progressBin': progressBin
          .map(
            (val) => val.toString(),
          )
          .toList(),
      'timesADay': timesADay,
    };
  }

  Map<String, dynamic> toDocument() {
    DateTime now = DateTime.now();
    return {
      'id': id,
      'title': title,
      'description': description,
      'type': type == HabitType.Countable,
      'goalAmount': goalAmount,
      'iconCode': iconCode,
      'almostDone': almostDone,
      'isDisable': isDisable,
      'hasReminder': hasReminder,
      'timeStamp': Timestamp.fromDate(timeStamp),
      'duration': duration,
      'timeOfDay': timeOfDay == null
          ? null
          : DateTime(
              now.year,
              now.month,
              now.day,
              timeOfDay.hour,
              timeOfDay.minute,
            ),
      'repeatDays': repeatDays,
      'comments': comments
          .map(
            (val) => val.toJson(),
          )
          .toList(),
      'countableProgress': countableProgress.map(
        (key, val) => MapEntry(Timestamp.fromDate(key), val),
      ),
      'progressBin': progressBin
          .map(
            (val) => Timestamp.fromDate(val),
          )
          .toList(),
      'timesADay': timesADay,
    };
  }

  factory Habit.fromDocument(DocumentSnapshot snap) {
    return Habit(
      almostDone: snap.data['almostDone'],
      comments: snap.data['comments']
          .map((elem) => Comment.fromJson(elem))
          .toList()
          .cast<Comment>(),
      countableProgress: snap.data['countableProgress'],
      description: snap.data['description'],
      duration: snap.data['duration']
          .map((elem) => elem.toDate())
          .toList()
          .cast<DateTime>(),
      goalAmount: snap.data['goalAmount'],
      hasReminder: snap.data['hasReminder'],
      iconCode: snap.data['iconCode'],
      id: snap.documentID,
      isDisable: snap.data['isDisable'],
      progressBin: snap.data['progressBin']
          .map((elem) => elem.toDate())
          .toList()
          .cast<DateTime>(),
      repeatDays: snap.data['repeatDays'].cast<bool>(),
      timeOfDay: TimeOfDay.fromDateTime(snap.data['timeOfDay'].toDate()),
      timeStamp: snap.data['timeStamp'].toDate(),
      timesADay: snap.data['timesADay'],
      title: snap.data['title'],
      type: snap.data['type'] ? HabitType.Countable : HabitType.Uncountable,
    );
  }

  bool getDoneProperty(DateTime date) {
    DateTime _date = dateFormater.parse(date.toString());
    return progressBin.contains(_date);
  }
}
