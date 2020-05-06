import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:habits_plus/core/enums/internet.dart';
import 'package:habits_plus/core/models/habit.dart';
import 'package:habits_plus/core/services/community.dart';
import 'package:habits_plus/core/services/database.dart';
import 'package:habits_plus/core/services/internet.dart';
import 'package:habits_plus/core/services/logs.dart';
import 'package:habits_plus/core/util/logger.dart';
import 'package:habits_plus/locator.dart';
import 'package:uuid/uuid.dart';

class FirebaseServices {
  // Components
  DatabaseServices _databaseServices = locator<DatabaseServices>();
  InternetServices _internetServices = locator<InternetServices>();
  LogServices _logServices = locator<LogServices>();
  Firestore _firestore = Firestore.instance;
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  // Auth
  String _userId;

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

      _logServices.addLog('Successfully report bug (FirebaseServices)');
      return true; // success code
    } catch (e) {
      logger.e('Error while report bug (FirebaseServices)', e);
      _logServices.addLog('Error while report bug (FirebaseServices) $e');
    }
  }

  /// Return true if success and false if save error happend
  Future<bool> updateHabit(Habit habit) async {
    try {
      // Check internet connection
      if (!(await _internetServices.hasInternetConnection())) {
        logger.i(
          "No internet connection. Can't update habit with id ${habit.id}",
        );
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
      logger.e('Error whiel update habit (firebase services) $e');
      return false; // Error code
    }
  }
}
