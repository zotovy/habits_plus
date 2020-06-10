import 'package:flutter/material.dart';
import 'package:habits_plus/core/enums/authstatus.dart';
import 'package:habits_plus/core/enums/viewstate.dart';
import 'package:habits_plus/core/models/user.dart';
import 'package:habits_plus/core/services/database.dart';
import 'package:habits_plus/core/services/firebase.dart';
import 'package:habits_plus/core/viewmodels/base_model.dart';
import 'package:habits_plus/core/viewmodels/drawer_model.dart';
import 'package:habits_plus/core/viewmodels/home_model.dart';
import 'package:habits_plus/core/viewmodels/settings_model.dart';
import 'package:habits_plus/core/viewmodels/statistic_model.dart';
import 'package:habits_plus/core/viewmodels/sync_model.dart';
import 'package:habits_plus/main.dart';
import 'package:habits_plus/ui/widgets/error_snackbar.dart';

import '../../locator.dart';

class StartViewModel extends BaseViewModel {
  DatabaseServices _databaseServices = locator<DatabaseServices>();
  DrawerViewModel _drawerViewModel = locator<DrawerViewModel>();
  SettingsViewModel _settingsViewModel = locator<SettingsViewModel>();
  StatisticViewModel _statisticViewModel = locator<StatisticViewModel>();
  FirebaseServices _firebaseServices = locator<FirebaseServices>();
  HomeViewModel _homeViewModel = locator<HomeViewModel>();

  // User _user;

  // Future getUser() async {
  //   _user = await _databaseServices.getUser();
  // }

  String translateError(AuthError error) {
    String message = '';
    if (error == AuthError.UserNotFound) {
      message = 'error_user_doent_exists';
    } else if (error == AuthError.NetworkError) {
      message = 'error_network';
    } else if (error == AuthError.PasswordNotValid) {
      message = 'error_incorrect_password';
    } else if (error == AuthError.SaveError) {
      message = 'save_error';
    } else {
      message = 'invalidError';
    }

    return message;
  }

  Future setUser(User user) async {
    setState(ViewState.Busy);
    await _homeViewModel.fetch().then(
          (_) => _statisticViewModel.setupHabits(),
        );
    setupMainFlare();
    await _databaseServices.setUser(user);
    await _drawerViewModel.fetchUser();
    await _settingsViewModel.fetch();
    setState(ViewState.Idle);
  }

  Future<User> getUserByEmail(String email) async {
    return await _firebaseServices.getUserByEmail(email);
  }

  Future<User> login(
    GlobalKey<ScaffoldState> scaffoldKey,
    BuildContext context,
    String email,
    String password,
  ) async {
    LoginResponce responce = await locator<SyncViewModel>().loginWithEmail(
      context,
      email,
      password,
      needDialog: false,
    );

    if (responce.success) {
      return responce.user;
    } else {
      // translate error
      String message = translateError(responce.error);

      // Show error
      scaffoldKey.currentState.showSnackBar(
        errorSnackBar(context, message),
      );
    }
  }
}
