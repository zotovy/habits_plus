import 'package:habits_plus/core/models/habit.dart';
import 'package:habits_plus/core/services/database.dart';
import 'package:habits_plus/core/services/firebase.dart';
import 'package:habits_plus/core/util/logger.dart';
import 'package:habits_plus/core/viewmodels/base_model.dart';
import 'package:habits_plus/core/viewmodels/detail_model.dart';
import 'package:habits_plus/core/viewmodels/home_model.dart';
import 'package:habits_plus/core/viewmodels/statistic_model.dart';
import 'package:habits_plus/locator.dart';

class EditViewModel extends BaseViewModel {
  DatabaseServices _databaseServices = locator<DatabaseServices>();
  FirebaseServices _firebaseServices = locator<FirebaseServices>();
  DetailPageView _detailPage = locator<DetailPageView>();
  HomeViewModel _homeViewModel = locator<HomeViewModel>();
  StatisticViewModel _statisticViewModel = locator<StatisticViewModel>();

  /// Save habit to local database & firebase if there is any
  Future<bool> save(Habit habit) async {
    try {
      // save to local storage
      bool code = await _databaseServices.updateHabit(habit);

      if (!code) return false; // error code

      // if (await _firebaseServices.getCurrentUser() != null) {
      //   // update
      //   code = await _firebaseServices.updateHabit(habit);

      //   if (!code) return false; // error code
      // }

      // Set to another pages
      _detailPage.habit = habit;
      _homeViewModel.updateViewHabit(habit, DateTime.now());
      _statisticViewModel.updateViewHabit(habit);

      return true;
    } catch (e) {
      logger.e('Error while save habit (edit view movel) $e');
      return false; // error code
    }
  }
}
