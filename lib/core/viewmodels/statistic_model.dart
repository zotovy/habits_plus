import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:habits_plus/core/enums/habitType.dart';
import 'package:habits_plus/core/enums/viewstate.dart';
import 'package:habits_plus/core/models/habit.dart';
import 'package:habits_plus/core/models/statistic.dart';
import 'package:habits_plus/core/util/constant.dart';
import 'package:habits_plus/core/viewmodels/base_model.dart';
import 'package:habits_plus/core/viewmodels/home_model.dart';
import 'package:habits_plus/ui/widgets/statistic/all_habits_stat.dart';

import '../../locator.dart';

class StatisticViewModel extends BaseViewModel {
  HomeViewModel _homeViewModel = locator<HomeViewModel>();

  List<Habit> _habits = [];
  List<WeekStatHabit> _weekHabits = [];
  List<FlSpot> _monthHabits = [];
  List<TopHabitStat> _topHabits = [];
  List<DailyPerfomance> dailyProgress = [];

  AllHabitStatData _allHabitStatData;

  List<Habit> get habits => _habits;
  List<WeekStatHabit> get weekHabit => _weekHabits;
  List<FlSpot> get monthHabits => _monthHabits;
  List<TopHabitStat> get topHabits => _topHabits;
  AllHabitStatData get allHabitStatData => _allHabitStatData;

  void setupHabits() {
    _habits = _homeViewModel.habits;
    setAllHabitsStat();
    setWeekStats();
    setMonthStats();
    setDailyProgress();
    setTopHabits();
    setState(ViewState.Idle);
  }

  void setHabitsNotification(int i, bool val) {
    habits[i].hasReminder = val;
    notifyListeners();
  }

  void updateViewHabit(Habit habit) {
    int id = habits.indexWhere((Habit elem) => elem.id == habit.id);
    habits[id] = habit;
    setAllHabitsStat();
    setWeekStats();
    setMonthStats();
    setDailyProgress();
    setTopHabits();
    notifyListeners();
  }

  void setAllHabitsStat() {
    int _done = 0;
    double _summOfPercentage = 0;
    for (var i = 0; i < _habits.length; i++) {
      DateTime now = dateFormater.parse(
        DateTime.now().toString(),
      );
      bool hasDate = _habits[i].type == HabitType.Uncountable
          ? _habits[i].progressBin.contains(now)
          : _habits[i].countableProgress[now] != null;

      if (hasDate) _done += 1;

      if (_habits[i].type == HabitType.Uncountable) {
        _summOfPercentage +=
            _habits[i].progressBin.length / _habits[i].goalAmount;
      } else {
        int _doneAmount = 0;
        for (var j in _habits[i].countableProgress.keys) {
          _doneAmount += _habits[i].countableProgress[j][0];
        }
        _summOfPercentage += _doneAmount / _habits[i].goalAmount;
      }

      _allHabitStatData = AllHabitStatData(
        all: _habits.length,
        today: locator<HomeViewModel>().todayHabits.length,
        done: _done,
        percent: (_summOfPercentage / _habits.length * 100).toInt(),
      );
    }
    _allHabitStatData = _allHabitStatData == null
        ? AllHabitStatData(all: 0, today: 0, done: 0, percent: 0)
        : _allHabitStatData;
  }

  void setWeekStats() {
    _weekHabits = [];

    DateTime now = dateFormater.parse(DateTime.now().toString());
    DateTime weekStart = now.subtract(Duration(days: now.weekday - 1));
    DateTime weekEnd = now.add(Duration(days: 7 - now.weekday));

    for (var habit in _habits) {
      if (habit.isDisable) continue;

      DateTime start = habit.duration[0];
      DateTime end = habit.duration[1];
      int diff = start.difference(end).inDays.abs() + 1;

      bool isThisWeek = false;
      for (var i = 0; i < diff; i++) {
        DateTime date = start.add(Duration(days: i));
        if (weekEnd.isAfter(date) && weekStart.isBefore(date) ||
            date == weekStart ||
            date == weekEnd) {
          isThisWeek = true;
          break;
        }
      }
      if (!isThisWeek) continue;

      if (habit.type == HabitType.Uncountable) {
        // count all
        int countAll = 0;
        habit.repeatDays.forEach((val) => val ? countAll += 1 : 0);

        // count completed
        int completed = 0;
        for (var date in habit.progressBin) {
          bool isThisWeek = weekEnd.isAfter(date) && weekStart.isBefore(date) ||
              date == weekStart ||
              date == weekEnd;

          if (isThisWeek) completed += 1;
        }

        // calc percent
        double percent = completed / countAll;

        WeekStatHabit _habit = WeekStatHabit(
          origin: habit,
          allWeek: countAll,
          doneWeek: completed,
          percent: percent,
        );

        _weekHabits.add(_habit);
      } else {
        // count all
        int countAll = 0;
        habit.repeatDays.forEach((val) => val ? countAll += 1 : 0);

        // count completed
        int completed = 0;
        for (var date in habit.countableProgress.keys) {
          DateTime _date = dateFormater.parse(date);
          bool isThisWeek =
              weekEnd.isAfter(_date) && weekStart.isBefore(_date) ||
                  _date == weekStart ||
                  _date == weekEnd;

          if (isThisWeek) completed += 1;
        }

        // calc percent
        double percent = completed / countAll;

        WeekStatHabit _habit = WeekStatHabit(
          origin: habit,
          allWeek: countAll,
          doneWeek: completed,
          percent: percent,
        );

        _weekHabits.add(_habit);
      }

      // Sort
      for (var i = 0; i < _weekHabits.length; i++) {
        for (var j = 0; j < _weekHabits.length - 1; j++) {
          if (_weekHabits[j].percent < _weekHabits[j + 1].percent) {
            WeekStatHabit tmp = _weekHabits[j];
            _weekHabits[j] = _weekHabits[j + 1];
            _weekHabits[j + 1] = tmp;
          }
        }
      }
    }
  }

  void setMonthStats() {
    _monthHabits = [];

    DateTime now = dateFormater.parse(DateTime.now().toString());
    var beginningNextMonth = (now.month < 12)
        ? new DateTime(now.year, now.month + 1, 1)
        : new DateTime(now.year + 1, 1, 1);
    DateTime monthStart = new DateTime(now.year, now.month, 1);
    DateTime monthEnd = beginningNextMonth.subtract(Duration(days: 1));

    List<int> all = now.month == 2 ? [0, 0, 0, 0, 0, 0] : [0, 0, 0, 0, 0, 0, 0];
    List done = now.month == 2 ? [0, 0, 0, 0, 0, 0] : [0, 0, 0, 0, 0, 0, 0];

    for (var habit in _habits) {
      int diff =
          habit.duration[0].difference(habit.duration[1]).inDays.abs() + 1;
      DateTime start = habit.duration[0];

      if (habit.type == HabitType.Uncountable) {
        for (var i = 0; i < diff; i++) {
          // All
          DateTime date = start.add(Duration(days: i));
          if (habit.repeatDays[date.weekday - 1]) {
            if (date.isAfter(monthStart) && date.isBefore(monthEnd) ||
                date == monthStart ||
                date == monthStart) {
              all[(date.day / 5).floor()]++;
            }
          }
        }

        // Done
        for (var date in habit.progressBin) {
          if (date.isAfter(monthStart) && date.isBefore(monthEnd) ||
              date == monthStart ||
              date == monthStart) {
            done[(date.day / 5).floor()]++;
          }
        }
      }
      //
      else {
        for (var i = 0; i < diff; i++) {
          // All
          DateTime date = start.add(Duration(days: i));
          if (habit.repeatDays[date.weekday - 1]) {
            if (date.isAfter(monthStart) && date.isBefore(monthEnd) ||
                date == monthStart ||
                date == monthStart) {
              all[(date.day / 5).floor()]++;
            }
          }
        }

        // Done
        for (var _date in habit.countableProgress.keys) {
          DateTime date = dateFormater.parse(_date);
          if (date.isAfter(monthStart) && date.isBefore(monthEnd) ||
              date == monthStart ||
              date == monthStart) {
            done[(date.day / 5).floor()]++;
          }
        }
      }
    }

    for (var i = 0; i < all.length; i++) {
      _monthHabits.add(
        FlSpot(
          (i * 5).toDouble(),
          all[i] == 0 ? 0.0 : ((done[i] / all[i]) * 100).toInt().toDouble(),
        ),
      );
    }
  }

  void setDailyProgress() {
    DateTime now = dateFormater.parse(DateTime.now().toString());
    var beginningNextMonth = (now.month < 12)
        ? new DateTime(now.year, now.month + 1, 1)
        : new DateTime(now.year + 1, 1, 1);
    DateTime monthStart = new DateTime(now.year, now.month, 1);
    DateTime monthEnd = beginningNextMonth.subtract(Duration(days: 1));
    int monthDiff = monthStart.difference(monthEnd).inDays.abs();

    int countWorkingHabits = 0;
    List<int> countDone = [0, 0, 0, 0, 0, 0, 0];

    dailyProgress = [];

    for (var habit in _habits) {
      if (habit.isDisable) continue;

      int diff =
          habit.duration[0].difference(habit.duration[1]).inDays.abs() + 1;

      for (var i = 0; i < diff; i++) {
        DateTime date = habit.duration[0].add(Duration(days: i));
        bool isThisMonth =
            monthEnd.isAfter(date) && monthStart.isBefore(date) ||
                date == monthStart ||
                date == monthEnd;

        if (isThisMonth) {
          countWorkingHabits += 1;
          for (var j = 0; j < 7; j++) {
            if (habit.repeatDays[j]) countDone[j]++;
          }
          break;
        }
      }
    }

    for (var i = 0; i < 7; i++) {
      dailyProgress.add(
        DailyPerfomance(
          countWorkingHabits == 0 ? 0 : countDone[i] / countWorkingHabits * 100,
        ),
      );
    }
  }

  void setTopHabits() {
    DateTime now = dateFormater.parse(DateTime.now().toString());
    var beginningNextMonth = (now.month < 12)
        ? new DateTime(now.year, now.month + 1, 1)
        : new DateTime(now.year + 1, 1, 1);
    DateTime monthStart = new DateTime(now.year, now.month, 1);
    DateTime monthEnd = beginningNextMonth.subtract(Duration(days: 1));

    _topHabits = [];

    for (var habit in _habits) {
      if (habit.isDisable) continue;

      DateTime start = habit.duration[0];
      DateTime end = habit.duration[1];
      int diff = start.difference(end).inDays.abs() + 1;

      bool _isThisMonth = false;
      for (var i = 0; i < diff; i++) {
        DateTime date = start.add(Duration(days: i));
        if (monthEnd.isAfter(date) && monthStart.isBefore(date) ||
            date == monthStart ||
            date == monthEnd) {
          _isThisMonth = true;
          break;
        }
      }
      if (!_isThisMonth) continue;

      if (habit.type == HabitType.Uncountable) {
        // count all
        int countAll = 0;
        for (var i = 0; i < diff; i++) {
          // All
          DateTime date = start.add(Duration(days: i));
          if (habit.repeatDays[date.weekday - 1]) {
            if (date.isAfter(monthStart) && date.isBefore(monthEnd) ||
                date == monthStart ||
                date == monthStart) {
              countAll++;
            }
          }
        }

        // count completed
        int completed = 0;
        for (var date in habit.progressBin) {
          bool isThisMonth =
              monthEnd.isAfter(date) && monthStart.isBefore(date) ||
                  date == monthStart ||
                  date == monthEnd;

          if (isThisMonth) completed += 1;
        }

        // calc percent
        int percent = (completed / countAll * 100).toInt();

        TopHabitStat _habit = TopHabitStat(
          origin: habit,
          percent: percent,
        );
        topHabits.add(_habit);
      } else {
        // count all
        int countAll = 0;
        habit.repeatDays.forEach((val) => val ? countAll += 1 : 0);

        // count completed
        int completed = 0;
        for (var date in habit.countableProgress.keys) {
          DateTime _date = dateFormater.parse(date);
          bool isThisMonth =
              monthEnd.isAfter(_date) && monthStart.isBefore(_date) ||
                  _date == monthStart ||
                  _date == monthEnd;

          if (isThisMonth) completed += 1;
        }

        // calc percent
        int percent = (completed / countAll * 100).toInt();
        TopHabitStat _habit = TopHabitStat(
          origin: habit,
          percent: percent,
        );
        topHabits.add(_habit);
      }
    }

    //  bubble sort
    for (var i = 0; i < topHabits.length; i++) {
      for (var j = 0; j < topHabits.length - 1; j++) {
        if (topHabits[j].percent < topHabits[j + 1].percent) {
          TopHabitStat tmp = topHabits[j];
          topHabits[j] = topHabits[j + 1];
          topHabits[j + 1] = tmp;
        }
      }
    }
  }
}
