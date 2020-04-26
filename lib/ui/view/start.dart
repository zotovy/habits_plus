import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:habits_plus/core/enums/viewstate.dart';
import 'package:habits_plus/core/models/user.dart';
import 'package:habits_plus/core/viewmodels/start_model.dart';
import 'package:habits_plus/localization.dart';
import 'package:habits_plus/locator.dart';
import 'package:habits_plus/ui/view/loading.dart';
import 'package:habits_plus/ui/widgets/confirm_button.dart';
import 'package:habits_plus/ui/widgets/rounded_textField.dart';
import 'package:provider/provider.dart';

class StartPage extends StatefulWidget {
  @override
  _StartPageState createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  StartViewModel _model = locator<StartViewModel>();

  String _animation = 'transition';

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _name = '';
  String _email = '';

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration(milliseconds: 2500)).then((_) {
      setState(() {
        _animation = 'repeated';
      });
    });
  }

  List<Widget> _children(StartViewModel model) {
    return [
      // Animated illustration
      Container(
        height: 225,
        width: double.infinity,
        child: FlareActor(
          'assets/flare/start.flr',
          animation: _animation,
          fit: BoxFit.fitWidth,
        ),
      ),
      SizedBox(height: 25),

      // Title
      Text(
        AppLocalizations.of(context).translate('start_title'),
        style: TextStyle(
          color: Theme.of(context).textSelectionHandleColor,
          fontWeight: FontWeight.w600,
          fontSize: 26,
        ),
      ),

      // Desc
      Text(
        AppLocalizations.of(context).translate('start_desc'),
        style: TextStyle(
          color: Theme.of(context).textSelectionColor,
          fontSize: 18,
        ),
      ),
      SizedBox(height: 15),

      // Name
      RoundedTextField(
        prefix: Icons.person,
        hasObscure: false,
        labelLocalizationPath: 'start_name',
        onSaved: (String val) => _name = val.trim(),
        margin: EdgeInsets.symmetric(horizontal: 28),
      ),
      SizedBox(height: 7),

      // Email
      RoundedTextField(
        prefix: Icons.email,
        hasObscure: false,
        labelLocalizationPath: 'start_email',
        onSaved: (String val) => _email = val.trim(),
        margin: EdgeInsets.symmetric(horizontal: 28),
      ),
      SizedBox(height: 7),

      // Confirm
      ConfirmButton(
        text: 'confirm',
        submit: () async {
          _formKey.currentState.save();
          User _user = User(
            email: _email,
            name: _name == '' ? 'User' : _name,
            isEmailConfirm: false,
          );

          await model.setUser(_user);

          Navigator.pushNamed(context, '');
        },
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _model,
      child: Consumer<StartViewModel>(
        builder: (_, StartViewModel model, child) {
          return Scaffold(
            backgroundColor: Theme.of(context).backgroundColor,
            body: model.state == ViewState.Busy
                ? LoadingPage()
                : GestureDetector(
                    onTap: () => FocusScope.of(context).unfocus(),
                    child: Form(
                      key: _formKey,
                      child: SafeArea(
                        child: Center(
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: _children(model),
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
