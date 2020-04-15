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

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'name': name,
      'profileImg': profileImg,
    };
  }

  User.fromJson(Map<String, dynamic> json) {
    User user = User(
      email: json['email'],
      name: json['name'],
      profileImg: json['profileImg'],
    );
  }
}
