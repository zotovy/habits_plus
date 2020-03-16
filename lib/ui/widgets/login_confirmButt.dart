import 'package:flutter/material.dart';

import '../../localization.dart';

class LoginConfirmButton extends StatelessWidget {
  Function submit;

  LoginConfirmButton({this.submit});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 28),
      height: 55,
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Material(
          child: InkWell(
            borderRadius: BorderRadius.circular(10),
            splashColor: Colors.white10,
            onTap: submit,
            child: Center(
              child: Text(
                AppLocalizations.of(context).translate('login_title'),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
            ),
          ),
          color: Colors.transparent,
        ),
      ),
    );
  }
}
