import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:habits_plus/core/enums/viewstate.dart';
import 'package:habits_plus/core/viewmodels/settings_model.dart';
import 'package:habits_plus/localization.dart';
import 'package:habits_plus/locator.dart';
import 'package:habits_plus/ui/view/loading.dart';
import 'package:habits_plus/ui/widgets/error_snackbar.dart';
import 'package:habits_plus/ui/widgets/settings/appbar.dart';
import 'package:habits_plus/ui/widgets/switch.dart';
import 'package:provider/provider.dart';

class LockSettingsPage extends StatefulWidget {
  @override
  _LockSettingsPageState createState() => _LockSettingsPageState();
}

class _LockSettingsPageState extends State<LockSettingsPage> {
  SettingsViewModel _model = locator<SettingsViewModel>();
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  List<Widget> _ui(SettingsViewModel model) {
    return [
      // Illustrations
      Container(
        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        height: 200,
        child: FlareActor(
          'assets/flare/security.flr',
          animation: 'lightTransition',
          fit: BoxFit.contain,
        ),
      ),
      SizedBox(height: 10),

      Container(
        margin: EdgeInsets.symmetric(horizontal: 15),
        child: Text(
          AppLocalizations.of(context).translate('security').toUpperCase(),
          style: TextStyle(
            fontSize: 18,
            color: Theme.of(context).textSelectionColor.withOpacity(0.75),
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      SizedBox(height: 10),

      // Enable / disable
      GestureDetector(
        onTap: () => model.triggerIsLockScreen(
          context,
          _scaffoldKey,
        ),
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 15, vertical: 6),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              // Text
              Text(
                AppLocalizations.of(context).translate('lock_screen'),
                style: TextStyle(
                  fontSize: 20,
                  color: Theme.of(context).textSelectionHandleColor,
                ),
              ),

              // Switcher
              AnimatedContainer(
                duration: Duration(microseconds: 300),
                padding: EdgeInsets.all(3),
                height: 30,
                width: 55,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  color: model.isLockScreen
                      ? Theme.of(context).primaryColor
                      : Theme.of(context).disabledColor,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    AnimatedContainer(
                      duration: Duration(milliseconds: 200),
                      margin:
                          EdgeInsets.only(left: model.isLockScreen ? 23 : 0),
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              // CustomSwitch(
              //   value: model.isLockScreen,
              //   callback: (bool value) => model.triggerIsLockScreen(
              //     context,
              //     value,
              //     _scaffoldKey,
              //   ),
              //   isDisable: false,
              // ),
            ],
          ),
        ),
      ),

      // Edit
      GestureDetector(
        onTap: () => model.editLockCode(context),
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 15, vertical: 6),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              // Text
              Text(
                AppLocalizations.of(context).translate('edit'),
                style: TextStyle(
                  fontSize: 20,
                  color: Theme.of(context).textSelectionHandleColor,
                ),
              ),

              // go
              Icon(
                Icons.chevron_right,
                color: Theme.of(context).textSelectionColor,
                size: 24,
              ),
            ],
          ),
        ),
      ),

      // Delete
      GestureDetector(
        onTap: () => model.deleteCode(context, _scaffoldKey),
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 15, vertical: 6),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              // Text
              Text(
                AppLocalizations.of(context).translate('delete'),
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.redAccent,
                ),
              ),

              // go
              Icon(
                Icons.chevron_right,
                color: Theme.of(context).textSelectionColor,
                size: 24,
              ),
            ],
          ),
        ),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _model,
      child: Consumer<SettingsViewModel>(
        builder: (_, model, child) {
          return Scaffold(
            key: _scaffoldKey,
            backgroundColor: Theme.of(context).backgroundColor,
            appBar: SettingsPageAppBar('security'),
            body: model.state == ViewState.Busy
                ? LoadingPage()
                : SafeArea(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: _ui(model),
                      ),
                    ),
                  ),
          );
        },
      ),
    );
  }
}
