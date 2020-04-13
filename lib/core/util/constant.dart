import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:habits_plus/core/models/theme.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

// Firebase
final auth = FirebaseAuth.instance;
final GoogleSignIn googleSignIn = GoogleSignIn();
final FacebookLogin facebookSignIn = FacebookLogin();
final _firestore = Firestore.instance;
final storageRef = FirebaseStorage.instance.ref();
final userRef = _firestore.collection('users');
final habitsRef = _firestore.collection('habits');
final tasksRef = _firestore.collection('tasks');
final commentsRef = _firestore.collection('comments');
final DateFormat dateFormater = DateFormat('yyyy-MM-dd');
final TimeOfDay nullTime = TimeOfDay(hour: 3, minute: 59);

// UI
ThemeModel lightMode = ThemeModel(
  ThemeData(
    primaryColor: Color(0xFF6C3CD1),
    disabledColor: Colors.black26,
    backgroundColor: Color(0xFFf8f9fa),
    textSelectionColor: Color(0xFF565656),
    textSelectionHandleColor: Color(0xFF282828),
    accentColor: Color(0xFF6C3CD1),
    canvasColor: Colors.transparent,
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
    canvasColor: Colors.transparent,
  ),
);

// Habits icons
List<IconData> habitsIcons = [
  EvaIcons.star,
  MdiIcons.water,
  MdiIcons.foodApple,
  MdiIcons.tree,
  MdiIcons.car,
  MdiIcons.scaleBathroom,
  MdiIcons.heart,
  MdiIcons.basketball,
  MdiIcons.alarm,
  MdiIcons.post,
  MdiIcons.instagram,
  MdiIcons.phone,
  MdiIcons.walk,
  MdiIcons.dog,
  MdiIcons.emoticonExcited,
];

// Short name of each day of the week
const List<String> dayNames = [
  'Mon',
  'Tue',
  'Wed',
  'Thr',
  'Fri',
  'Sat',
  'Sun',
];

const List<String> monthNames = [
  'January',
  'February',
  'March',
  'April',
  'May',
  'June',
  'July',
  'August',
  'September',
  'October',
  'November',
  'December',
];
final habitDurationMarkDate = DateTime.utc(2005, 11, 21);
final drawerController = ZoomDrawerController();
