import 'package:habits_plus/core/enums/viewstate.dart';
import 'package:habits_plus/core/models/user.dart';
import 'package:habits_plus/core/services/database.dart';
import 'package:habits_plus/core/viewmodels/base_model.dart';
import 'package:habits_plus/core/viewmodels/drawer_model.dart';
import 'package:habits_plus/core/viewmodels/home_model.dart';
import 'package:habits_plus/core/viewmodels/settings_model.dart';
import 'package:habits_plus/core/viewmodels/statistic_model.dart';
import 'package:habits_plus/main.dart';

import '../../locator.dart';

class StartViewModel extends BaseViewModel {
  DatabaseServices _databaseServices = locator<DatabaseServices>();
  DrawerViewModel _drawerViewModel = locator<DrawerViewModel>();
  SettingsViewModel _settingsViewModel = locator<SettingsViewModel>();
  StatisticViewModel _statisticViewModel = locator<StatisticViewModel>();
  HomeViewModel _homeViewModel = locator<HomeViewModel>();

  // User _user;

  // Future getUser() async {
  //   _user = await _databaseServices.getUser();
  // }

  Future setUser(User user) async {
    setState(ViewState.Busy);
    await _homeViewModel.fetch().then(
          (_) => _statisticViewModel.setupHabits(),
        );
    await setupMainFlare();
    await _databaseServices.setUser(user);
    await _drawerViewModel.fetchUser();
    await _settingsViewModel.fetch();
    setState(ViewState.Idle);
  }
}
