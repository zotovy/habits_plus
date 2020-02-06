import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:habits_plus/models/user.dart';
import 'package:habits_plus/util/constant.dart';

class DatabaseServices {
  static isUsernameUsed(String username) async {
    QuerySnapshot users =
        await userRef.where('username', isEqualTo: username).getDocuments();
    return users.documents.length == 1;
  }

  static Future<bool> _isUserExists(String id) async {
    try {
      await userRef.document(id).get();
      return true;
    } catch (e) {
      print(
          'getUserError: trying get user with ID: $id,\n Time: ${DateTime.now()}');
      return false;
    }
  }

  static Future<dynamic> getUserById(String id) async {
    bool isExists = await _isUserExists(id);
    if (isExists) {
      DocumentSnapshot snap = await userRef.document(id).get();
      User user = User.fromDoc(snap);
      return user;
    }
    return false;
  }
}
