import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:habits_plus/core/models/habit.dart';
import 'package:habits_plus/core/models/notification.dart';
import 'package:habits_plus/core/services/database.dart';
import 'package:habits_plus/core/util/constant.dart';
import 'package:habits_plus/localization.dart';
import 'package:habits_plus/locator.dart';

class NotificationServices {
  List<HabitNotification> _notifications = [];
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  DatabaseServices _databaseServices = locator<DatabaseServices>();

  NotificationServices() {
    // Initialized android settings
    var initializationSettingsAndroid = AndroidInitializationSettings(
      'app_icon', // Todo: need to fix display
    );

    // Initialized ios settings
    var initialisationSettingsIos = IOSInitializationSettings();

    // Init all setting
    var initialisationSettings = InitializationSettings(
      initializationSettingsAndroid,
      initialisationSettingsIos,
    );

    // init plugin
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    // Pass settings data to plugin & setup onSelect method
    flutterLocalNotificationsPlugin.initialize(
      initialisationSettings,
      onSelectNotification: _onSelectNotification,
    );
  }

  // This function delete passed notification
  Future<bool> deleteNotif(HabitNotification notif) async {
    // check if Notification is available
    if (flutterLocalNotificationsPlugin == null) return false;

    // cancel notification
    await flutterLocalNotificationsPlugin.cancel(notif.notificationId);

    return true;
  }

  // This function show single notification
  Future<bool> planNotif(HabitNotification notif, bool sound) async {
    // check if Notification is available
    if (flutterLocalNotificationsPlugin == null) return false; // error code

    try {
      // get id for notification
      int id = await _databaseServices.getLatestNotificationId() + 1;
      print('id = $id');

      // Specify android channel description
      var androidPlatformChannelSpicifics = AndroidNotificationDetails(
        'channel_id',
        'Channel name',
        'Channel description',
        playSound: sound,
      );

      // Specify ios channel description
      var iosChannelSpecifics = IOSNotificationDetails();

      // setup main notification
      var platformChannelSpecific = NotificationDetails(
        androidPlatformChannelSpicifics,
        iosChannelSpecifics,
      );

      print(
        'scheldure! ${notif.date} Seconds to: ${notif.date.difference(DateTime.now()).inSeconds.abs()}',
      );

      flutterLocalNotificationsPlugin.schedule(
        id,
        notif.title,
        notif.description,
        notif.date,
        platformChannelSpecific,
        payload: 'habitNotification',
      );

      _databaseServices.changeLatestNotifId(1);

      print('success\n\n');

      return true; // success code
    } catch (e) {
      print('Error when planNotif:    $e');
      return false; // Error code
    }
  }

  // This function will create notification for whole habit duration
  Future<bool> createNotifications(BuildContext context, Habit habit,
      {bool sound = false}) async {
    // check if Notification is available
    if (flutterLocalNotificationsPlugin == null) {
      print('flutterLocalNotificationsPlugin is null');
      return false;
    } // error code

    try {
      DateTime now = dateFormater.parse(DateTime.now().toString());
      DateTime start = habit.duration[0];
      DateTime end = habit.duration[1];
      int difference = start.difference(end).inDays.abs() + 1;

      // Start -> end
      for (var i = 0; i < difference; i++) {
        DateTime thisDate = start.add(Duration(days: i));
        if (habit.repeatDays[thisDate.weekday - 1] &&
            (thisDate.isAfter(now) || thisDate == now)) {
          print('find day $thisDate');

          _databaseServices.changeNotificationsDates(thisDate, 1);

          // count this day habits
          int amount =
              await _databaseServices.getNotificationAmountByDate(thisDate);

          print(
            'today habits amount: $amount',
          );

          // Check date amount
          if (amount >= 1) {
            _databaseServices.removeNotificationsByDate(thisDate);

            // Translate fields
            String title = AppLocalizations.of(context)
                    .translate('notifications_multi1') +
                amount +
                AppLocalizations.of(context).translate('notifications_multi2');

            // Create notification
            HabitNotification notification = HabitNotification(
              habitId: habit.id,
              date: thisDate,
              title: title,
              description: '',
              habit: habit,
              isHabitDelete: false,
              isOf: false,
            );

            // plan
            planNotif(notification, sound);
          } else {
            // Create notification
            HabitNotification notification = HabitNotification(
              habitId: habit.id,
              date: thisDate
                  .add(Duration(
                    hours: habit.timeOfDay.hour,
                  ))
                  .add(
                    Duration(
                      minutes: habit.timeOfDay.minute,
                    ),
                  ),
              title: habit.title,
              description: habit.description,
            );

            // plan
            planNotif(notification, sound);

            // Add to DB
            _databaseServices.createNotification(notification);
          }
        }
      }

      return true; //success code
    } catch (e) {
      print('Error when create Notifications: $e');
      return false;
    }
  }

  /// Call when user click on notification
  Future _onSelectNotification(String payload) {
    print('Run app');
  }

  set notifications(HabitNotification elem) => _notifications.add(elem);
}
