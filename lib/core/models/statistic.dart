import 'package:habits_plus/core/models/habit.dart';

class WeekStatHabit {
  Habit origin;

  double percent;
  int doneWeek;
  int allWeek;

  WeekStatHabit({
    this.origin,
    this.percent,
    this.doneWeek,
    this.allWeek,
  });

  String get doneProgress => '$doneWeek/$allWeek';
  String get title => origin.title;
}

class DailyPerfomance {
  double y;

  DailyPerfomance(this.y);
}

class TopHabitStat {
  Habit origin;

  int percent;

  TopHabitStat({
    this.origin,
    this.percent,
  });
}
