import 'dart:io';

import 'package:flutter/material.dart';

class User {
  String email;
  String name;
  String profileImgBase64String;

  User({
    this.email,
    this.name,
    this.profileImgBase64String,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'name': name,
      'profileImgBase64String': profileImgBase64String,
    };
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      email: json['email'],
      name: json['name'],
      profileImgBase64String: json['profileImgBase64String'],
    );
  }
}
