import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:habits_plus/core/models/theme.dart';
import 'package:habits_plus/core/models/user.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

final DateFormat dateFormater = DateFormat('yyyy-MM-dd');
final TimeOfDay nullTime = TimeOfDay(hour: 3, minute: 59);

// UI
ThemeData lightMode = ThemeData(
  primaryColor: Color(0xFF9563FF),
  disabledColor: Color(0x42000000),
  backgroundColor: Color(0xFFf8f9fa),
  textSelectionColor: Color(0xFF565656),
  textSelectionHandleColor: Color(0xFF282828),
  accentColor: Color(0xFF6C3CD1),
  canvasColor: Colors.transparent,
);
ThemeData darkMode = ThemeData(
  brightness: Brightness.dark,
  primaryColor: Color(0xFF9563FF),
  disabledColor: Color(0x3DFFFFFF),
  backgroundColor: Color(0xFF161616),
  textSelectionColor: Colors.white70,
  textSelectionHandleColor: Colors.white,
  accentColor: Color(0xFF6C3CD1),
  canvasColor: Colors.transparent,
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
  MdiIcons.run,
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

final User userNotFound = User(
  email: '',
  name: 'User',
);
