import 'package:habits_plus/core/enums/viewstate.dart';
import 'package:habits_plus/core/models/habit.dart';
import 'package:habits_plus/core/models/task.dart';
import 'package:habits_plus/core/services/database.dart';
import 'package:habits_plus/core/services/firebase.dart';
import 'package:habits_plus/core/viewmodels/base_model.dart';
import 'package:habits_plus/core/viewmodels/home_model.dart';
import 'package:uuid/uuid.dart';

import '../../locator.dart';

class CreateViewModel extends BaseViewModel {
  DatabaseServices _databaseServices = locator<DatabaseServices>();
  FirebaseServices _firebaseServices = locator<FirebaseServices>();

  Future<bool> createTask(Task task) async {
    setState(ViewState.Busy);

    task.id = Uuid().v4();

    bool dbcode = true;

    if (await _firebaseServices.userId != null) {
      dbcode = await _firebaseServices.createTask(task);
    }

    if (!dbcode) {
      setState(ViewState.Idle);
      return null;
    }

    dbcode = await _databaseServices.saveTask(task);

    if (dbcode) {
      // If successed -> add task to home screen
      locator<HomeViewModel>().addTaskWithOutReload(task);
    }
    setState(ViewState.Idle);
    return dbcode;
  }

  Future<bool> createHabit(Habit habit) async {
    setState(ViewState.Busy);

    habit.id = Uuid().v4();

    bool dbcode = true;

    if (await _firebaseServices.userId != null) {
      dbcode = await _firebaseServices.createHabit(habit);
    }

    if (!dbcode) {
      setState(ViewState.Idle);
      return null;
    }

    dbcode = await _databaseServices.saveHabit(habit);
    if (dbcode) {
      // If successed -> add habit to home screen
      locator<HomeViewModel>().addHabit(habit);
    }
    setState(ViewState.Idle);
    return dbcode;
  }
}
