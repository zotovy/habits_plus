import 'package:flutter/material.dart';

class LocaleModel extends ChangeNotifier {
  Locale _locale;

  Locale get locale => _locale;

  set locale(Locale newLocale) {
    _locale = newLocale;
    notifyListeners();
  }
}
