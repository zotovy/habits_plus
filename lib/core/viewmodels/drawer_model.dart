import 'package:habits_plus/core/enums/viewstate.dart';
import 'package:habits_plus/core/models/user.dart';
import 'package:habits_plus/core/services/database.dart';
import 'package:habits_plus/core/util/constant.dart';
import 'package:habits_plus/core/viewmodels/base_model.dart';

import '../../locator.dart';

class DrawerViewModel extends BaseViewModel {
  DatabaseServices _databaseServices = locator<DatabaseServices>();
  User _user;

  User get user => _user;

  set user(User user) {
    _user = user;
    notifyListeners();
  }

  Future fetchUser() async {
    setState(ViewState.Busy);
    _user = await _databaseServices.getUser();

    if (_user == null) {
      _user = userNotFound;
    }
    setState(ViewState.Idle);

    return _user;
  }
}
