import 'package:flutter/widgets.dart';
import 'package:habits_plus/models/task.dart';

class TaskData extends ChangeNotifier {
  List<Task> _allTasks = [];
  List<Task> _todayTasks = [];
  List<Task> _notDoneTodayTasks = [];
  List<Task> _doneTodayTasks = [];
  bool _hasDoneTasks = false;
  bool _hasNotDoneTasks = false;

  List<Task> get allTasks => _allTasks;
  List<Task> get todayTasks => _todayTasks;
  List<Task> get notDoneTodayTasks => _notDoneTodayTasks;
  List<Task> get doneTodayTasks => _doneTodayTasks;
  bool get hasDoneTasks => _hasDoneTasks;
  bool get hasNotDoneTasks => _hasNotDoneTasks;

  set allTasks(List<Task> tasks) {
    _allTasks = tasks;
    notifyListeners();
  }

  set todayTasks(List<Task> tasks) {
    _todayTasks = tasks;
    notifyListeners();
  }

  set notDoneTodayTasks(List<Task> tasks) {
    _notDoneTodayTasks = tasks;
    _hasNotDoneTasks = tasks.length > 0 ? true : false;
    notifyListeners();
  }

  set doneTodayTasks(List<Task> tasks) {
    _doneTodayTasks = tasks;
    _hasDoneTasks = tasks.length > 0 ? true : false;
    notifyListeners();
  }

  void addToAllTasks(Task task) {
    _allTasks.add(task);
    notifyListeners();
  }

  void removeFromAllTasks(int index) {
    _allTasks.removeAt(index);
    notifyListeners();
  }

  void addToTodayTasks(Task task) {
    _todayTasks.add(task);
    notifyListeners();
  }

  void removeFromTodayTasks(int index) {
    _todayTasks.removeAt(index);
    notifyListeners();
  }

  void addToNotDoneTodayTasks(Task task) {
    _notDoneTodayTasks.add(task);
    notifyListeners();
  }

  void removeFromNotDoneTodayTasks(int index) {
    _notDoneTodayTasks.removeAt(index);
    notifyListeners();
  }

  void addToDoneTodayTasks(Task task) {
    _doneTodayTasks.add(task);
    notifyListeners();
  }

  void removeFromDoneTodayTasks(int index) {
    _doneTodayTasks.removeAt(index);
    notifyListeners();
  }
}
