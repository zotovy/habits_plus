import 'package:flutter/material.dart';
import 'package:habits_plus/core/enums/viewstate.dart';
import 'package:habits_plus/core/viewmodels/login_model.dart';
import 'package:habits_plus/localization.dart';
import 'package:habits_plus/core/services/auth.dart';
import 'package:habits_plus/ui/UIHelper.dart';
import 'package:habits_plus/ui/widgets/forgot_link.dart';
import 'package:habits_plus/ui/widgets/login_button.dart';
import 'package:habits_plus/ui/widgets/login_confirmButt.dart';
import 'package:habits_plus/ui/widgets/login_textField.dart';
import 'package:habits_plus/ui/widgets/progress_bar.dart';
import 'package:provider/provider.dart';

import '../../locator.dart';

class LoginPage extends StatefulWidget {
  static final String id = 'login_page';

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // Services
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  LoginViewModel _model = locator<LoginViewModel>();

  // Form
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _email = '';
  String _password = '';

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<LoginViewModel>.value(
      value: _model,
      child: Consumer<LoginViewModel>(
        builder: (_, LoginViewModel model, child) {
          return GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: Scaffold(
              key: _scaffoldKey,
              appBar: model.state == ViewState.Busy ? ProgressBar() : null,
              backgroundColor: Colors.white,
              body: Center(
                child: Container(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(height: 100),
                        // Title
                        Text(
                          AppLocalizations.of(context).translate('login_title'),
                          style: UIHelper.loginTitleStyle,
                        ),

                        UIHelper.padAll20,

                        // Emain
                        LoginTextField(
                          errorLocalizationPath: 'login_email_error',
                          labelLocalizationPath: 'email',
                          onSaved: (value) => _email = value,
                        ),

                        UIHelper.padAll10,

                        // Password
                        LoginTextField(
                          errorLocalizationPath: 'login_password_error',
                          labelLocalizationPath: 'password',
                          onSaved: (String value) => _password = value,
                        ),

                        UIHelper.padAll10,

                        // Button
                        LoginConfirmButton(
                          submit: () async {
                            if (_formKey.currentState.validate()) {
                              // Login Form doesn't have errors
                              model.setState(ViewState.Busy);

                              _formKey.currentState.save();
                              await model.login(
                                _email,
                                _password,
                                _scaffoldKey,
                                context,
                              );

                              model.setState(ViewState.Idle);
                            }
                          },
                          text: 'login_title',
                        ),

                        // Forgot password & signup page
                        ForgotPageLink(isLoginPage: true),

                        Container(
                          child: Container(
                            height: 150,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: <Widget>[
                                // Google
                                LoginButton(
                                  color: Color(0xFFDE5246),
                                  imagePath: 'assets/images/google.png',
                                  onTap: () async =>
                                      await model.googleLogin(context),
                                ),

                                UIHelper.padAll20,

                                // Facebook
                                LoginButton(
                                  color: Color(0xFF3B5998),
                                  imagePath: 'assets/images/facebook.png',
                                  onTap: () async =>
                                      await model.facebookLogin(context),
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
            ),
          );
        },
      ),
    );
  }
}
