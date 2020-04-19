import 'package:habits_plus/core/enums/viewstate.dart';
import 'package:habits_plus/core/models/habit.dart';
import 'package:habits_plus/core/models/task.dart';
import 'package:habits_plus/core/services/database.dart';
import 'package:habits_plus/core/viewmodels/base_model.dart';
import 'package:habits_plus/core/viewmodels/home_model.dart';

import '../../locator.dart';

class CreateViewModel extends BaseViewModel {
  DatabaseServices _databaseServices = locator<DatabaseServices>();

  Future<bool> createTask(Task task) async {
    setState(ViewState.Busy);
    bool dbcode = await _databaseServices.saveTask(task);
    if (dbcode) {
      // If successed -> add task to home screen
      locator<HomeViewModel>().addTaskWithOutReload(task);
    }
    setState(ViewState.Idle);
    return dbcode;
  }

  Future<bool> createHabit(Habit habit, String userId) async {
    setState(ViewState.Busy);
    bool dbcode = await _databaseServices.saveHabit(habit);
    if (dbcode) {
      // If successed -> add habit to home screen
      locator<HomeViewModel>().addHabit(habit);
    }
    setState(ViewState.Idle);
    return dbcode;
  }
}
