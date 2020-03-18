import 'package:flutter/material.dart';
import 'package:habits_plus/core/enums/viewstate.dart';
import 'package:habits_plus/core/services/auth.dart';
import 'package:habits_plus/core/viewmodels/base_model.dart';

import '../../locator.dart';

class SignUpViewModel extends BaseViewModel {
  AuthService _authService = locator<AuthService>();

  Future signUp(
    BuildContext context,
    String email,
    String name,
    String profileImg,
    String password,
    GlobalKey<ScaffoldState> scaffoldKey,
    bool isGoogleSign,
  ) async {
    setState(ViewState.Busy);
    await _authService.signUpUser(
      context,
      email,
      name,
      profileImg,
      password,
      scaffoldKey,
    );
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
