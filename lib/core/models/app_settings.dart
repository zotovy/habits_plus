import 'package:flutter/material.dart';

class AppSettings {
  bool isDarkMode;
  bool isUserLogin;
  bool isNotifications;
  String pinCode;
  bool hasPinCode;
  Locale locale;

  AppSettings({
    this.isDarkMode,
    this.isUserLogin,
    this.isNotifications,
    this.pinCode,
    this.hasPinCode,
    this.locale,
  });
}
