import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:habits_plus/models/user.dart';
import 'package:habits_plus/util/constant.dart';

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
}
