import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:habits_plus/models/habit.dart';
import 'package:habits_plus/models/task.dart';
import 'package:habits_plus/models/user.dart';
import 'package:habits_plus/util/constant.dart';
import 'package:uuid/uuid.dart';

class DatabaseServices {
  static Future<bool> isUserExists(String id) async {
    try {
      final user = await userRef.document(id).get();
      print(user.data);
      if (user.data != null) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print(
          'getUserError: trying get user with ID: $id,\n Time: ${DateTime.now()}');
      return false;
    }
  }

  static Future<dynamic> getUserById(String id) async {
    bool isExists = await isUserExists(id);
    if (isExists) {
      DocumentSnapshot snap = await userRef.document(id).get();
      User user = User.fromDoc(snap);
      return user;
    }
    return false;
  }

  // Pass new habit to Firebase
  static Future<bool> createHabit(
      Habit habit, String userId, String timeOfDay) async {
    bool isExists = await isUserExists(userId);
    print(userId);
    if (isExists) {
      // generate document ID
      String docId = Uuid().v4();

      // rewrite List<bool> -> binary String '1110001'
      String days = '';
      for (var i = 0; i < habit.repeatDays.length; i++) {
        if (habit.repeatDays[i])
          days += '1';
        else
          days += '0';
      }

      // Write document into DB
      habitsRef.document(userId).collection('habits').document(docId).setData(
        {
          'colorCode': habit.colorCode,
          'description': habit.description,
          'disable': false,
          'hasReminder': habit.hasReminder,
          'repeatDays': days,
          'timeStamp': Timestamp.now(),
          'timeToRemind': timeOfDay,
          'timesADay': habit.timesADay,
          'title': habit.title,
          'type': habit.type,
          'progressBin': [],
          'progressBinByDate': {},
          'progressDateTimeById': [],
        },
      );

      return true;
    }
    return false;
  }

  // Create new habit and pass it to Firebase
  static Future<bool> createTask(
      Task task, String userId, String timeOfDay) async {
    // Check user id
    bool isExists = await isUserExists(userId);
    if (isExists) {
      // generate document ID
      String docId = Uuid().v4();

      // Write document into DB
      tasksRef.document(userId).collection('tasks').document(docId).setData(
        {
          'title': task.title,
          'description': task.description,
          'time': task.time,
          'date': task.date,
          'timeStamp': task.timestamp,
        },
      );

      return true;
    }
    return false;
  }

  static Future<List<Habit>> getAllHabitsById(String id) async {
    QuerySnapshot snap =
        await habitsRef.document(id).collection('habits').getDocuments();
    List<Habit> habits = snap.documents
        .map((DocumentSnapshot doc) => Habit.fromDoc(doc))
        .toList();
    return habits;
  }

  static Future updateHabit(Habit habit, String userId) {
    // rewrite List<bool> -> binary String '1110001'
    String days = '';
    for (var i = 0; i < habit.repeatDays.length; i++) {
      if (habit.repeatDays[i])
        days += '1';
      else
        days += '0';
    }

    // Update data in firebase
    habitsRef
        .document(userId)
        .collection('habits')
        .document(habit.id)
        .updateData(
      {
        'colorCode': habit.colorCode,
        'description': habit.description,
        'disable': habit.isDisable,
        'hasReminder': habit.hasReminder,
        'repeatDays': days,
        'timeStamp': habit.timeStamp,
        'timeToRemind': habit.timeOfDay,
        'timesADay': habit.timesADay,
        'title': habit.title,
        'type': habit.type,
        'progressBin': habit.progressBin,
        'progressBinByDate': habit.progressBinByDate,
        'progressDateTimeById': habit.progressDateTimeById,
      },
    );
  }
}
