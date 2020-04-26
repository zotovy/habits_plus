import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:habits_plus/core/models/habit.dart';
import 'package:habits_plus/core/models/notification.dart';
import 'package:habits_plus/core/models/theme.dart';
import 'package:habits_plus/core/util/constant.dart';
import 'package:habits_plus/core/viewmodels/settings_model.dart';
import 'package:habits_plus/localization.dart';
import 'package:habits_plus/locator.dart';
import 'package:habits_plus/ui/widgets/error_snackbar.dart';
import 'package:habits_plus/ui/widgets/settings/appbar.dart';
import 'package:habits_plus/ui/widgets/switch.dart';
import 'package:provider/provider.dart';

class NotificationsSettingsPage extends StatefulWidget {
  @override
  _NotificationsSettingsPageState createState() =>
      _NotificationsSettingsPageState();
}

class _NotificationsSettingsPageState extends State<NotificationsSettingsPage> {
  SettingsViewModel _model = locator<SettingsViewModel>();
  String animation = '';
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();

    bool isDark = Provider.of<ThemeModel>(context, listen: false).isDarkMode;

    if (isDark) {
      animation = 'darkTransition';
    } else {
      animation = 'lightTransition';
    }

    Future.delayed(Duration(milliseconds: 500)).then((_) {
      if (isDark) {
        animation = 'darkStatic';
      } else {
        animation = 'lightStatic';
      }
    });
  }

  Widget _switchTile(
    SettingsViewModel model,
    HabitNotification notification,
    int i,
  ) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 15, vertical: 3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          // Icon
          AnimatedContainer(
            duration: Duration(milliseconds: 200),
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: model.isNotifications
                  ? Theme.of(context).primaryColor
                  : Theme.of(context).disabledColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              habitsIcons[notification.habit.iconCode],
              color: Colors.white,
              size: 28,
            ),
          ),

          SizedBox(width: 5),

          // Text
          Text(
            notification.habit.title,
            style: TextStyle(
              fontSize: 18,
              color: Theme.of(context).textSelectionColor,
            ),
          ),

          // Switcher
          Expanded(
            child: Align(
              alignment: Alignment.centerRight,
              child: CustomSwitch(
                value: notification.habit.hasReminder,
                callback: (bool val) => model.isNotifications
                    ? model.setHabitsNotifications(context, i, val)
                    : null,
                isDisable: !model.isNotifications,
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _ui(BuildContext context, SettingsViewModel model) {
    return [
      // Illustration
      Container(
        height: 300,
        child: FlareActor(
          'assets/flare/notifications.flr',
          animation: animation,
          fit: BoxFit.contain,
        ),
      ),

      // Main
      Container(
        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 3),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            // Text
            Text(
              AppLocalizations.of(context).translate('notifications'),
              style: TextStyle(
                fontSize: 20,
                color: Theme.of(context).textSelectionHandleColor,
              ),
            ),

            // Switcher
            CupertinoSwitch(
              value: model.isNotifications,
              activeColor: Theme.of(context).primaryColor,
              onChanged: (bool val) {
                model.setIsNotifications(context, val);
              },
            ),
          ],
        ),
      ),

      Tooltip(
        message: model.isSync
            ? AppLocalizations.of(context).translate('sync_tooltip')
            : AppLocalizations.of(context).translate('no_sync_tooltip'),
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 15, vertical: 6),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              // Text
              Text(
                AppLocalizations.of(context).translate('email_notifications'),
                style: TextStyle(
                  fontSize: 20,
                  color: Theme.of(context).textSelectionHandleColor,
                ),
              ),

              // Switcher
              CustomSwitch(
                value: model.isSync,
                callback: (bool val) {
                  model.isSync = val;
                },
                isDisable: !model.isSync || !model.isNotifications,
              ),
            ],
          ),
        ),
      ),

      Container(
        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 6),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            // Text
            Text(
              AppLocalizations.of(context).translate('sound_notifications'),
              style: TextStyle(
                fontSize: 20,
                color: Theme.of(context).textSelectionHandleColor,
              ),
            ),

            // Switcher
            CustomSwitch(
              value: model.isSoundNotifications,
              callback: (bool val) async {
                bool dbcode = await model.setIsSoundNotifications(context, val);

                if (!dbcode) {
                  _scaffoldKey.currentState.showSnackBar(
                    errorSnackBar(context, 'save_error'),
                  );
                }
              },
              isDisable: !model.isNotifications,
            ),
          ],
        ),
      ),

      model.notifications.length == 0
          ? SizedBox.shrink()
          : Container(
              margin: EdgeInsets.symmetric(horizontal: 15),
              child: Text(
                AppLocalizations.of(context).translate('habits').toUpperCase(),
                style: TextStyle(
                  fontSize: 20,
                  color: Theme.of(context).textSelectionColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

      // Habits
      Container(
        child: Column(
          children: List.generate(
            model.notifications.length,
            (int i) => _switchTile(model, model.notifications[i], i),
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
          return GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: Scaffold(
              key: _scaffoldKey,
              backgroundColor: Theme.of(context).backgroundColor,
              appBar: SettingsPageAppBar('notifications'),
              body: SafeArea(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: _ui(context, model),
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
