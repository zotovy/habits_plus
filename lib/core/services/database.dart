import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:habits_plus/core/enums/habitType.dart';
import 'package:habits_plus/core/models/comment.dart';
import 'package:habits_plus/core/models/habit.dart';
import 'package:habits_plus/core/models/task.dart';
import 'package:habits_plus/core/models/user.dart';
import 'package:habits_plus/core/util/constant.dart';
import 'package:uuid/uuid.dart';

class DatabaseServices {
  static Future<bool> isUserExists(String id) async {
    try {
      final user = await userRef.document(id).get();
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

  Future<dynamic> getUserById(String id) async {
    bool isExists = await isUserExists(id);
    if (isExists) {
      DocumentSnapshot snap = await userRef.document(id).get();
      User user = User.fromDoc(snap);
      return user;
    }
    return false;
  }

  // Pass new habit to Firebase
  Future<bool> createHabit(
    Habit habit,
    String userId,
  ) async {
    bool isExists = await isUserExists(userId);
    DateTime now = DateTime.now();
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
          'goalAmount': habit.goalAmount,
          'description': habit.description,
          'disable': false,
          'hasReminder': habit.hasReminder,
          'repeatDays': days,
          'timeStamp': Timestamp.now(),
          'timeToRemind': habit.timeOfDay != null
              ? DateTime(
                  now.year,
                  now.month,
                  now.day,
                  habit.timeOfDay.hour,
                  habit.timeOfDay.minute,
                )
              : null,
          'timesADay': habit.timesADay,
          'title': habit.title,
          'type': habit.type == HabitType.Countable ? 1 : 0,
          'progressBin': <DateTime>[],
          'iconCode': habit.iconCode,
          'duration': habit.duration,
        },
      );

      return true;
    }
    return false;
  }

  // Create new habit and pass it to Firebase
  Future<bool> createTask(Task task, String userId) async {
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
          'isEveryDay': task.isEveryDay,
          'hasTime': task.hasTime,
          'done': task.done,
        },
      );

      return true;
    }
    return false;
  }

  Future<bool> createComment(Comment comment, String userId) async {
    // Check userId
    bool isUserExist = await isUserExists(userId);

    if (isUserExist && comment.habitId != null) {
      // generate document ID
      String docId = Uuid().v4();

      // Write doc into DB
      await commentsRef
          .document(userId)
          .collection('comments')
          .document(comment.habitId)
          .collection('comments')
          .document(docId)
          .setData(
        {
          'authorId': comment.authorId,
          'habitId': comment.habitId,
          'hasImage': comment.hasImage,
          'imageUrl': comment.imageUrl,
          'content': comment.content,
          'timestamp': comment.timestamp,
        },
      );

      return true;
    }

    return false;
  }

  Future<List<Habit>> getAllHabitsById(String id) async {
    QuerySnapshot snap =
        await habitsRef.document(id).collection('habits').getDocuments();
    List<Habit> habits = snap.documents
        .map((DocumentSnapshot doc) => Habit.fromDoc(doc))
        .toList();
    return habits;
  }

  Future<List<Task>> getAllTasksById(String id) async {
    QuerySnapshot snap =
        await tasksRef.document(id).collection('tasks').getDocuments();
    List<Task> tasks = snap.documents
        .map((DocumentSnapshot doc) => Task.fromDoc(doc))
        .toList();
    return tasks;
  }

  Future<List<Comment>> getCommentsByHabitId(
      String userId, String habitId) async {
    QuerySnapshot snap = await commentsRef
        .document(userId)
        .collection('comments')
        .document(habitId)
        .collection('comments')
        .getDocuments();
    List<Comment> _comments = snap.documents
        .map(
          (DocumentSnapshot doc) => Comment.fromJson(doc),
        )
        .toList();
    return _comments;
  }

  Future updateHabit(Habit habit, String userId) async {
    // rewrite List<bool> -> binary String '1110001'
    String days = '';
    for (var i = 0; i < habit.repeatDays.length; i++) {
      if (habit.repeatDays[i])
        days += '1';
      else
        days += '0';
    }
    DateTime now = DateTime.now();

    // Update data in firebase
    await habitsRef
        .document(userId)
        .collection('habits')
        .document(habit.id)
        .updateData(
      {
        'goalAmount': habit.goalAmount,
        'description': habit.description,
        'disable': false,
        'hasReminder': habit.hasReminder,
        'repeatDays': days,
        'timeStamp': Timestamp.fromDate(habit.timeStamp),
        'timeToRemind': DateTime(
          now.year,
          now.month,
          now.day,
          habit.timeOfDay.hour,
          habit.timeOfDay.minute,
        ),
        'timesADay': habit.timesADay,
        'title': habit.title,
        'type': habit.type == HabitType.Countable ? 1 : 0,
        'progressBin': habit.progressBin,
        'iconCode': habit.iconCode,
        'duration': habit.duration,
        'countableProgress': habit.countableProgress,
      },
    );
  }

  void updateTask(Task task, String userId) {
    // Update data in firebase
    tasksRef.document(userId).collection('tasks').document(task.id).updateData(
      {
        'title': task.title,
        'description': task.description,
        'time': task.time,
        'date': task.date,
        'timeStamp': task.timestamp,
        'isEveryDay': task.isEveryDay,
        'hasTime': task.hasTime,
        'done': task.done,
      },
    );
  }

  void updateComment(Comment comment) {
    // Update data in firebase
    commentsRef
        .document(comment.authorId)
        .collection('comments')
        .document(comment.authorId)
        .collection('comments')
        .document(comment.id)
        .setData(
      {
        'authorId': comment.authorId,
        'habitId': comment.habitId,
        'hasImage': comment.hasImage,
        'imageUrl': comment.imageUrl,
        'content': comment.content,
        'timestamp': comment.timestamp,
      },
    );
  }

  Future<bool> deleteTask(String taskId, String userId) async {
    if (await isUserExists(userId)) {
      // Delete firebase
      await tasksRef
          .document(userId)
          .collection('tasks')
          .document(taskId)
          .delete();
      return true;
    } else {
      return false;
    }
  }
}
