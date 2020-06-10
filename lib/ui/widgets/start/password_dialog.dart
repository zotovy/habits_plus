//========================================================================================
/*                                                                                      *
 *                   Show on start page when user enter existing email                  *
 *                                                                                      */
//========================================================================================

import 'package:flutter/material.dart';
import 'package:habits_plus/localization.dart';
import 'package:habits_plus/ui/widgets/confirm_button.dart';
import 'package:habits_plus/ui/widgets/rounded_textfield.dart';

/// Show on start page when user enter existing email
class EnterPasswordDialog extends StatelessWidget {
  String password = '';

  Function(String) submit;
  Function onClose;
  GlobalKey<ScaffoldState> scaffoldKey;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  EnterPasswordDialog({
    this.submit,
    this.onClose,
    this.scaffoldKey,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onClose,
      child: Scaffold(
        key: scaffoldKey,
        body: Form(
          key: formKey,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                GestureDetector(
                  child: Container(
                    margin: EdgeInsets.all(32),
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Theme.of(context).backgroundColor,
                    ),
                    child: Column(
                      children: <Widget>[
                        Text(
                          AppLocalizations.of(context)
                              .translate("login_existing_email"),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 18,
                            color: Theme.of(context).textSelectionHandleColor,
                          ),
                        ),
                        SizedBox(height: 10),
                        RoundedTextField(
                          needMargin: false,
                          hint: "password",
                          errorLocalizationPath: "login_password_error",
                          validator: (val) {
                            return val.trim().length >= 6
                                ? null
                                : AppLocalizations.of(context)
                                    .translate('login_password_error');
                          },
                          onSaved: (val) => password = val,
                          labelLocalizationPath: "password",
                          prefix: Icons.lock,
                          hasObscure: true,
                        ),
                        SizedBox(height: 10),
                        ConfirmButton(
                          margin: 0,
                          submit: () {
                            if (formKey.currentState.validate()) {
                              formKey.currentState.save();
                              submit(password);
                            }
                          },
                          text: "confirm",
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
