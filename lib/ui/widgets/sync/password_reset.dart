import 'package:flutter/material.dart';
import 'package:habits_plus/core/util/constant.dart';
import 'package:habits_plus/core/viewmodels/sync_model.dart';
import 'package:habits_plus/localization.dart';
import 'package:habits_plus/locator.dart';
import 'package:habits_plus/ui/widgets/create/confirm_button.dart';
import 'package:habits_plus/ui/widgets/rounded_textfield.dart';
import 'package:provider/provider.dart';

class PasswordReset extends StatefulWidget {
  Function(String email) callback;

  PasswordReset({
    this.callback,
  });

  @override
  _PasswordResetState createState() => _PasswordResetState();
}

class _PasswordResetState extends State<PasswordReset> {
  String _email = '';
  GlobalKey<FormState> _formState = GlobalKey<FormState>();
  SyncViewModel _model = locator<SyncViewModel>();

  List<Widget> _ui(BuildContext context, SyncViewModel model) {
    return [
      Text(
        AppLocalizations.of(context).translate('reset_password'),
        style: TextStyle(
          color: lightMode.textSelectionHandleColor,
          fontSize: 22,
          fontWeight: FontWeight.w600,
        ),
      ),
      Text(
        AppLocalizations.of(context).translate('reset_password_desc'),
        textAlign: TextAlign.center,
        style: TextStyle(
          color: lightMode.textSelectionColor,
          fontSize: 18,
        ),
      ),
      SizedBox(height: 15),

      // Email
      RoundedTextField(
        hint: 'email',
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
        needMargin: false,
      ),
      SizedBox(height: 10),
      ConfirmButton(
        needMargin: false,
        stringPath: 'confirm',
        onPress: () {
          if (_formState.currentState.validate()) {
            _formState.currentState.save();

            widget.callback(_email);
          }
        },
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _model,
      child: Consumer<SyncViewModel>(
        builder: (_, model, child) {
          return Theme(
            data: lightMode,
            child: Form(
              key: _formState,
              child: GestureDetector(
                onTap: () => FocusScope.of(context).unfocus(),
                child: Scaffold(
                  body: Center(
                    child: Container(
                      padding: EdgeInsets.all(15),
                      margin: EdgeInsets.all(35),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: lightMode.backgroundColor,
                      ),
                      child: SingleChildScrollView(
                        child: Column(
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
