import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ThemeModel extends ChangeNotifier {
  ThemeData theme;

  ThemeModel(this.theme);

  getTheme() => theme;

  setTheme(ThemeData newTheme) {
    theme = newTheme;

    notifyListeners();
  }
}
