import 'package:flutter/material.dart';
import 'package:habits_plus/core/enums/viewstate.dart';
import 'package:habits_plus/core/services/auth.dart';
import 'package:habits_plus/core/viewmodels/base_model.dart';

import '../../locator.dart';

class LoginViewModel extends BaseViewModel {
  AuthService _authService = locator<AuthService>();

  Future login(
    String email,
    String password,
    GlobalKey<ScaffoldState> scaffoldKey,
    BuildContext context,
  ) async {
    setState(ViewState.Busy);
    await _authService.login(email, password, scaffoldKey, context);
    setState(ViewState.Idle);
  }

  Future googleLogin(BuildContext context) async {
    setState(ViewState.Busy);
    await _authService.signInByGoogle(context);
    setState(ViewState.Idle);
  }

  Future facebookLogin(BuildContext context) async {
    setState(ViewState.Busy);
    await _authService.signInByFacebook(context);
    setState(ViewState.Idle);
  }
}
