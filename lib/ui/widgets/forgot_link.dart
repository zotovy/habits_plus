import 'package:flutter/material.dart';

import '../../localization.dart';

class ForgotPageLink extends StatelessWidget {
  bool isLoginPage;

  ForgotPageLink({this.isLoginPage});

  @override
  Widget build(BuildContext context) {
    if (isLoginPage) {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 28),
        height: 25,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            GestureDetector(
              onTap: () => print('go to forgot password page'),
              child: Text(
                AppLocalizations.of(context).translate('forgot_password'),
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontSize: 16,
                ),
              ),
            ),
            GestureDetector(
              onTap: () => Navigator.pushReplacementNamed(
                context,
                'signup',
              ),
              child: Text(
                AppLocalizations.of(context).translate('login_link'),
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xFF282828),
                ),
              ),
            ),
          ],
        ),
      );
    } else {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 28),
        height: 25,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            GestureDetector(
              onTap: () => print('go to forgot password page'),
              child: Text(
                AppLocalizations.of(context).translate('forgot_password'),
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontSize: 16,
                ),
              ),
            ),
            GestureDetector(
              onTap: () => Navigator.pushReplacementNamed(
                context,
                'login',
              ),
              child: Text(
                AppLocalizations.of(context).translate('signup_link'),
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xFF282828),
                ),
              ),
            ),
          ],
        ),
      );
    }
  }
}
