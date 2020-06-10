import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:habits_plus/core/enums/authstatus.dart';
import 'package:habits_plus/core/enums/viewstate.dart';
import 'package:habits_plus/core/util/constant.dart';
import 'package:habits_plus/core/viewmodels/sync_model.dart';
import 'package:habits_plus/localization.dart';
import 'package:habits_plus/ui/widgets/confirm_button.dart';
import 'package:habits_plus/ui/widgets/error_snackbar.dart';
import 'package:habits_plus/ui/widgets/progress_bar.dart';
import 'package:habits_plus/ui/widgets/rounded_textfield.dart';
import 'package:habits_plus/ui/widgets/sync/password_reset.dart';
import 'package:habits_plus/ui/widgets/sync/sync_dialog.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';

import '../../../locator.dart';

class SyncPage extends StatefulWidget {
  @override
  _SyncPageState createState() => _SyncPageState();
}

class _SyncPageState extends State<SyncPage> {
  SyncViewModel _model = locator<SyncViewModel>();

  // Keys
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Form
  String _email = '';
  String _password = '';

  String translateError(AuthError error) {
    String message = '';
    if (error == AuthError.UserNotFound) {
      message = 'error_user_doent_exists';
    } else if (error == AuthError.NetworkError) {
      message = 'error_network';
    } else if (error == AuthError.PasswordNotValid) {
      message = 'error_incorrect_password';
    } else if (error == AuthError.SaveError) {
      message = 'save_error';
    } else {
      message = 'invalidError';
    }

    return message;
  }

  void _onSubmit(SyncViewModel model) async {
    if (_formKey.currentState.validate()) {
      // save
      _formKey.currentState.save();

      // login
      LoginResponce result = await model.loginWithEmail(
        context,
        _email,
        _password,
      );

      // If not signup -> signup
      if (result.error == AuthError.UserNotFound) {
        // signup
        LoginResponce signUpResponce = await model.signUp(_email, _password);

        // check signup result
        if (signUpResponce.success) {
          // show dialog
          showDialog(
            context: context,
            builder: (_) => SyncDialog(),
          );

          // pop() after 2 seconds
          Future.delayed(Duration(seconds: 2)).then((_) {
            Navigator.pop(context);
          });

          // exit
          return null;
        } else {
          // translate error
          String message = translateError(signUpResponce.error);

          // Show error
          _scaffoldKey.currentState.showSnackBar(
            errorSnackBar(context, message),
          );

          // exit
          return null;
        }
      }

      // check result
      if (result.success) {
        // show dialog
        showDialog(
          context: context,
          builder: (_) => SyncDialog(),
        );

        // pop() after 2 seconds
        Future.delayed(Duration(seconds: 2)).then((_) {
          Navigator.pop(context);
        });
      } else {
        // specify error type & message
        AuthError error = result.error;

        if (error == AuthError.UserExit) {
          return null; // exit
        }

        String message = translateError(error);

        // Show error
        _scaffoldKey.currentState.showSnackBar(
          errorSnackBar(context, message),
        );

        // exit
        return null;
      }
    }
  }

  List<Widget> _ui(BuildContext context, SyncViewModel model) {
    return [
      // Illustration
      Container(
        height: 250,
        child: FlareActor(
          'assets/flare/sync.flr',
          animation: 'transition',
        ),
      ),
      SizedBox(height: 20),

      // Title
      Text(
        AppLocalizations.of(context).translate('sync').toUpperCase(),
        style: TextStyle(
          color: lightMode.textSelectionHandleColor,
          fontSize: 22,
          fontWeight: FontWeight.w600,
        ),
      ),
      SizedBox(height: 5),

      // subtitle
      Container(
        margin: EdgeInsets.symmetric(horizontal: 30),
        child: Text(
          AppLocalizations.of(context).translate('sync_subtitle'),
          textAlign: TextAlign.center,
          style: TextStyle(
            color: lightMode.textSelectionColor,
            fontSize: 16,
          ),
        ),
      ),
      SizedBox(height: 15),

      // Email text form
      RoundedTextField(
        margin: EdgeInsets.symmetric(horizontal: 30),
        hint: 'email',
        hasObscure: false,
        prefix: Icons.email,
        validator: (String value) =>
            RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                    .hasMatch(value)
                ? null
                : AppLocalizations.of(context)
                    .translate(
                      'error_email_bad_formated',
                    )
                    .toString(),
        onSaved: (String value) => _email = value,
      ),
      SizedBox(height: 7),

      // Password text form
      RoundedTextField(
        margin: EdgeInsets.symmetric(horizontal: 30),
        hint: 'password',
        hasObscure: true,
        prefix: Icons.lock,
        validator: (String value) => value.trim() != ''
            ? null
            : AppLocalizations.of(context)
                .translate(
                  'error_noTextFieldData',
                )
                .toString(),
        onSaved: (String value) => _password = value,
      ),
      SizedBox(height: 10),

      // Confirm
      ConfirmButton(
        margin: 30,
        submit: () => _onSubmit(model),
        text: 'confirm',
      ),
      SizedBox(height: 5),

      // forgot password
      GestureDetector(
        onTap: () {
          showDialog(
            context: context,
            builder: (_) => PasswordReset(
              callback: (String _email) async {
                bool code = await model.resetPassword(_email);
              },
            ),
          );
        },
        child: Text(
          AppLocalizations.of(context).translate('forgot_password'),
          style: TextStyle(
            fontSize: 16,
            color: lightMode.textSelectionColor,
          ),
        ),
      ),
      SizedBox(height: 20),

      Container(
        margin: EdgeInsets.symmetric(horizontal: 30),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            GestureDetector(
              onTap: () async {
                // login
                LoginResponce responce = await model.signInWithGoogle(context);

                if (!responce.success) {
                  if (responce.error == AuthError.UserExit) {
                    return null; // exit
                  }
                  // Translate message
                  String message = translateError(responce.error);

                  // show snack bar
                  _scaffoldKey.currentState.showSnackBar(
                    errorSnackBar(context, message),
                  );
                } else {
                  // show dialog
                  showDialog(
                    context: context,
                    builder: (_) => SyncDialog(),
                  );

                  // pop() after two seconds
                  Future.delayed(Duration(seconds: 2)).then(
                    (_) => Navigator.pop(context),
                  );
                }
              },
              child: Container(
                width: 100,
                height: 50,
                decoration: BoxDecoration(
                  color: Color(0xFFDB4437),
                  borderRadius: BorderRadius.circular(100),
                ),
                child: Icon(EvaIcons.google, color: Colors.white, size: 28),
              ),
            ),
            GestureDetector(
              onTap: () async {
                // login
                LoginResponce responce =
                    await model.signInWithFacebook(context);

                if (!responce.success) {
                  // Translate message

                  if (responce.error == AuthError.UserExit) {
                    return null; // exit
                  }
                  String message = translateError(responce.error);

                  // show snack bar
                  _scaffoldKey.currentState.showSnackBar(
                    errorSnackBar(context, message),
                  );
                } else {
                  // show dialog
                  showDialog(
                    context: context,
                    builder: (_) => SyncDialog(),
                  );

                  // pop() after two seconds
                  Future.delayed(Duration(seconds: 2)).then(
                    (_) => Navigator.pop(context),
                  );
                }
              },
              child: Container(
                width: 100,
                height: 50,
                decoration: BoxDecoration(
                  color: Color(0xFF4267B2),
                  borderRadius: BorderRadius.circular(100),
                ),
                child: Icon(EvaIcons.facebook, color: Colors.white, size: 28),
              ),
            ),
          ],
        ),
      ),

      SizedBox(height: 10),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _model,
      child: Consumer<SyncViewModel>(
        builder: (_, model, child) {
          return GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: Theme(
              data: lightMode,
              child: Scaffold(
                appBar: model.state == ViewState.Busy ? ProgressBar() : null,
                key: _scaffoldKey,
                backgroundColor: lightMode.backgroundColor,
                body: Form(
                  key: _formKey,
                  child: SafeArea(
                    child: Center(
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: _ui(context, model),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
