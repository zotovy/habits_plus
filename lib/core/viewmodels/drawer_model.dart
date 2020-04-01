import 'package:habits_plus/core/models/user.dart';
import 'package:habits_plus/core/services/database.dart';
import 'package:habits_plus/core/viewmodels/base_model.dart';

import '../../locator.dart';

class DrawerViewModel extends BaseViewModel {
  DatabaseServices _databaseServices = locator<DatabaseServices>();
  User _user;

  User get user => _user;

  Future fetchUser(String userId) async {
    _user = await _databaseServices.getUserById(userId);
  }
}
