import 'package:flutter/material.dart';
import 'package:habits_plus/localization.dart';
import 'package:habits_plus/services/auth.dart';
import 'package:habits_plus/widgets/progress_bar.dart';

class LoginPage extends StatefulWidget {
  static final String id = 'login_page';

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // Services
  bool isLoading = false;
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // Form
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _email = '';
  String _password = '';

  // Submit lofin form
  _submit() async {
    if (_formKey.currentState.validate()) {
      setState(() {
        isLoading = true;
      });
      _formKey.currentState.save();
      await AuthService.login(_email, _password, _scaffoldKey, context);
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: _scaffoldKey,
        appBar: isLoading ? ProgressBar() : null,
        body: Container(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  AppLocalizations.of(context).translate('login_title'),
                  style: TextStyle(
                    color: Color(0xFF282828),
                    fontSize: 28,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 20),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Color(0x11000000),
                  ),
                  margin: EdgeInsets.symmetric(horizontal: 28),
                  child: TextFormField(
                    validator: (value) => value == ''
                        ? AppLocalizations.of(context)
                            .translate('login_email_error')
                        : null,
                    onSaved: (value) => setState(() => _email = value),
                    decoration: InputDecoration(
                      labelText:
                          AppLocalizations.of(context).translate('email'),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black12, width: 1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Color(0x11000000),
                  ),
                  margin: EdgeInsets.symmetric(horizontal: 28),
                  child: TextFormField(
                    validator: (value) => value == ''
                        ? AppLocalizations.of(context)
                            .translate('login_password_error')
                        : null,
                    onSaved: (value) => setState(() => _password = value),
                    decoration: InputDecoration(
                      labelText:
                          AppLocalizations.of(context).translate('password'),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black12, width: 1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    obscureText: true,
                  ),
                ),
                SizedBox(height: 10),
                Container(
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
                        onTap: _submit,
                        child: Center(
                          child: Text(
                            AppLocalizations.of(context)
                                .translate('login_title'),
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
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 28),
                  height: 25,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      GestureDetector(
                        onTap: () => print('go to forgot password page'),
                        child: Text(
                          AppLocalizations.of(context)
                              .translate('forgot_password'),
                          style: TextStyle(
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () => Navigator.pushReplacementNamed(
                          context,
                          'signup_page',
                        ),
                        child: Text(
                          AppLocalizations.of(context).translate('login_link'),
                        ),
                      ),
                    ],
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
