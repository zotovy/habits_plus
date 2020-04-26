import 'package:habits_plus/core/models/habit.dart';

class HabitNotification {
  Habit habit;
  String habitId;
  int notificationId;
  String title;
  String description;
  DateTime date;
  bool isOf;
  bool isHabitDelete;

  HabitNotification({
    this.habit,
    this.habitId,
    this.title,
    this.description,
    this.date,
    this.isOf,
    this.isHabitDelete,
  });

  Map<String, dynamic> toJson() {
    return {
      'habit': habit.toJson(),
      'habitId': habitId,
      'notificationId': notificationId,
      'title': title,
      'description': description,
      'date': date.toString(),
      'isOf': isOf,
      'isHabitDelete': isHabitDelete,
    };
  }

  factory HabitNotification.fromJson(Map<String, dynamic> json) {
    return HabitNotification(
      habit: Habit.fromJson(json['habit']),
      habitId: json['habitId'],
      title: json['title'],
      description: json['description'],
      date: DateTime.parse(json['date']),
      isOf: json['isOf'],
      isHabitDelete: json['isHabitDelete'],
    );
  }
}
