import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:habits_plus/core/util/constant.dart';
import 'package:habits_plus/ui/view/drawer.dart';

class StatisticPage extends StatefulWidget {
  @override
  _StatisticPageState createState() => _StatisticPageState();
}

class _StatisticPageState extends State<StatisticPage> {
  @override
  Widget build(BuildContext context) {
    return ZoomDrawer(
      controller: drawerController,
      showShadow: true,
      borderRadius: 24.0,
      angle: 0,
      menuScreen: CustomDrawer(),
      mainScreen: SafeArea(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          color: Theme.of(context).backgroundColor,
          child: IconButton(
            icon: Icon(Icons.menu),
            onPressed: () => drawerController.toggle(),
          ),
        ),
      ),
    );
  }
}
