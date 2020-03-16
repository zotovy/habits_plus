import 'package:flutter/material.dart';
import 'package:habits_plus/localization.dart';
import 'package:habits_plus/core/services/auth.dart';
import 'package:habits_plus/ui/widgets/progress_bar.dart';

class SignUpPage extends StatefulWidget {
  static final String id = 'signup_page';

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  // Services
  bool isLoading = false;
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController textEditingController = TextEditingController();

  // Form
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _email = '';
  String _password = '';
  String name = '';

  // Submit lofin form
  _submit() async {
    if (_formKey.currentState.validate()) {
      setState(() {
        isLoading = true;
      });
      _formKey.currentState.save();
      print(textEditingController.text == _password);
      await AuthService.signUpUser(
          context, _email, name, _password, '', _scaffoldKey);
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
        appBar: isLoading ? ProgressBar() : null,
        key: _scaffoldKey,
        body: Container(
          child: Form(
            key: _formKey,
            child: Stack(
              children: [
                Positioned(
                  bottom: MediaQuery.of(context).size.height * 0.03,
                  right: 0,
                  left: 0,
                  child: Container(
                    height: 50,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        // Google
                        Container(
                          width: 90,
                          height: 47,
                          decoration: BoxDecoration(
                            color: Color(0xFFDE5246),
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                offset: Offset(0, 0),
                                blurRadius: 5,
                                color: Color(0x55DE5246),
                              ),
                            ],
                          ),
                          child: Material(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(20),
                              splashColor: Colors.white24,
                              // onTap: () async =>
                              //     await AuthService.signInByGoogle(context),
                              child: Container(
                                padding: EdgeInsets.all(10),
                                child: Image(
                                  image: AssetImage('assets/images/google.png'),
                                ),
                              ),
                            ),
                          ),
                        ),

                        SizedBox(width: 20),

                        // Facebook
                        Container(
                          width: 90,
                          height: 47,
                          decoration: BoxDecoration(
                            color: Color(0xFF3B5998),
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                offset: Offset(0, 0),
                                blurRadius: 5,
                                color: Color(0x553B5998),
                              ),
                            ],
                          ),
                          child: Material(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(20),
                              splashColor: Colors.white24,
                              // onTap: () async =>
                              //     await AuthService.signInByFacebook(context),
                              child: Container(
                                padding: EdgeInsets.all(10),
                                child: Image(
                                  image:
                                      AssetImage('assets/images/facebook.png'),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      AppLocalizations.of(context).translate('signup_title'),
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
                                .translate('signup_email_error')
                            : null,
                        onSaved: (value) => setState(() => _email = value),
                        decoration: InputDecoration(
                          labelText:
                              AppLocalizations.of(context).translate('email'),
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.black12, width: 1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
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
                                .translate('signup_name_error')
                            : null,
                        onSaved: (value) => setState(() => _email = value),
                        decoration: InputDecoration(
                          labelText:
                              AppLocalizations.of(context).translate('name'),
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.black12, width: 1),
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
                        validator: (value) => null,
                        onSaved: (value) => null,
                        decoration: InputDecoration(
                          labelText: AppLocalizations.of(context)
                              .translate('password'),
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.black12, width: 1),
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
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Color(0x11000000),
                      ),
                      margin: EdgeInsets.symmetric(horizontal: 28),
                      child: TextFormField(
                        validator: (value) => value.length < 6 &&
                                textEditingController.text == value
                            ? AppLocalizations.of(context)
                                .translate('signup_password_error')
                            : null,
                        onSaved: (value) => setState(() => _password = value),
                        decoration: InputDecoration(
                          labelText: AppLocalizations.of(context)
                              .translate('password'),
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.black12, width: 1),
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
                                    .translate('signup_title'),
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
                                fontSize: 16,
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () => Navigator.pushReplacementNamed(
                              context,
                              'login_page',
                            ),
                            child: Text(
                              AppLocalizations.of(context)
                                  .translate('signup_link'),
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
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
  TextEditingController textEditingController = TextEditingController();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _password = '';

  // Services
  bool isLoading = false;
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // Submit lofin form
  _submit() async {
    if (_formKey.currentState.validate()) {
      setState(() {
        isLoading = true;
      });
      _formKey.currentState.save();
      await AuthService.signUpUser(context, widget.email, widget.name,
          widget.profileImg, _password, _scaffoldKey);
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
        appBar: AppBar(
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
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: Color(0xFFDE5246),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        offset: Offset(0, 0),
                        blurRadius: 5,
                        color: Color(0x55DE5246),
                      ),
                    ],
                  ),
                  child: Container(
                    padding: EdgeInsets.all(10),
                    child: Image(
                      image: AssetImage('assets/images/google.png'),
                    ),
                  ),
                ),

                // Password
                SizedBox(height: 50),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Color(0x11000000),
                  ),
                  margin: EdgeInsets.symmetric(horizontal: 28),
                  child: TextFormField(
                    controller: textEditingController,
                    validator: (value) => null,
                    onSaved: (value) => null,
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

                // Password 2
                SizedBox(height: 7),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Color(0x11000000),
                  ),
                  margin: EdgeInsets.symmetric(horizontal: 28),
                  child: TextFormField(
                    validator: (value) =>
                        value.length < 6 && textEditingController.text == value
                            ? AppLocalizations.of(context)
                                .translate('signup_password_error')
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

                // Confirm button
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
                                .translate('signup_title'),
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
              ],
            ),
          ),
        ),
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
  bool isLoading = false;
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // Submit lofin form
  _submit() async {
    if (_formKey.currentState.validate()) {
      setState(() {
        isLoading = true;
      });
      print(textEditingController.text);
      _formKey.currentState.save();
      await AuthService.signUpUser(
          context, _email, widget.name, '', _password, _scaffoldKey);
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
        appBar: AppBar(
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
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: Color(0xFF3B5998),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            offset: Offset(0, 0),
                            blurRadius: 5,
                            color: Color(0x553B5998),
                          ),
                        ],
                      ),
                      child: Container(
                        padding: EdgeInsets.all(10),
                        child: Image(
                          image: AssetImage('assets/images/facebook.png'),
                        ),
                      ),
                    ),

                    // Email
                    SizedBox(height: 50),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Color(0x11000000),
                      ),
                      margin: EdgeInsets.symmetric(horizontal: 28),
                      child: TextFormField(
                        validator: (value) => value == ''
                            ? AppLocalizations.of(context)
                                .translate('signup_email_error')
                            : null,
                        onSaved: (value) => setState(() => _email = value),
                        decoration: InputDecoration(
                          labelText:
                              AppLocalizations.of(context).translate('email'),
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.black12, width: 1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),

                    // Password
                    SizedBox(height: 10),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Color(0x11000000),
                      ),
                      margin: EdgeInsets.symmetric(horizontal: 28),
                      child: TextFormField(
                        controller: textEditingController,
                        validator: (value) => null,
                        onSaved: (value) => null,
                        decoration: InputDecoration(
                          labelText: AppLocalizations.of(context)
                              .translate('password'),
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.black12, width: 1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        obscureText: true,
                      ),
                    ),

                    // Password 2
                    SizedBox(height: 10),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Color(0x11000000),
                      ),
                      margin: EdgeInsets.symmetric(horizontal: 28),
                      child: TextFormField(
                        validator: (value) => value.length < 6 &&
                                textEditingController.text == value
                            ? AppLocalizations.of(context)
                                .translate('signup_password_error')
                            : null,
                        onSaved: (value) => setState(() => _password = value),
                        decoration: InputDecoration(
                          labelText: AppLocalizations.of(context)
                              .translate('password'),
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.black12, width: 1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        obscureText: true,
                      ),
                    ),

                    // Confirm button
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
                                    .translate('signup_title'),
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
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
