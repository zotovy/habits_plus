import 'dart:io';

import 'package:flutter/material.dart';
import 'package:habits_plus/core/enums/viewstate.dart';
import 'package:habits_plus/core/models/user.dart';
import 'package:habits_plus/core/services/database.dart';
import 'package:habits_plus/core/services/images.dart';
import 'package:habits_plus/core/viewmodels/base_model.dart';
import 'package:habits_plus/core/viewmodels/drawer_model.dart';
import 'package:habits_plus/locator.dart';

class SettingsViewModel extends BaseViewModel {
  DatabaseServices _databaseServices = locator<DatabaseServices>();
  ImageServices _imageServices = locator<ImageServices>();

  User _user;
  bool _isDarkMode;

  User get user => _user == null ? User() : _user;
  bool get isDarkMode => _isDarkMode;

  Future fetch(BuildContext context) async {
    setState(ViewState.Busy);
    _user = await _databaseServices.getUser();
    _isDarkMode = Theme.of(context).brightness == Brightness.dark;
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

  set user(User __user) {
    _user = __user;
    notifyListeners();
  }
}
