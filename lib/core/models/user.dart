import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class User {
  String email;
  String name;
  Image profileImg;

  User({
    this.email,
    this.name,
    this.profileImg,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'name': name,
    };
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      email: json['email'],
      name: json['name'],
    );
  }
}
