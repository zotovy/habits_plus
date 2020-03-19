import 'package:habits_plus/core/enums/viewstate.dart';
import 'package:habits_plus/core/models/habit.dart';
import 'package:habits_plus/core/models/task.dart';
import 'package:habits_plus/core/models/userData.dart';
import 'package:habits_plus/core/services/database.dart';
import 'package:habits_plus/core/viewmodels/base_model.dart';
import 'package:provider/provider.dart';

import '../../locator.dart';

class CreateViewModel extends BaseViewModel {
  DatabaseServices _databaseServices = locator<DatabaseServices>();

  Future<bool> createTask(Task task, String userId) async {
    setState(ViewState.Busy);
    bool dbcode = await DatabaseServices.createTask(task, userId);
    setState(ViewState.Idle);
    return dbcode;
  }

  Future<bool> createHabit(Habit habit, String userId, String timeOfDay) async {
    setState(ViewState.Busy);
    bool dbcode = await DatabaseServices.createHabit(habit, userId, timeOfDay);
    setState(ViewState.Idle);
    return dbcode;
  }
}
