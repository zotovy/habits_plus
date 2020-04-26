import 'dart:io';

import 'package:flutter/cupertino.dart';
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
import 'package:habits_plus/localization.dart';
import 'package:habits_plus/locator.dart';
import 'package:habits_plus/ui/view/lock.dart';
import 'package:habits_plus/ui/view/lock/create_1.dart';
import 'package:habits_plus/ui/widgets/error_snackbar.dart';

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
  bool _isLockScreen;
  String _code;

  List<HabitNotification> _notifications = [];

  // ANCHOR get
  User get user => _user == null ? User() : _user;
  bool get isDarkMode => _isDarkMode;
  List<HabitNotification> get notifications => _notifications;
  bool get isSoundNotifications => _isSoundNotifications;
  bool get isLockScreen => _isLockScreen;

  SettingsViewModel() {
    _constructor();
  }

  // ANCHOR constructor
  _constructor() async {
    /// Setup [_notifications]
    _notifications = await _databaseServices.getAllNotifications();

    /// Setup [_soundNotification]
    _isSoundNotifications = _databaseServices.isSoundNotification();

    /// Setup [_isLockScreen] & [_code]
    _code = _databaseServices.getPinCode();
    _isLockScreen = _databaseServices.getPinCodeStatus();
  }

  // ANCHOR set

  Future<bool> triggerIsLockScreen(
    BuildContext context,
    GlobalKey<ScaffoldState> _scaffoldKey,
  ) async {
    // if from on -> off
    if (_isLockScreen) {
      await Navigator.push(
        context,
        CupertinoPageRoute(
          builder: (_) => LockScreen(
            _code,
            text: true,
            callback: (verificationStatus) async {
              if (verificationStatus) {
                // Push to DB
                bool dbcode =
                    await _databaseServices.setPinCodeStatus(!_isLockScreen);

                if (!dbcode) {
                  _scaffoldKey.currentState.showSnackBar(
                    errorSnackBar(context, 'save_error'),
                  );

                  return null; // Error code
                }

                _isLockScreen = false;
              } else {
                _isLockScreen = true;
              }
              Future.delayed(Duration(milliseconds: 500)).then((_) {
                Navigator.pop(context);
              });
              notifyListeners();
            },
          ),
        ),
      );
    } else if (_isLockScreen == false && _code == null) {
      await Navigator.push(
        context,
        CupertinoPageRoute(
          builder: (_) => CreateLock1Screen(),
        ),
      );
    } else {
      _isLockScreen = true;
      notifyListeners();
    }

    return _isLockScreen;
  }

  Future editLockCode(BuildContext context) async {
    if (_code != null && _code != '') {
      Navigator.push(
        context,
        CupertinoPageRoute(
          builder: (_) => LockScreen(
            _code,
            text: true,
            callback: (bool value) {
              if (value) {
                Future.delayed(Duration(milliseconds: 500)).then((_) {
                  Navigator.push(
                    context,
                    CupertinoPageRoute(
                      builder: (_) => CreateLock1Screen(),
                    ),
                  );
                });
              } else {
                Future.delayed(Duration(milliseconds: 500)).then((_) {
                  Navigator.pop(context);
                });
              }
            },
          ),
        ),
      );
    }
  }

  Future<bool> deleteCode(
    BuildContext context,
    GlobalKey<ScaffoldState> _scaffoldKey,
  ) async {
    if (_code != null && _code != '') {
      showCupertinoDialog(
        context: context,
        builder: (_) => CupertinoAlertDialog(
          title: Text(
            AppLocalizations.of(context).translate('delete_lock_title'),
          ),
          content: new Text("This is my content"),
          actions: <Widget>[
            CupertinoDialogAction(
              onPressed: () {
                Navigator.push(
                  context,
                  CupertinoPageRoute(
                    builder: (_) => LockScreen(
                      _code,
                      callback: (bool value) async {
                        if (value) {
                          bool dbcode_1 =
                              await _databaseServices.setPinCode('');
                          bool dbcode_2 =
                              await _databaseServices.setPinCodeStatus(
                            false,
                          );

                          if (!dbcode_1 || !dbcode_2) {
                            _scaffoldKey.currentState.showSnackBar(
                              errorSnackBar(context, 'save_error'),
                            );
                            return null;
                          }

                          _code = null;
                          _isLockScreen = false;
                          notifyListeners();
                          Navigator.pop(context);
                        } else {
                          Navigator.pop(context);
                          _scaffoldKey.currentState.showSnackBar(
                            errorSnackBar(context, 'save_error'),
                          );
                        }
                      },
                    ),
                  ),
                );
              },
              child: Text(
                AppLocalizations.of(context).translate('yes'),
              ),
            ),
            CupertinoDialogAction(
              onPressed: () => Navigator.pop(context),
              isDefaultAction: true,
              child: Text(
                AppLocalizations.of(context).translate('no'),
              ),
            )
          ],
        ),
      );
    }
  }

  Future setPinCode(String code) async {
    bool dbcode_code = await _databaseServices.setPinCode(code);
    bool dbcode_status = await _databaseServices.setPinCodeStatus(true);

    if (!dbcode_code || !dbcode_status) return null; // Error code

    _code = code;
    _isLockScreen = true;
    notifyListeners();
  }

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
    return true;
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
