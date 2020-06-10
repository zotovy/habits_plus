import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:habits_plus/core/enums/internet.dart';
import 'package:habits_plus/core/enums/sync_type.dart';
import 'package:habits_plus/core/models/app_settings.dart';
import 'package:habits_plus/core/models/comment.dart';
import 'package:habits_plus/core/models/habit.dart';
import 'package:habits_plus/core/models/sync.dart';
import 'package:habits_plus/core/models/task.dart';
import 'package:habits_plus/core/models/user.dart';
import 'package:habits_plus/core/services/community.dart';
import 'package:habits_plus/core/services/database.dart';
import 'package:habits_plus/core/services/internet.dart';
import 'package:habits_plus/core/services/logs.dart';
import 'package:habits_plus/locator.dart';
import 'package:uuid/uuid.dart';

class FirebaseServices {
  // Components
  DatabaseServices _databaseServices = locator<DatabaseServices>();
  InternetServices _internetServices = locator<InternetServices>();
  LogServices _logServices = LogServices();
  Firestore _firestore = Firestore.instance;
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  // Need to sync
  List<SyncModel> needToSync = [];

  // Auth
  String _userId;

  // ---------------------------------------------------------------------------
  // ANCHOR: Setup

  /// This function get user's data from server --> Push all unsync data to
  /// server --> Get all data from server
  /// Exit if there is no internet connection
  Future setupApp() async {
    String uid = await userId;

    if (uid = null) return null; // User is not sync

    // Check internet connection & exit if there is no
    if (!await _internetServices.hasInternetConnection()) return null;

    // Get data from server

    List<Habit> _habits = (await _firestore
            .collection('users')
            .document(uid)
            .collection('habits')
            .getDocuments())
        .documents
        .map((DocumentSnapshot doc) => Habit.fromDocument(doc))
        .toList()
        .cast<Habit>();

    List<Task> _tasks = (await _firestore
            .collection('users')
            .document(uid)
            .collection('tasks')
            .getDocuments())
        .documents
        .map((DocumentSnapshot doc) => Task.fromDocument(doc))
        .toList()
        .cast<Task>();

    User _user = User.fromDocument(
      await _firestore.collection('users').document(uid).get(),
    );

    // Get unsaved data from local storage
    List<SyncModel> needToSyncList = _databaseServices.getNeedToSync();

    // todo: test
    // Update apply the unsaved changes
    for (var i = 0; i < needToSyncList.length; i++) {
      SyncModel elem = needToSyncList[i];

      switch (elem.type) {
        case SyncType.CreateHabit:
          _habits.add(elem.data['habit']);
          _databaseServices.deleteNeedToSync(i);
          createHabit(elem.data['habit']);
          break;
        case SyncType.UpdateHabit:
          _habits.removeWhere((e) => e.id == elem.data['habit'].id);
          _habits.add(elem.data['habit']);
          _databaseServices.deleteNeedToSync(i);
          updateHabit(elem.data['habit']);
          break;
        case SyncType.DeleteHabit:
          _habits.removeWhere((e) => e.id == elem.data['habit'].id);
          _databaseServices.deleteNeedToSync(i);
          deleteHabit(elem.data['habit']);
          break;
        case SyncType.CreateTask:
          _tasks.add(elem.data['task']);
          _databaseServices.deleteNeedToSync(i);
          createTask(elem.data['task']);
          break;
        case SyncType.UpdateTask:
          _tasks.removeWhere((e) => e.id == elem.data['task'].id);
          _tasks.add(elem.data['task']);
          _databaseServices.deleteNeedToSync(i);
          updateTask(elem.data['task']);
          break;
        case SyncType.DeleteTask:
          _tasks.removeWhere((e) => e.id == elem.data['task'].id);
          _databaseServices.deleteNeedToSync(i);
          deleteTask(elem.data['task']);
          break;
        case SyncType.CreateComment:
          _habits
              .firstWhere((e) => e.id == elem.data['comment'].habitId)
              .comments
              .add(elem.data['comment']);
          _databaseServices.deleteNeedToSync(i);
          createComment(elem.data['comment']);
          break;
        case SyncType.UpdateComment:
          int habitIndex = _habits.indexWhere(
            (e) => e.id == elem.data['comment'].habitId,
          );
          _habits[habitIndex]
              .comments
              .removeWhere((e) => e.id == elem.data['comment'].id);
          _habits[habitIndex].comments.add(elem.data['comment']);
          _databaseServices.deleteNeedToSync(i);
          updateComment(elem.data['comment']);
          break;
        case SyncType.DeleteComment:
          _habits
              .firstWhere(
                (e) => e.id == elem.data['comment'].habitId,
              )
              .comments
              .removeWhere((e) => e.id == elem.data['comment'].id);
          _databaseServices.deleteNeedToSync(i);
          deleteComment(elem.data['comment']);
          break;
        case SyncType.UpdateUser:
          _user = elem.data['user'];
          _databaseServices.deleteNeedToSync(i);
          setUser(elem.data['user']);
          break;
      }
    }

    // // Set new data
    // locator<StatisticViewModel>().habits = _habits;
    // locator<HomeViewModel>().habits = _habits;
    // locator<HomeViewModel>().tasks = _tasks;
    // locator<SettingsViewModel>().user = _user;
  }

  // ---------------------------------------------------------------------------
  // ANCHOR: get
  // Get
  Future<String> get userId async {
    if (_databaseServices.isSync()) {
      if (_userId == null) {
        _userId = (await getCurrentUser()).uid;
      }
      return _userId;
    } else {
      return null;
    }
  }

  /// Return current signIn Firebase user of null if there is none
  Future<FirebaseUser> getCurrentUser() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    return user;
  }

  /// Return true if firebase storage has user with given id
  /// and false is there is noen
  Future<bool> isUserExist(String id) async {
    try {
      DocumentSnapshot snapshot =
          await _firestore.collection('users').document(id).get();

      return snapshot.data != null;
    } catch (e) {
      return false;
    }
  }

  Future<User> getUserByEmail(String email) async {
    try {
      QuerySnapshot raw = await _firestore
          .collection("users")
          .where("email", isEqualTo: email)
          .getDocuments();

      if (raw.documents.length == 0) return null;

      User user = User.fromDocument(raw.documents[0]);

      return user;
    } catch (e) {
      _logServices.addError("Error while get user by email (email=$email)", e);
      return null;
    }
  }

  // ---------------------------------------------------------------------------
  // ANCHOR: Community

  /// This function set logs to firebase
  /// Return true if success and false if save error happend
  Future<bool> reportBug(BugModel model) async {
    try {
      // generate unique ID
      String id = Uuid().v4();

      // set data
      await _firestore
          .collection('bug_report')
          .document(id)
          .setData(model.toDocument());

      _logServices.addLog('report bug with id="$id" (FirebaseServices)');
      return true; // success code
    } catch (e) {
      _logServices.addError('Error while report bug (FirebaseServices)', e);
      return false;
    }
  }

  /// This function set message to firebase
  /// Return true if success and false if save error happend
  Future<bool> sendMessage(MessageModel model) async {
    try {
      // generate unique ID
      String id = Uuid().v4();

      // set data
      await _firestore
          .collection('messages')
          .document(id)
          .setData(model.toDocument());

      _logServices.addLog('send message with id="$id" (FirebaseServices)');
      return true; // success code
    } catch (e) {
      _logServices.addError('Error while send message (FirebaseServices)', e);
      return false;
    }
  }

  // ---------------------------------------------------------------------------
  //ANCHOR: Habits

  Future<List<Habit>> getHabits() async {
    // Check internet connection
    if (!(await _internetServices.hasInternetConnection())) {
      _logServices.addLog(
        "No internet connection. Can't get habits",
      );

      return null; // Exit
    }

    try {
      List<Habit> habits = (await _firestore
              .collection('users')
              .document(await userId)
              .collection('habits')
              .getDocuments())
          .documents
          .map(
            (doc) => Habit.fromDocument(doc),
          )
          .toList()
          .cast<Habit>();

      return habits;
    } catch (e) {
      _logServices.addError('Error while get habits', e);
      return null; // Error code
    }
  }

  Future<Habit> getHabit(String habitId) async {
    if (!(await _internetServices.hasInternetConnection())) {
      _logServices.addLog(
        "No internet connection. Can't get habits",
      );

      return null; // Exit
    }

    try {
      DocumentSnapshot raw = await _firestore
          .collection('users')
          .document(await userId)
          .collection('habits')
          .document(habitId)
          .get();

      Habit habit = Habit.fromDocument(raw);

      return habit;
    } catch (e) {
      _logServices.addError('Error while get habits', e);
      return null; // Error code
    }
  }

  /// Return true if success and false if save error happend
  Future<bool> createHabit(Habit habit) async {
    // Check internet connection
    if (!(await _internetServices.hasInternetConnection())) {
      // logging
      _logServices.addLog(
        "No internet connection. Can't create habit with id ${habit.id}",
      );

      SyncModel model = SyncModel(
        type: SyncType.CreateHabit,
        data: {
          'habit': habit,
        },
      );

      // add task to sync
      needToSync.add(model);

      _databaseServices.setNeedToSync(model);

      return true; // Exit
    }

    // Create habit
    try {
      // set data
      await _firestore
          .collection('users')
          .document(await userId)
          .collection('habits')
          .document(habit.id)
          .setData(habit.toDocument());

      _logServices.addLog(
        'Create habit with id ${habit.id} and userId ${await userId}',
      );

      // return success
      return true;
    } catch (e) {
      _logServices.addError("Error while create habit", e);
      return false; // Error code
    }
  }

  /// Return true if success and false if save error happend
  Future<bool> updateHabit(Habit habit) async {
    try {
      // Check internet connection
      if (!(await _internetServices.hasInternetConnection())) {
        _logServices.addLog(
          "No internet connection. Can't update habit with id ${habit.id}",
        );

        SyncModel model = SyncModel(
          type: SyncType.UpdateHabit,
          data: {
            'habit': habit,
          },
        );

        // add task to sync
        needToSync.add(model);

        _databaseServices.setNeedToSync(model);

        return true; // Exit
      }

      // push
      await _firestore
          .collection('users')
          .document(await userId)
          .collection('habits')
          .document(habit.id)
          .updateData(habit.toDocument());

      return true; // cuccess code
    } catch (e) {
      _logServices.addError('Error while update habit (firebase services)', e);
      return false; // Error code
    }
  }

  /// Return true if success and false if save error happend
  Future<bool> deleteHabit(Habit habit) async {
    // Check internet connection
    if (!(await _internetServices.hasInternetConnection())) {
      _logServices.addLog(
        "No internet connection. Can't delete habit with id ${habit.id}",
      );

      SyncModel model = SyncModel(
        type: SyncType.DeleteHabit,
        data: {
          'habit': habit,
        },
      );

      // add task to sync
      needToSync.add(model);

      _databaseServices.setNeedToSync(model);

      return true; // Exit
    }

    try {
      await _firestore
          .collection('users')
          .document(await userId)
          .collection('habits')
          .document(habit.id)
          .delete();

      return true; // Exit
    } catch (e) {
      _logServices.addError('Error while delete habit (firebase services)', e);
      return false; // Error code
    }
  }

  // ANCHOR: Tasks
  // ---------------------------------------------------------------------------

  Future<List<Task>> getTasks() async {
    // Check internet connection
    if (!(await _internetServices.hasInternetConnection())) {
      _logServices.addLog(
        "No internet connection. Can't get tasks",
      );

      return null; // Exit
    }

    try {
      List<Task> tasks = (await _firestore
              .collection('users')
              .document(await userId)
              .collection('tasks')
              .getDocuments())
          .documents
          .map(
            (doc) => Task.fromDocument(doc),
          )
          .toList()
          .cast<Task>();

      return tasks;
    } catch (e) {
      _logServices.addError('Error while get tasks', e);
      return null; // Error code
    }
  }

  /// Return true if success and false if save error happend
  Future<bool> createTask(Task task) async {
    // Check internet connection
    if (!(await _internetServices.hasInternetConnection())) {
      _logServices.addLog(
        "No internet connection. Can't create task with id ${task.id}",
      );

      SyncModel model = SyncModel(
        type: SyncType.CreateTask,
        data: {
          'task': task,
        },
      );

      // add task to sync
      needToSync.add(model);

      return true; // Exit
    }

    try {
      await _firestore
          .collection('users')
          .document(await userId)
          .collection('tasks')
          .document(task.id)
          .setData(task.toDocument());

      return true; // success code
    } catch (e) {
      _logServices.addError('Error while create task (firebase services)', e);
      return false; // Error code
    }
  }

  /// Return true if success and false if save error happend
  Future<bool> updateTask(Task task) async {
    // Check internet connection
    if (!(await _internetServices.hasInternetConnection())) {
      _logServices.addLog(
        "No internet connection. Can't update task with id ${task.id}",
      );

      SyncModel model = SyncModel(
        type: SyncType.UpdateTask,
        data: {
          'task': task,
        },
      );

      // add task to sync
      needToSync.add(model);

      _databaseServices.setNeedToSync(model);

      return true; // Exit
    }

    try {
      await _firestore
          .collection('users')
          .document(await userId)
          .collection('tasks')
          .document(task.id)
          .setData(task.toDocument());

      return true; // success code
    } catch (e) {
      _logServices.addError('Error while update task (firebase services)', e);
      return false; // Error code
    }
  }

  /// Return true if success and false if save error happend
  Future<bool> deleteTask(Task task) async {
    // Check internet connection
    if (!(await _internetServices.hasInternetConnection())) {
      _logServices.addLog(
        "No internet connection. Can't delete task with id ${task.id}",
      );

      SyncModel model = SyncModel(
        type: SyncType.DeleteTask,
        data: {
          'task': task,
        },
      );

      // add task to sync
      needToSync.add(model);

      _databaseServices.setNeedToSync(model);

      return true; // Exit
    }

    try {
      await _firestore
          .collection('users')
          .document(await userId)
          .collection('tasks')
          .document(task.id)
          .delete();

      return true; // success code
    } catch (e) {
      _logServices.addError('Error while delete task (firebase services)', e);
      return false; // Error code
    }
  }

  // ANCHOR: get comments
  // ---------------------------------------------------------------------------
  Future<List<Comment>> getComments(String habitId) async {
    if (!(await _internetServices.hasInternetConnection())) {
      return null;
    }

    try {
      Habit habit = await getHabit(habitId);

      if (habit == null) return null;

      return habit.comments;
    } catch (e) {
      _logServices.addError('Error while get comments (FirebaseServices)', e);
      return null;
    }
  }

  // ANCHOR: create comment
  // ---------------------------------------------------------------------------

  Future<bool> createComment(Comment comment) async {
    // Check internet connection
    if (!(await _internetServices.hasInternetConnection())) {
      _logServices.addLog(
        "No internet connection. Can't create comment with id ${comment.id}",
      );

      SyncModel model = SyncModel(
        type: SyncType.CreateComment,
        data: {
          'comment': comment,
        },
      );

      // add coment to sync
      needToSync.add(model);

      _databaseServices.setNeedToSync(model);

      return true; // Exit
    }

    try {
      print('try to save comment');

      List<Comment> comments = await getComments(comment.habitId);

      if (comments == null) return false;

      comments.add(comment);

      await _firestore
          .collection('users')
          .document(await userId)
          .collection('habits')
          .document(comment.habitId)
          .updateData({"comments": comments.map((e) => e.toJson()).toList()});

      print('successfully save comment');

      return true; // success code
    } catch (e) {
      _logServices.addError('Error while create comment (FirebaseServices)', e);
      return false;
    }
  }

  Future<bool> updateComment(Comment comment) async {
    // Check internet connection
    if (!(await _internetServices.hasInternetConnection())) {
      _logServices.addLog(
        "No internet connection. Can't update comment with id ${comment.id}",
      );

      SyncModel model = SyncModel(
        type: SyncType.UpdateComment,
        data: {
          'comment': comment,
        },
      );

      // add coment to sync
      needToSync.add(model);

      _databaseServices.setNeedToSync(model);

      return true; // Exit
    }

    try {
      await _firestore
          .collection('users')
          .document(await userId)
          .collection('habits')
          .document(comment.habitId)
          .updateData(comment.toDocument());

      return true; // success code
    } catch (e) {
      _logServices.addError('Error while update comment (FirebaseServices)', e);
      return false;
    }
  }

  Future<bool> deleteComment(Comment comment) async {
    // Check internet connection
    if (!(await _internetServices.hasInternetConnection())) {
      _logServices.addLog(
        "No internet connection. Can't delete comment with id ${comment.id}",
      );

      SyncModel model = SyncModel(
        type: SyncType.DeleteComment,
        data: {
          'comment': comment,
        },
      );

      // add coment to sync
      needToSync.add(model);

      _databaseServices.setNeedToSync(model);

      return true; // Exit
    }

    try {
      await _firestore
          .collection('users')
          .document(await userId)
          .collection('habits')
          .document(comment.habitId)
          .delete();

      return true; // success code
    } catch (e) {
      _logServices.addError('Error while delete comment (FirebaseServices)', e);
      return false;
    }
  }

  // ANCHOR: App settings
  // ---------------------------------------------------------------------------
  Future<AppSettings> getAppSettings() async {
    // Check internet connection
    if (!(await _internetServices.hasInternetConnection())) {
      _logServices.addLog(
        "No internet connection. Can't get app settings",
      );

      return null; // Exit
    }

    try {
      AppSettings settings = AppSettings.fromDocument(
        await _firestore.collection('users').document(await userId).get(),
      );

      return settings;
    } catch (e) {
      _logServices.addError('Error while get app settings', e);
      return null; // Error code
    }
  }

  // ANCHOR: user
  // ---------------------------------------------------------------------------
  Future<User> getUser() async {
    if (!(await _internetServices.hasInternetConnection())) {
      _logServices.addLog(
        "No internet connection. Can't get user info",
      );

      return null; // Exit
    }

    try {
      User user = User.fromDocument(
        await _firestore.collection('users').document(await userId).get(),
      );

      return user;
    } catch (e) {
      _logServices.addError("Error while get user", e);
      return null; // Error code
    }
  }

  Future<bool> setUser(User user) async {
    // Check internet connection
    if (!(await _internetServices.hasInternetConnection())) {
      _logServices.addLog(
        "No internet connection. Can't set user",
      );

      SyncModel model = SyncModel(
        type: SyncType.UpdateUser,
        data: {
          'user': user,
        },
      );

      // add coment to sync
      needToSync.add(model);

      _databaseServices.setNeedToSync(model);

      return true; // Exit
    }

    try {
      await _firestore.collection('users').document(await userId).updateData(
            user.toDocument(),
          );

      return true;
    } catch (e) {
      _logServices.addError('Error while set User', e);
      return false;
    }
  }
}
