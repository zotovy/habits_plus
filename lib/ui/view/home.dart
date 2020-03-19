import 'package:flutter/material.dart';
import 'package:habits_plus/core/services/auth.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
          child: RaisedButton(
        child: Text('logout'),
        onPressed: () => AuthService.logout(),
      )),
    );
  }
}
