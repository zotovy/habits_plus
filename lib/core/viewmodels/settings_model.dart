import 'dart:io';

import 'package:flutter/material.dart';
import 'package:habits_plus/core/enums/viewstate.dart';
import 'package:habits_plus/core/models/habit.dart';
import 'package:habits_plus/core/models/notification.dart';
import 'package:habits_plus/core/models/user.dart';
import 'package:habits_plus/core/services/database.dart';
import 'package:habits_plus/core/services/images.dart';
import 'package:habits_plus/core/services/notifications.dart';
import 'package:habits_plus/core/viewmodels/base_model.dart';
import 'package:habits_plus/core/viewmodels/drawer_model.dart';
import 'package:habits_plus/core/viewmodels/home_model.dart';
import 'package:habits_plus/core/viewmodels/statistic_model.dart';
import 'package:habits_plus/locator.dart';

class SettingsViewModel extends BaseViewModel {
  DatabaseServices _databaseServices = locator<DatabaseServices>();
  ImageServices _imageServices = locator<ImageServices>();
  HomeViewModel _homeViewModel = locator<HomeViewModel>();
  StatisticViewModel _statisticViewModel = locator<StatisticViewModel>();
  NotificationServices _notificationServices = locator<NotificationServices>();

  User _user;
  bool _isDarkMode;
  bool isNotifications;
  bool isSync = false;
  bool _isSoundNotifications;

  List<HabitNotification> _notifications = [];

  // ANCHOR get
  User get user => _user == null ? User() : _user;
  bool get isDarkMode => _isDarkMode;
  List<HabitNotification> get notifications => _notifications;
  bool get isSoundNotifications => _isSoundNotifications;

  SettingsViewModel() {
    _constructor();
  }

  // ANCHOR constructor
  _constructor() async {
    /// Setup [_notifications]
    _notifications = await _databaseServices.getAllNotifications();

    /// Setup [_soundNotification]
    _isSoundNotifications = await _databaseServices.isSoundNotification();
  }

  // ANCHOR set

  Future<bool> setIsSoundNotifications(BuildContext context, bool value) async {
    _isSoundNotifications = value;

    // Save new value in db
    bool dbcode = await _databaseServices.setIsSoundNotification(value);
    if (!dbcode) return false; // Error code

    // Manage notifications
    for (var notification in _notifications) {
      _notificationServices.deleteNotif(notification);
      if (value) {
        //? IF sound was disabled -> create new push_notifications with sound
        _notificationServices.createNotifications(
          context,
          notification.habit,
          sound: true,
        );
      } else {
        //? ELSE sound was turned on -> delete all push_notifications without sound
        _notificationServices.createNotifications(
          context,
          notification.habit,
          sound: false,
        );
      }
    }

    return true;
  }

  Future<bool> setIsNotifications(BuildContext context, bool val) async {
    isNotifications = val;

    // Save to DB
    bool dbcode = await _databaseServices.setIsNotification(val);
    if (dbcode) return null; // Error code

    // Manage notifications
    for (var notification in _notifications) {
      if (val) {
        //? IF notifications were disabled -> create new push_notifications
        _notificationServices.createNotifications(
          context,
          notification.habit,
        );
      } else {
        //? ELSE notifications were turned on -> delete all push_notifications
        _notificationServices.deleteNotif(notification);
      }
    }

    notifyListeners();
  }

  void setupNotifications() async {
    _notifications = await _databaseServices.getAllNotifications();
    notifyListeners();
  }

  void setHabitsNotifications(BuildContext context, int i, bool val) {
    _notifications[i].habit.hasReminder = val;

    // Manage notifications
    if (val) {
      _notificationServices.deleteNotif(_notifications[i]);
    } else {
      _notificationServices.createNotifications(
        context,
        _notifications[i].habit,
      );
    }

    // Save notification obj
    _databaseServices.updateNotification(_notifications[i]);

    _homeViewModel.setHabitsNotification(i, val);
    _statisticViewModel.setHabitsNotification(i, val);
    notifyListeners();
  }

  Future fetch() async {
    setState(ViewState.Busy);
    _user = await _databaseServices.getUser();
    setState(ViewState.Idle);
  }

  Future<bool> setProfileImage(File image) async {
    String encodedImage = _imageServices.base64String(image.readAsBytesSync());

    _user.profileImgBase64String = encodedImage;

    bool success = await _databaseServices.setUser(_user);

    notifyListeners();
    locator<DrawerViewModel>().user = _user;

    return success;
  }

  Future<bool> updateDBUser() async {
    try {
      setState(ViewState.Busy);

      bool dbcode = await _databaseServices.setUser(_user);
      setState(ViewState.Idle);

      return dbcode;
    } catch (e) {
      print('Error while update DB user (settings_viewmodel): $e');
      setState(ViewState.Idle);

      return false;
    }
  }

  set user(User __user) {
    _user = __user;
    locator<DrawerViewModel>().user = _user;
    notifyListeners();
  }
}
