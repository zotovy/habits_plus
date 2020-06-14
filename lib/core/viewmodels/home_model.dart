import 'package:habits_plus/core/enums/viewstate.dart';
import 'package:habits_plus/core/models/habit.dart';
import 'package:habits_plus/core/models/task.dart';
import 'package:habits_plus/core/services/database.dart';
import 'package:habits_plus/core/services/firebase.dart';
import 'package:habits_plus/core/services/internet.dart';
import 'package:habits_plus/core/util/constant.dart';
import 'package:habits_plus/core/viewmodels/base_model.dart';
import 'package:habits_plus/core/viewmodels/settings_model.dart';
import 'package:habits_plus/core/viewmodels/statistic_model.dart';
import 'package:habits_plus/locator.dart';

class HomeViewModel extends BaseViewModel {
  DatabaseServices _databaseServices = locator<DatabaseServices>();
  InternetServices _internetServices = locator<InternetServices>();
  FirebaseServices _firebaseServices = locator<FirebaseServices>();

  List<Habit> _habits = [];
  List<Task> _tasks = [];

  List<Habit> _todayHabits = [];
  List<Task> _todayTasks = [];
  List<Task> _doneTodayTasks = [];
  List<Task> _notDoneTodayTasks = [];
  bool _hasDoneTasks = false;
  bool _hasNotDoneTasks = false;

  bool needTransition = true;

  List<DateTime> _markedDates = [];
  Map<int, List<DateTime>> _habitsDate = {};
  DateTime today = dateFormater.parse(DateTime.now().toString());
  List<DateTime> visitedDates = [];

  DateTime _currentDate = DateTime.now();
  bool hasData = false;

  List<Habit> get habits => _habits;
  List<Task> get tasks => _tasks;

  List<DateTime> get markedDates => _markedDates;
  List<Habit> get todayHabits => _todayHabits;
  List<Task> get todayTasks => _todayTasks;
  List<Task> get doneTodayTasks => _doneTodayTasks;
  List<Task> get notDoneTodayTasks => _notDoneTodayTasks;
  bool get hasDoneTasks => _hasDoneTasks;
  bool get hasNotDoneTasks => _hasNotDoneTasks;
  DateTime get currentDate => _currentDate;

  set habits(List<Habit> newHabits) {
    _habits = newHabits;
    notifyListeners();
  }

  set tasks(List<Task> newTasks) {
    _tasks = newTasks;
    notifyListeners();
  }

  set hasDoneTasks(bool value) {
    _hasDoneTasks = value;
    notifyListeners();
  }

  set hasNotDoneTasks(bool value) {
    _hasNotDoneTasks = value;
    notifyListeners();
  }

  void setHabitsNotification(int i, bool val) {
    habits[i].hasReminder = val;
    notifyListeners();
  }

  void setNeedReload(bool value) {
    needTransition = value;
  }

  void updateViewHabit(Habit habit, DateTime date) {
    setState(ViewState.Busy);
    int id = _habits.indexWhere((Habit elem) => elem.id == habit.id);
    _habits[id] = habit;
    setMarkedDates();
    setToday(date);
    setState(ViewState.Idle);
  }

  Future fetch() async {
    setState(ViewState.Busy);

    bool hasInternet = await _internetServices.hasInternetConnection();
    bool isSync = locator<SettingsViewModel>().isSync;

    if (hasInternet && isSync) {
      // TODO: set updates to firebase

      _habits = await _firebaseServices.getHabits();
      _tasks = await _firebaseServices.getTasks();

      locator<StatisticViewModel>().setupHabits();

      _databaseServices.setHabits(habits);
      _databaseServices.setTasks(tasks);
    } else {
      _habits = await _databaseServices.getHabits();
      _tasks = await _databaseServices.getTasks();
    }
    setMarkedDates();
    setToday(DateTime.now());
    setState(ViewState.Idle);
  }

  void addToCountableProgress(
    DateTime date,
    List _data,
    int index,
    String userId,
  ) {
    todayHabits[index].countableProgress[
        dateFormater.parse(currentDate.toString()).toString()] = _data;
    _databaseServices.updateHabit(todayHabits[index]);
  }

  void addHabitWithOutReload(Habit habit) {
    _habits.add(habit);
    setMarkedDates();
    setToday(DateTime.now());
  }

  void addTaskWithOutReload(Task task) {
    _tasks.add(task);
    setMarkedDates();
    setToday(DateTime.now());
  }

  void setMarkedDates() {
    // Get the nearest monday
    // DateTime today = DateTime.now();
    // DateTime _firstDayOfTheWeek = DateTime.now();
    // if (today.weekday != 1) {
    //   _firstDayOfTheWeek = today.subtract(
    //     Duration(days: today.weekday - 1),
    //   );
    // }

    _habitsDate = {};
    _markedDates = [];

    // Habits

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

          _markedDates.add(currentDate);

          _habitsDate[i] == null
              ? _habitsDate[i] = [dateFormater.parse(currentDate.toString())]
              : _habitsDate[i].add(dateFormater.parse(currentDate.toString()));
        }
      }
    }

    // Tasks
    for (var i = 0; i < _tasks.length; i++) {
      if (_tasks[i].date != null) {
        _markedDates.add(tasks[i].date);
      }
    }

    _markedDates = _markedDates.toSet().toList();
  }

  void setTodayWithReload(DateTime date) {
    setState(ViewState.Busy);
    today = dateFormater.parse(date.toString());
    visitedDates.add(today);
    setMarkedDates();
    setToday(date);
    needTransition = true;
    setState(ViewState.Idle);
  }

  void setToday(DateTime date) {
    // Format date
    date = dateFormater.parse(date.toString());

    // Update currentDate variable
    _currentDate = date;
    // Habits
    _todayHabits = [];
    for (var i = 0; i < _habits.length; i++) {
      // Check is disable
      if (_habits[i].isDisable) {
        continue;
      }

      for (var j = 0; j < _habitsDate[i].length; j++) {
        if (_habitsDate[i][j] == dateFormater.parse(date.toString())) {
          _todayHabits.add(_habits[i]);
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
        print(tasks[i].toJson());
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
    setMarkedDates();
    setToday(DateTime.now());
    notifyListeners();
  }

  void addTask(Task task) {
    _tasks.add(task);
    setMarkedDates();
    setToday(DateTime.now());
    notifyListeners();
  }

  void removeHabit(int i) {
    _habits.removeAt(i);
    notifyListeners();
  }

  void removeTask(Task task, String userId) {
    // Remove from local providers
    _tasks.removeAt(_tasks.indexOf(task));
    if (task.done) {
      _doneTodayTasks.removeAt(_doneTodayTasks.indexOf(task));
    } else {
      _notDoneTodayTasks.removeAt(_notDoneTodayTasks.indexOf(task));
    }

    // Remove from database
    notifyListeners();
  }

  void updateHabit(Habit habit, String userId) async {
    if (await _internetServices.hasInternetConnection()) {}
    await _databaseServices.updateHabit(habit);
  }

  void updateTask(Task task, userId) async {
    await _databaseServices.updateTask(task);
  }

  void addToProgressBin(int index, DateTime date) {
    _todayHabits[index].progressBin.add(date);
    _firebaseServices.updateHabit(_todayHabits[index]);
    notifyListeners();
  }

  void removeFromProgressBin(int index, DateTime date) {
    date = dateFormater.parse(date.toString());
    _todayHabits[index].progressBin.removeAt(
          _todayHabits[index].progressBin.indexOf(date),
        );
    _firebaseServices.updateHabit(_todayHabits[index]);
    notifyListeners();
  }

  void removeFromDoneTasks(int index) {
    _doneTodayTasks.removeAt(index);

    notifyListeners();
  }

  void removeFromNotDoneTasks(int index) {
    _notDoneTodayTasks.removeAt(index);
    notifyListeners();
  }

  void addDoneTask(Task task) {
    // _tasks.add(task);
    _doneTodayTasks.add(task);
    notifyListeners();
  }

  void addNotDoneTasks(Task task) {
    // _tasks.add(task);
    _notDoneTodayTasks.add(task);
    notifyListeners();
  }

  void updateDoneProperty(Task task, bool value) {
    if (task.done) {
      _doneTodayTasks[_doneTodayTasks.indexOf(task)].done = value;
    } else {
      _notDoneTodayTasks[_notDoneTodayTasks.indexOf(task)].done = value;
    }

    int index = _tasks.indexOf(task);

    _tasks[index].done = value;
    _firebaseServices.updateTask(_tasks[index]);

    notifyListeners();
  }

  Future<bool> removeTaskFromDB(Task task, String userId) async {
    await _databaseServices.deleteTask(task.id);
  }
}
