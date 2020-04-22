import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:habits_plus/core/services/database.dart';
import 'package:habits_plus/locator.dart';

class ThemeModel extends ChangeNotifier {
  bool isDarkMode = false;
  DatabaseServices _databaseServices = locator<DatabaseServices>();

  void setMode(bool val) {
    isDarkMode = val;
    notifyListeners();
  }

  void reverseMode() {
    isDarkMode = !isDarkMode;
    notifyListeners();
    _databaseServices.setDarkMode(isDarkMode);
  }
}
