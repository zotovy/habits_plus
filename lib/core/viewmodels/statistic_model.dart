import 'package:habits_plus/core/enums/viewstate.dart';
import 'package:habits_plus/core/models/habit.dart';
import 'package:habits_plus/core/util/constant.dart';
import 'package:habits_plus/core/viewmodels/base_model.dart';
import 'package:habits_plus/core/viewmodels/home_model.dart';

import '../../locator.dart';

class StatisticViewModel extends BaseViewModel {
  HomeViewModel _homeViewModel = locator<HomeViewModel>();

  List<Habit> _habits = [];
  List<Habit> _weekHabits = [];
  List<Habit> _monthHabits = [];
  List<Habit> _topHabits = [];

  Map<int, List<DateTime>> _habitsDate = {};
  Map<String, int> weekStats = {};
  Map monthStats = {};

  List<Habit> get habits => _habits;
  List<Habit> get weekHabit => _weekHabits;
  List<Habit> get monthHabit => _monthHabits;
  List<Habit> get topHabits => _topHabits;

  void setupHabits() {
    _habits = _homeViewModel.habits;
    setMarkedDates();
    setHabitsDates();
    setWeekStats();
    setMonthStats();
    setTopHabits();
    setState(ViewState.Idle);
  }

  void setMarkedDates() {
    _habitsDate = {};
    for (var i = 0; i < _habits.length; i++) {
      DateTime start = _habits[i].duration[0], end = _habits[i].duration[1];

      // Check is habit off
      if (_habits[i].isDisable) {
        continue;
      }

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
        if (_habits[i].repeatDays[j % 7]) {
          DateTime currentDate = start.add(Duration(days: j));

          _habitsDate[i] == null
              ? _habitsDate[i] = [dateFormater.parse(currentDate.toString())]
              : _habitsDate[i].add(dateFormater.parse(currentDate.toString()));
        }
      }
      if (_habitsDate[i] == null) {
        _habitsDate[i] = [];
      }
    }
  }

  void setHabitsDates() {
    // Format date
    DateTime now = DateTime.now();
    var beginningNextMonth = (now.month < 12)
        ? new DateTime(now.year, now.month + 1, 1)
        : new DateTime(now.year + 1, 1, 1);
    DateTime monthStart = new DateTime(now.year, now.month, 1);
    DateTime monthEnd = beginningNextMonth.subtract(Duration(days: 1));
    DateTime weekStart = now.subtract(Duration(days: now.weekday - 1));
    DateTime weekEnd = now.add(Duration(days: 7 - now.weekday));

    _weekHabits = [];
    _monthHabits = [];

    for (var i = 0; i < _habits.length; i++) {
      // Check is disable
      if (_habits[i].isDisable) {
        continue;
      }

      for (var j = 0; j < _habitsDate[i].length; j++) {
        DateTime date = _habitsDate[i][j];
        if (date.isAfter(monthStart) && date.isBefore(monthEnd) ||
            date == monthStart ||
            date == monthEnd) {
          if (!_monthHabits.contains(_habits[i])) {
            _monthHabits.add(_habits[i]);
          }
        }
        if (date.isAfter(weekStart) && date.isBefore(weekEnd) ||
            date == weekStart ||
            date == weekEnd) {
          if (!_weekHabits.contains(_habits[i])) {
            _weekHabits.add(_habits[i]);
          }
        }
      }
    }
  }

  void setWeekStats() {
    DateTime now = dateFormater.parse(DateTime.now().toString());
    DateTime weekStart = now.subtract(Duration(days: now.weekday - 1));
    DateTime weekEnd = now.add(Duration(days: 7 - now.weekday));

    int completions = 0;
    for (var i = 0; i < _weekHabits.length; i++) {
      for (var j = 0; j < _weekHabits[i].progressBin.length; j++) {
        DateTime date = _weekHabits[i].progressBin[j];
        if (date.isAfter(weekStart) && date.isBefore(weekEnd) ||
            date == weekStart ||
            date == weekEnd) {
          completions++;
        }
      }
    }

    int all = 0;

    for (var i = 0; i < _habits.length; i++) {
      // Check is habit disable

      DateTime _weekStart = weekStart;
      for (var j = 0; j < 7; j++) {
        if (_habitsDate[i] != null) {
          if (_habitsDate[i].contains(_weekStart.add(Duration(days: j)))) {
            all++;
          }
        }
      }
    }

    weekStats = {
      'count': _weekHabits.length,
      'completions': completions,
      'percent': all == 0 ? 0 : (completions / all * 100).toInt(),
    };
  }

  void setMonthStats() {
    DateTime now = dateFormater.parse(DateTime.now().toString());
    var beginningNextMonth = (now.month < 12)
        ? new DateTime(now.year, now.month + 1, 1)
        : new DateTime(now.year + 1, 1, 1);
    DateTime monthStart = new DateTime(now.year, now.month, 1);
    DateTime monthEnd = beginningNextMonth.subtract(Duration(days: 1));

    List<int> data = now.month == 2 ? [0, 0, 0, 0, 0] : [0, 0, 0, 0, 0, 0];
    int completions = 0;
    for (var i = 0; i < _weekHabits.length; i++) {
      for (var j = 0; j < _weekHabits[i].progressBin.length; j++) {
        DateTime date = _weekHabits[i].progressBin[j];
        if (date.isAfter(monthStart) && date.isBefore(monthEnd) ||
            date == monthStart ||
            date == monthEnd) {
          completions++;
          data[(date.day / 5).floor()] += 1;
        }
      }
    }

    int all = 0;

    for (var i = 0; i < _habits.length; i++) {
      // Check is habit disable

      DateTime _mon = monthStart;
      for (var j = 0;
          j < monthStart.difference(monthEnd).inDays.abs() + 1;
          j++) {
        if (_habitsDate[i] != null) {
          if (_habitsDate[i].contains(monthStart.add(Duration(days: j)))) {
            all++;
          }
        }
      }
    }

    monthStats = {
      'chart': data,
      'percent': all == 0 ? 0 : (completions / all * 100).toInt(),
    };
  }

  List<Habit> bubbleSort(List<Habit> list) {
    if (list == null || list.length == 0) return [];

    int n = list.length;
    int i, step;
    for (step = 0; step < n; step++) {
      for (i = 0; i < n - step - 1; i++) {
        if (list[i].progressBin.length / list[i].goalAmount >
            list[i + 1].progressBin.length / list[i + 1].goalAmount) {
          Habit temp = list[i];
          list[i] = list[i + 1];
          list[i + 1] = temp;
        }
      }
    }
    return list;
  }

  void setTopHabits() {
    _topHabits = bubbleSort(_monthHabits).reversed.toList();
  }
}
