import 'package:habits_plus/core/models/user.dart';
import 'package:habits_plus/core/viewmodels/base_model.dart';

class SettignsViewModel extends BaseViewModel {
  User _user;

  User get user => _user == null ? User() : _user;

  set user(User __user) {
    _user = __user;
    notifyListeners();
  }
}
