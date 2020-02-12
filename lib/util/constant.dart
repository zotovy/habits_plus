import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';

final auth = FirebaseAuth.instance;
final GoogleSignIn googleSignIn = GoogleSignIn();
final FacebookLogin facebookSignIn = FacebookLogin();
final _firestore = Firestore.instance;
final storageRef = FirebaseStorage.instance.ref();
final userRef = _firestore.collection('users');
final List<Color> colors = [
  Colors.blue.withOpacity(0.85),
  Colors.lightBlue.withOpacity(0.85),
  Colors.green.withOpacity(0.85),
  Colors.indigo.withOpacity(0.85),
  Colors.orange.withOpacity(0.85),
  Colors.pink.withOpacity(0.85),
  Colors.purple.withOpacity(0.85),
  Colors.red.withOpacity(0.85),
];
