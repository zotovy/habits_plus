import 'package:habits_plus/core/models/user.dart';
import 'package:habits_plus/core/services/database.dart';
import 'package:habits_plus/core/viewmodels/base_model.dart';

import '../../locator.dart';

class StartViewModel extends BaseViewModel {
  DatabaseServices _databaseServices = locator<DatabaseServices>();

  User _user;

  Future getUser() async {
    _user = await _databaseServices.getUser();
    _user.profileImg = await _databaseServices.getProfileImg();
  }

  Future setUser(User user) {
    _databaseServices.setUser(user);
  }
}
