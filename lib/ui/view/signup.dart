import 'package:flutter/material.dart';
import 'package:habits_plus/core/enums/viewstate.dart';
import 'package:habits_plus/core/viewmodels/signup_model.dart';
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

class SignUpPage extends StatefulWidget {
  static final String id = 'signup_page';

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  // Services
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController textEditingController = TextEditingController();
  SignUpViewModel _model = locator<SignUpViewModel>();

  // Form
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _email = '';
  String _password = '';
  String _name = '';

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<SignUpViewModel>.value(
      value: _model,
      child: Consumer<SignUpViewModel>(
        builder: (_, SignUpViewModel model, child) {
          return GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: Scaffold(
              appBar: model.state == ViewState.Busy ? ProgressBar() : null,
              backgroundColor: Colors.white,
              key: _scaffoldKey,
              body: Container(
                child: Form(
                  key: _formKey,
                  child: Center(
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            AppLocalizations.of(context)
                                .translate('signup_title'),
                            style: TextStyle(
                              color: Color(0xFF282828),
                              fontSize: 28,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          UIHelper.padAll20,
                          LoginTextField(
                            errorLocalizationPath: 'signup_email_error',
                            labelLocalizationPath: 'email',
                            onSaved: (value) => _email = value,
                          ),
                          UIHelper.padAll5,
                          LoginTextField(
                            errorLocalizationPath: 'signup_name_error',
                            labelLocalizationPath: 'name',
                            onSaved: (value) => _name = value,
                          ),
                          UIHelper.padAll5,
                          LoginTextField(
                            errorLocalizationPath: 'signup_password_error',
                            labelLocalizationPath: 'password',
                            onSaved: (value) => _name = value,
                            hasObscure: true,
                          ),
                          UIHelper.padAll5,
                          LoginTextField(
                            errorLocalizationPath: 'signup_password_error',
                            labelLocalizationPath: 'password',
                            onSaved: (String value) => _name = value,
                            hasObscure: true,
                          ),
                          UIHelper.padAll10,
                          LoginConfirmButton(
                            text: 'signup_title',
                            submit: () async {
                              if (_formKey.currentState.validate()) {
                                _formKey.currentState.save();
                                await model.signUp(
                                  context,
                                  _email,
                                  _name,
                                  '',
                                  _password,
                                  _scaffoldKey,
                                  false,
                                );
                                Navigator.pushReplacementNamed(context, '/');
                              }
                            },
                          ),
                          ForgotPageLink(isLoginPage: false),
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
            ),
          );
        },
      ),
    );
  }
}

class GoogleSignUpPage extends StatefulWidget {
  String email;
  String name;
  String profileImg;

  GoogleSignUpPage({
    this.email,
    this.name,
    this.profileImg,
  });

  @override
  _GoogleSignUpPageState createState() => _GoogleSignUpPageState();
}

class _GoogleSignUpPageState extends State<GoogleSignUpPage> {
  // Form
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _password = '';

  // Services
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  SignUpViewModel _model = locator<SignUpViewModel>();

  String _validator(String value) {
    value.length >= 6 && value == _password
        ? AppLocalizations.of(context).translate('signup_password_error')
        : null;
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<SignUpViewModel>.value(
      value: _model,
      child: Consumer<SignUpViewModel>(
        builder: (_, SignUpViewModel model, child) {
          return GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: Scaffold(
              key: _scaffoldKey,
              appBar: model.state == ViewState.Busy
                  ? ProgressBar()
                  : AppBar(
                      elevation: 0,
                      backgroundColor: Colors.transparent,
                      leading: IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: Icon(
                          Icons.arrow_back_ios,
                          color: Colors.black38,
                        ),
                      ),
                    ),
              body: Container(
                width: double.infinity,
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      // Google icon
                      LoginButton(
                        color: Color(0xFFDE5246),
                        height: 100,
                        width: 100,
                        imagePath: 'assets/images/google.png',
                        onTap: null,
                      ),

                      // Password
                      SizedBox(height: 50),
                      LoginTextField(
                        labelLocalizationPath: 'password',
                        onSaved: (String value) => _password = value,
                        hasObscure: true,
                      ),

                      // Password 2
                      SizedBox(height: 7),
                      LoginTextField(
                        labelLocalizationPath: 'password',
                        hasObscure: true,
                        validator: _validator,
                      ),

                      // Confirm button
                      SizedBox(height: 10),
                      LoginConfirmButton(
                        text: 'signup_title',
                        submit: () async {
                          if (_formKey.currentState.validate()) {
                            _formKey.currentState.save();
                            await model.signUp(
                              context,
                              widget.email,
                              widget.name,
                              widget.profileImg,
                              _password,
                              _scaffoldKey,
                              false,
                            );
                          }
                        },
                      ),
                    ],
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

class FacebookSignUpPage extends StatefulWidget {
  String name;

  FacebookSignUpPage({
    this.name,
  });

  @override
  _FacebookSignUpPageState createState() => _FacebookSignUpPageState();
}

class _FacebookSignUpPageState extends State<FacebookSignUpPage> {
  // Form
  TextEditingController textEditingController = TextEditingController();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _password = '';
  String _email = '';

  // Services
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  SignUpViewModel _model = locator<SignUpViewModel>();

  String _validator(value) {
    return value == ''
        ? AppLocalizations.of(context).translate('signup_email_error')
        : null;
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<SignUpViewModel>.value(
      value: _model,
      child: Consumer<SignUpViewModel>(
        builder: (_, SignUpViewModel model, child) {
          return GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: Scaffold(
              key: _scaffoldKey,
              appBar: model.state == ViewState.Busy
                  ? ProgressBar()
                  : AppBar(
                      elevation: 0,
                      backgroundColor: Colors.transparent,
                      leading: IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: Icon(
                          Icons.arrow_back_ios,
                          color: Colors.black38,
                        ),
                      ),
                    ),
              body: Container(
                width: double.infinity,
                child: Form(
                  key: _formKey,
                  child: Center(
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          // Google icon
                          LoginButton(
                            color: Color(0xFF3B5998),
                            width: 100,
                            height: 100,
                            imagePath: 'assets/images/facebook.png',
                            onTap: null,
                          ),

                          // Email
                          SizedBox(height: 50),
                          LoginTextField(
                            errorLocalizationPath: 'signup_email_error',
                            validator: _validator,
                            labelLocalizationPath: 'email',
                            onSaved: (value) => _email = value,
                          ),

                          // Password
                          SizedBox(height: 10),
                          LoginTextField(
                            hasObscure: true,
                            labelLocalizationPath: 'password',
                            onSaved: (value) => null,
                          ),

                          // Password 2
                          SizedBox(height: 10),
                          LoginTextField(
                            errorLocalizationPath: 'signup_password_error',
                            hasObscure: true,
                            labelLocalizationPath: 'password',
                            onSaved: (value) => _password = value,
                            validator: _validator,
                          ),

                          // Confirm button
                          SizedBox(height: 10),
                          LoginConfirmButton(
                            text: 'signup_title',
                            submit: () async {
                              if (_formKey.currentState.validate()) {
                                _formKey.currentState.save();
                                await model.signUp(
                                  context,
                                  _email,
                                  widget.name,
                                  '',
                                  _password,
                                  _scaffoldKey,
                                  true,
                                );
                              }
                            },
                          ),
                        ],
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
