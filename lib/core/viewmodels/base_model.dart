import 'package:flutter/widgets.dart';
import 'package:habits_plus/core/enums/viewstate.dart';

class BaseViewModel extends ChangeNotifier {
  ViewState state = ViewState.Idle;

  void setState(ViewState viewState) {
    state = viewState;
    notifyListeners();
  }
}
