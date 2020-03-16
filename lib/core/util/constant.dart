import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:habits_plus/core/models/theme.dart';
import 'package:intl/intl.dart';

// Firebase
final auth = FirebaseAuth.instance;
final GoogleSignIn googleSignIn = GoogleSignIn();
final FacebookLogin facebookSignIn = FacebookLogin();
final _firestore = Firestore.instance;
final storageRef = FirebaseStorage.instance.ref();
final userRef = _firestore.collection('users');
final habitsRef = _firestore.collection('habits');
final tasksRef = _firestore.collection('tasks');
final DateFormat dateFormater = DateFormat('yyyy-MM-dd');
final TimeOfDay nullTime = TimeOfDay(hour: 3, minute: 59);

// UI
ThemeModel lightMode = ThemeModel(
  ThemeData(
    primaryColor: Color(0xFF6C3CD1),
    disabledColor: Colors.black26,
    backgroundColor: Colors.white,
    textSelectionColor: Color(0xFF565656),
    textSelectionHandleColor: Color(0xFF282828),
    accentColor: Color(0xFF6C3CD1),
  ),
);
ThemeModel darkMode = ThemeModel(
  ThemeData(
    brightness: Brightness.dark,
    primaryColor: Color(0xFF6C3CD1),
    disabledColor: Colors.white12,
    backgroundColor: Color(0xFF161616),
    textSelectionColor: Colors.white70,
    textSelectionHandleColor: Colors.white,
    accentColor: Color(0xFF6C3CD1),
  ),
);
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
