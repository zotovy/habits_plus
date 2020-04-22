import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:habits_plus/core/models/app_settings.dart';
import 'package:habits_plus/core/models/comment.dart';
import 'package:habits_plus/core/models/habit.dart';
import 'package:habits_plus/core/models/notification.dart';
import 'package:habits_plus/core/models/task.dart';
import 'package:habits_plus/core/models/user.dart';
import 'package:habits_plus/core/util/constant.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class DatabaseServices {
  SharedPreferences prefs;

  /// Setup SharedPreferences
  Future<bool> setupSharedPrefferences() async {
    try {
      prefs = await SharedPreferences.getInstance();
      // await prefs.remove('tasks');

      return true;
    } catch (e) {
      print('Error while setup SharedPrefferences $e');
      return null;
    }
  }

  Future<AppSettings> setupApp() async {
    bool ready = await setupSharedPrefferences();

    if (!ready) return null;

    bool _isDarkMode = isDarkMode();
    bool isUserLogin = (await getUser()) != null;

    return AppSettings(
      isDarkMode: _isDarkMode,
      isUserLogin: isUserLogin,
    );
  }

  bool checkPref() => prefs == null;

  /// Function localy save task Shared Preferences
  Future<bool> saveTask(Task task) async {
    if (checkPref()) {
      print('SharedPreferences is null!');
      return null;
    }

    try {
      // Get current List<Task>
      List<String> _ = prefs.getStringList('tasks');
      List<Task> _data = _ == null
          ? []
          : _
              .map(
                (String _) => Task.fromJson(json.decode(_)),
              )
              .toList();

      // Check id
      if (task.id == null || task.id == '') task.id = Uuid().v4();

      // Add task -> current List<Task>
      _data.add(task);

      // Encode back from List<Task> -> List<String>
      List<String> _listOfString = _data
          .map(
            (i) => jsonEncode(i.toJson()),
          )
          .toList();

      await prefs.setStringList('tasks', _listOfString);

      // DB code
      return true;
    } catch (e) {
      print('Error while save task: $e');
      return false;
    }
  }

  /// Function localy save task Shared Preferences
  Future<bool> saveHabit(Habit habit) async {
    if (checkPref()) {
      print('SharedPreferences is null!');
      return null;
    }

    try {
      // Get current List<Habit>
      List<Habit> _data = await getHabits();

      // Check id
      if (habit.id == null || habit.id == '') habit.id = Uuid().v4();

      // Add habit -> current List<Habit>
      _data.add(habit);

      // Encode back from List<Habit> -> List<String>
      List<String> _listOfString = _data.map(
        (i) {
          return jsonEncode(i.toJson());
        },
      ).toList();

      await prefs.setStringList('habits', _listOfString);

      // DB code
      return true;
    } catch (e) {
      print('Error while save habit: $e');
      return false;
    }
  }

  Future<List<Habit>> getHabits() async {
    if (checkPref()) {
      print('SharedPreferences is null!');
      return null; // Error code
    }

    try {
      // Get & decode List<Habit>
      List<String> _ = prefs.getStringList('habits');
      List<Habit> _data = _ == null
          ? []
          : _.map(
              (String _) {
                return Habit.fromJson(json.decode(_));
              },
            ).toList();

      return _data ?? [];
    } catch (e) {
      print('Error while get habits $e');
      return null; // Error code
    }
  }

  Future<List<Task>> getTasks() async {
    if (checkPref()) {
      print('SharedPreferences is null!');
      return null; // Error code
    }

    try {
      // Get & decode List<Task>
      List<String> _ = prefs.getStringList('tasks');
      List<Task> _data = _ == null
          ? []
          : _
              .map(
                (String _) {
                  print(json.decode(_)["hasTime"]);
                  return Task.fromJson(json.decode(_));
                },
              )
              .toList()
              .cast<Task>();

      return _data;
    } catch (e) {
      print('Error while get tasks $e');
      return null; // Error code
    }
  }

  Future<Habit> getHabitById(String habitId) async {
    if (checkPref()) {
      print('SharedPreferences is null!');
      return null; // Error code
    }

    try {
      // Get Habits
      List<Habit> habits = await getHabits();
      if (habits == null) return null; // Error code

      // Search for habit
      Habit habit = habits.firstWhere((Habit val) => val.id == habitId);

      // Return habit
      return habit;
    } catch (e) {
      print('Error while get habit $e');
      return null; // Error code
    }
  }

  Future<List> getCommentsByHabitId(String habitId) async {
    if (checkPref()) {
      print('SharedPreferences is null!');
      return null; // Error code
    }

    try {
      // Get Habit
      Habit habit = await getHabitById(habitId);
      if (habit == null) return null; // Error code

      // Return comments
      return habit.comments;
    } catch (e) {
      print('Error while get habit by id $e');
      return null; // Error code
    }
  }

  Future saveComment(Comment comment) async {
    if (checkPref()) {
      print('SharedPreferences is null!');
      return null; // Error code
    }

    try {
      // Get Habit
      List<Habit> habits = await getHabits();
      if (habits == null) return null; // Error code

      habits
          .firstWhere((Habit habit) => habit.id == comment.habitId)
          .comments
          .add(comment);

      // Encode back from List<Habit> -> List<String>
      List<String> _listOfString = habits
          .map(
            (i) => jsonEncode(i.toJson()),
          )
          .toList();

      await prefs.setStringList('habits', _listOfString);

      // Return dbcode
      return true;
    } catch (e) {
      print('Error while save comment $e');
      return null; // Error code
    }
  }

  Future<User> getUser() async {
    if (checkPref()) {
      print('SharedPreferences is null!');
      return null; // Error code
    }

    try {
      // Get User decoded String
      String _ = prefs.getString('user');

      // check if string == null
      if (_ == null) {
        return null;
      }

      // Decode String -> User
      User user = User.fromJson(json.decode(_));

      // Return User / null
      return user ?? userNotFound;
    } catch (e) {
      print('Error while get user $e');
      return null;
    }
  }

  Future<bool> setUser(User _user) async {
    if (checkPref()) {
      print('SharedPreferences is null!');
      return false; // Error code
    }

    try {
      // Get User decoded String
      await prefs.setString('user', json.encode(_user.toJson()));

      // Return dbcode
      return true;
    } catch (e) {
      print('Error while get user $e');
      return false;
    }
  }

  Future<bool> updateHabit(Habit _habit) async {
    if (checkPref()) {
      print('SharedPreferences is null!');
      return null; // Error code
    }

    try {
      // Get Habit
      List<Habit> habits = await getHabits();
      if (habits == null) return false; // Error code

      // Seatch for habit
      int i = habits.indexWhere((Habit __habit) => __habit.id == _habit.id);

      if (i != null) {
        habits[i] = _habit;
      } else {
        print('Cant find habit with id ${_habit.id}(${_habit.title})');
        return false; //Error code
      }

      // Encode back from List<Habit> -> List<String>
      List<String> _listOfString = habits
          .map(
            (i) => jsonEncode(i.toJson()),
          )
          .toList();

      // Save
      await prefs.setStringList('habits', _listOfString);

      // Return dbcode
      return true;
    } catch (e) {
      print('Error while update habit $e');
      return false; // Error code
    }
  }

  Future<bool> updateTask(Task task) async {
    if (checkPref()) {
      print('SharedPreferences is null!');
      return null; // Error code
    }

    try {
      // Get Tasks
      List<Task> tasks = await getTasks();
      if (tasks == null) return false; // Error code

      // Seatch for Task
      int i = tasks.indexWhere((Task __task) => __task.id == task.id);

      if (i != null) {
        tasks[i] = task;
      } else {
        print('Cant find task with id ${task.id}(${task.title})');
        return false; //Error code
      }

      // Encode back from List<Habit> -> List<String>
      List<String> _listOfString = tasks
          .map(
            (i) => jsonEncode(i.toJson()),
          )
          .toList();

      // Save
      await prefs.setStringList('tasks', _listOfString);

      // Return dbcode
      return true;
    } catch (e) {
      print('Error while update task $e');
      return false; // Error code
    }
  }

  Future<bool> deleteTask(String taskId) async {
    if (checkPref()) {
      print('SharedPreferences is null!');
      return null; // Error code
    }

    try {
      // Get Tasks
      List<Task> tasks = await getTasks();
      if (tasks == null) return false; // Error code

      // Seatch for Task
      int i = tasks.indexWhere((Task __task) => __task.id == taskId);

      if (i != null) {
        tasks.removeAt(i);
      } else {
        print('Cant find task with id $taskId');
        return false; //Error code
      }

      // Encode back from List<Habit> -> List<String>
      List<String> _listOfString = tasks
          .map(
            (i) => jsonEncode(i.toJson()),
          )
          .toList();

      // Save
      await prefs.setStringList('tasks', _listOfString);

      // Return dbcode
      return true;
    } catch (e) {
      print('Error while delete task $e');
      return false; // Error code
    }
  }

  Future<Image> getProfileImg() async {
    if (checkPref()) {
      print('SharedPreferences is null!');
      return null; // Error code
    }

    try {
      // get image as String
      String _ = prefs.getString('profileImage');

      if (_ == null) return null; // Error code

      return Image.memory(
        base64Decode(_),
        fit: BoxFit.fill,
      );
    } catch (e) {
      print('Error while delete task $e');
      return null; // Error code
    }
  }

  Future<bool> saveProfileImg(File image) async {
    if (checkPref()) {
      print('SharedPreferences is null!');
      return null; // Error code
    }

    try {
      // get image as String
      String str = base64Encode(image.readAsBytesSync());

      await prefs.setString('profileImage', str);

      return true;
    } catch (e) {
      print('Error while delete task $e');
      return null; // Error code
    }
  }

  Future<bool> setupLatestNotifId(int value) async {
    if (checkPref()) {
      print('SharedPreferences is null!');
      return null; // Error code
    }

    try {
      await prefs.setInt('latest_id', value);

      return true;
    } catch (e) {
      print('Error while getting latest notification id $e');
      return false; // Error code
    }
  }

  Future<bool> changeLatestNotifId(int changeTo) async {
    if (checkPref()) {
      print('SharedPreferences is null!');
      return false; // Error code
    }

    try {
      // get latest
      int latest = await getLatestNotificationId();

      // increment / dicrement counter
      latest += changeTo;

      // save
      await prefs.setInt('latest_id', latest);

      return true;
    } catch (e) {
      print('Error while getting latest notification id $e');
      return false; // Error code
    }
  }

  Future<int> getLatestNotificationId() async {
    if (checkPref()) {
      print('SharedPreferences is null!');
      return null; // Error code
    }

    try {
      // get id & check
      int _ = prefs.getInt('latest_id');

      if (_ == null) return 0; // Error code

      return _;
    } catch (e) {
      print('Error while getting latest notification id $e');
      return null; // Error code
    }
  }

  Future<List<HabitNotification>> getAllNotification() async {
    if (checkPref()) {
      print('SharedPreferences is null!');
      return null; // Error code
    }

    try {
      // get notifications as List<String>
      List<String> _ = prefs.getStringList('notification');

      // check if storage data == null => return [] as no notifications;
      if (_ == null) return [];

      // decode List<String> -> List<HabitNotification>
      List<HabitNotification> notifs = _
          .map(
            (String str) => HabitNotification.fromJson(
              json.decode(str),
            ),
          )
          .toList()
          .cast<HabitNotification>();

      print('Notifs:  $notifs');

      return notifs;
    } catch (e) {
      print('Error while getting latest notification id $e');
      return null; // Error code
    }
  }

  Future<List<HabitNotification>> getAllHabitNotification(Habit habit) async {
    if (checkPref()) {
      print('SharedPreferences is null!');
      return null; // Error code
    }

    try {
      // get all notifications
      List<HabitNotification> _ = await getAllNotification();

      // check if storage notifications is []
      // => return null as no notifications
      if (_ == null) return null;

      // Look for a habit
      List<HabitNotification> notifs = [];
      _.forEach((HabitNotification elem) {
        if (elem.habitId == habit.id) notifs.add(elem);
      });

      return notifs;
    } catch (e) {
      print('Error while getting latest notification id $e');
      return null; // Error code
    }
  }

  Future<bool> createNotification(HabitNotification notification) async {
    if (checkPref()) {
      print('SharedPreferences is null!');
      return null; // Error code
    }

    try {
      // get all notifications
      List<HabitNotification> notifications = await getAllNotification();

      // add notification
      notifications.add(notification);

      // save all notifications
      prefs.setStringList(
        'notifications',
        notifications
            .map(
              (HabitNotification elem) => json.encode(
                elem.toJson(),
              ),
            )
            .toList()
            .cast<String>(),
      );

      return true; // return success
    } catch (e) {
      print('Error while create notification id $e');
      return null; // Error code
    }
  }

  Future<bool> removeNotification(HabitNotification notification) async {
    if (checkPref()) {
      print('SharedPreferences is null!');
      return null; // Error code
    }

    try {
      // get all notifications
      List<HabitNotification> notifications = await getAllNotification();

      // remove notification
      notifications.removeWhere(
        (HabitNotification elem) =>
            elem.notificationId == notification.notificationId,
      );

      // save all notifications
      prefs.setStringList(
        'notifications',
        notifications
            .map(
              (HabitNotification elem) => json.encode(
                elem.toJson(),
              ),
            )
            .toList()
            .cast<String>(),
      );

      return true; // return success
    } catch (e) {
      print('Error while remove notification id $e');
      return null; // Error code
    }
  }

  Future<bool> removeHabitNotification(Habit habit) async {
    if (checkPref()) {
      print('SharedPreferences is null!');
      return null; // Error code
    }

    try {
      // get all notifications
      List<HabitNotification> notifications = await getAllNotification();

      // remove all notifications
      notifications.removeWhere(
        (HabitNotification elem) => elem.habitId == habit.id,
      );

      // save all notifications
      prefs.setStringList(
        'notifications',
        notifications
            .map(
              (HabitNotification elem) => json.encode(
                elem.toJson(),
              ),
            )
            .toList()
            .cast<String>(),
      );

      return true; // return success
    } catch (e) {
      print('Error while remove notification id $e');
      return null; // Error code
    }
  }

  Future<bool> removeNotificationsByDate(DateTime date) async {
    if (checkPref()) {
      print('SharedPreferences is null!');
      return null; // Error code
    }

    try {
      // Formate date
      date = dateFormater.parse(date.toString());

      // get all notifications
      List<HabitNotification> notifications = await getAllNotification();

      // remove all notifications
      notifications.removeWhere(
        (HabitNotification elem) => elem.date == date,
      );

      // save all notifications
      prefs.setStringList(
        'notifications',
        notifications
            .map(
              (HabitNotification elem) => json.encode(
                elem.toJson(),
              ),
            )
            .toList()
            .cast<String>(),
      );

      return true; // return success
    } catch (e) {
      print('Error while remove notification id $e');
      return null; // Error code
    }
  }

  /// This function return Map<DateTime, int>, where
  ///  - DateTime is date, which notification is assigned to
  ///  - int is amount of notification, which assigned to this day
  Future<Map<DateTime, int>> getNotificationDates() async {
    if (checkPref()) {
      print('SharedPreferences is null!');
      return null; // Error code
    }

    try {
      // get data as String
      List<String> _ = prefs.getStringList('notifications_dates');

      // if data == null => return {}
      if (_ == null) return {};

      // decode String -> Map<DateTime, int>
      Map<DateTime, int> data = {};
      _.forEach((String elem) {
        Map<String, String> decoded = json.decode(elem).cast<String, String>();
        data[DateTime.parse(decoded['date'])] = int.parse(decoded['amount']);
      });

      return data; // return success
    } catch (e) {
      print('Error while get notifications dates notification id $e');
      return null; // Error code
    }
  }

  /// This function increment or dicrement date's amount
  /// [amount] - need to pass positive if you need to add,
  ///       and negative if you need to remove.
  Future<bool> changeNotificationsDates(DateTime date, int amount) async {
    if (checkPref()) {
      print('SharedPreferences is null!');
      return null; // Error code
    }

    try {
      // get data
      Map<DateTime, int> data = await getNotificationDates();

      // Check reliability of data
      if (data == null) return false; // Error code

      if (data[date] == null) {
        data[date] = amount;
      } else {
        // Change value
        data[date] += amount;
      }

      // Encode Map<DateTime, int> => List<String>
      List<String> encodedData = [];
      data.forEach((DateTime _data, int _amount) {
        Map<String, String> elem = {
          'date': _data.toString(),
          'amount': _amount.toString(),
        };
        encodedData.add(json.encode(elem));
      });

      // Save data
      prefs.setStringList(
        'notifications_dates',
        encodedData,
      );

      return true; // success code
    } catch (e) {
      print('Error while change notifications dates notification id $e');
      return null; // Error code
    }
  }

  Future<int> getNotificationAmountByDate(DateTime date) async {
    if (checkPref()) {
      print('SharedPreferences is null!');
      return null; // Error code
    }

    try {
      // Format passed date
      date = dateFormater.parse(date.toString());

      // get data
      Map<DateTime, int> data = await getNotificationDates();

      // Check reliability of data & function arguments
      if (data == {} || data == null) return null; // Error code
      if (!data.values.contains(date)) return 0; // Error code

      return data[date];
    } catch (e) {
      print('Error while change notifications dates notification id $e');
      return null; // Error code
    }
  }

  bool isDarkMode() {
    if (checkPref()) {
      print('SharedPreferences is null!');
      return null; // Error code
    }

    try {
      // get data as String
      bool data = prefs.getBool('isDarkMode');

      print('DB $data');

      return data == null ? false : data;
    } catch (e) {
      print('Error while get dark mode $e');
      return null; // Error code
    }
  }

  Future<bool> setDarkMode(bool value) async {
    if (checkPref()) {
      print('SharedPreferences is null!');
      return null; // Error code
    }

    try {
      // save
      await prefs.setBool('isDarkMode', value);

      return true; // Success code
    } catch (e) {
      print('Error while set dark mode $e');
      return null; // Error code
    }
  }
}
