import 'package:habits_plus/core/enums/viewstate.dart';
import 'package:habits_plus/core/models/habit.dart';
import 'package:habits_plus/core/models/task.dart';
import 'package:habits_plus/core/services/database.dart';
import 'package:habits_plus/core/util/constant.dart';
import 'package:habits_plus/core/viewmodels/base_model.dart';
import 'package:habits_plus/locator.dart';

class HomeViewModel extends BaseViewModel {
  DatabaseServices _databaseServices = locator<DatabaseServices>();

  List<Habit> _habits = [];
  List<Task> _tasks = [];

  List<Habit> _todayHabits = [];
  List<Task> _todayTasks = [];
  List<Task> _doneTodayTasks = [];
  List<Task> _notDoneTodayTasks = [];
  bool _hasDoneTasks = false;
  bool _hasNotDoneTasks = false;

  List<DateTime> _markedDates = [];
  Map<int, List<DateTime>> _habitsDate = {};

  List<Habit> get habits => _habits;
  List<Task> get tasks => _tasks;

  List<DateTime> get markedDates => _markedDates;
  List<Habit> get todayHabits => _todayHabits;
  List<Task> get todayTasks => _todayTasks;
  List<Task> get doneTodayTasks => _doneTodayTasks;
  List<Task> get notDoneTodayTasks => _notDoneTodayTasks;
  bool get hasDoneTasks => _hasDoneTasks;
  bool get hasNotDoneTodayTasks => _hasNotDoneTasks;

  void fetch(String userId) async {
    setState(ViewState.Busy);
    _habits = await _databaseServices.getAllHabitsById(userId);
    _tasks = await _databaseServices.getAllTasksById(userId);
    setMarkedDates();
    setToday(DateTime.now());
    setState(ViewState.Idle);
  }

  void setMarkedDates() {
    // Get the nearest monday
    DateTime today = DateTime.now();
    DateTime _firstDayOfTheWeek = DateTime.now();
    if (today.weekday != 1) {
      _firstDayOfTheWeek = today.subtract(
        new Duration(days: today.weekday - 1),
      );
    }
    _firstDayOfTheWeek = _firstDayOfTheWeek.subtract(new Duration(days: 210));

    // Habits
    for (var i = 0; i < _habits.length; i++) {
      for (var j = 0; j < _habits[i].repeatDays.length; j++) {
        DateTime current = _firstDayOfTheWeek.add(Duration(days: j));
        if (_habits[i].repeatDays[j]) {
          for (var a = 0; a < 60; a++) {
            DateTime date = current.add(Duration(days: a * 7));
            _markedDates.add(date);

            _habitsDate[i] == null
                ? _habitsDate[i] = [dateFormater.parse(date.toString())]
                : _habitsDate[i].add(dateFormater.parse(date.toString()));
          }
        }
      }
    }

    // Tasks
    for (var i = 0; i < tasks.length; i++) {
      if (tasks[i].date != null) {
        _markedDates.add(tasks[i].date);
      }
    }

    _markedDates = _markedDates.toSet().toList();
  }

  void setToday(DateTime date) {
    // Format date
    date = dateFormater.parse(date.toString());

    // Habits
    _todayHabits = [];
    for (var i = 0; i < _habits.length; i++) {
      for (var j = 0; j < _habitsDate[i].length; j++) {
        if (_habitsDate[i][j] == dateFormater.parse(date.toString())) {
          todayHabits.add(habits[i]);
        }
      }
    }

    // Tasks
    _todayTasks = [];
    _doneTodayTasks = [];
    _notDoneTodayTasks = [];
    for (var i = 0; i < tasks.length; i++) {
      if (tasks[i].date != null) {
        if (dateFormater.format(tasks[i].date) == dateFormater.format(date)) {
          _todayTasks.add(tasks[i]);
          if (tasks[i].done) {
            _doneTodayTasks.add(tasks[i]);
          } else {
            _notDoneTodayTasks.add(tasks[i]);
          }
        }
      } else {
        _todayTasks.add(tasks[i]);
        if (tasks[i].done) {
          _doneTodayTasks.add(tasks[i]);
        } else {
          _notDoneTodayTasks.add(tasks[i]);
        }
      }

      // Set section view
      if (!tasks[i].done) {
        _hasNotDoneTasks = true;
      } else {
        _hasDoneTasks = true;
      }
    }
  }

  void addHabit(Habit habit) {
    _habits.add(habit);
    notifyListeners();
  }

  void addTask(Task task) {
    _tasks.add(task);
    notifyListeners();
  }

  void removeHabit(int i) {
    _habits.removeAt(i);
    notifyListeners();
  }

  void removeTask(int i) {
    _tasks.removeAt(i);
    notifyListeners();
  }

  void updateHabit(Habit habit, String userId) async {
    await _databaseServices.updateHabit(habit, userId);
  }

  void updateTask() async {
    // TODo: implement
  }

  void updateProgressBin(int habitIndex, int elemIndex, int value) async {
    _todayHabits[habitIndex].progressBin[elemIndex] = value;
    _habits
        .firstWhere(
          (Habit habit) => habit.id == _todayHabits[habitIndex].id,
        )
        .progressBin[elemIndex] = value;
    notifyListeners();
  }

  void addToProgressBin(int index, int value) {
    _todayHabits[index].progressBin.add(value);
    _habits
        .firstWhere(
          (Habit habit) => habit.id == _todayHabits[index].id,
        )
        .progressBin
        .add(value);
    notifyListeners();
  }
}
