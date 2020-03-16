import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  String email;
  String name;
  String profileImg;

  User({
    this.email,
    this.name,
    this.profileImg,
  });

  factory User.fromDoc(DocumentSnapshot doc) {
    User user = User(
      email: doc['email'],
      name: doc['name'],
      profileImg: doc['profileImg'],
    );
    return user;
  }
}
