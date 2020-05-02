import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseServices {
  Firestore _firestore = Firestore.instance;

  Future<bool> isUserExist(String id) async {
    try {
      DocumentSnapshot snapshot =
          await _firestore.collection('users').document(id).get();

      print(' hello ${snapshot.data}');
      return snapshot.data != null;
    } catch (e) {
      return false;
    }
  }
}
