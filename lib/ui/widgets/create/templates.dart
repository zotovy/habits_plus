import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:habits_plus/core/models/habit.dart';
import 'package:habits_plus/core/util/constant.dart';
import 'package:habits_plus/core/util/habit_templates.dart';
import 'package:habits_plus/localization.dart';

class HabitTemplateWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      // margin: EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // Template
          Text(
            AppLocalizations.of(context).translate('templates'),
            style: TextStyle(
              fontSize: 18,
              color: Theme.of(context).textSelectionColor.withOpacity(0.75),
              fontWeight: FontWeight.w600,
            ),
          ),

          Container(
            child: Column(
              children: AnimationConfiguration.toStaggeredList(
                duration: Duration(milliseconds: 300),
                delay: Duration(milliseconds: 75),
                childAnimationBuilder: (widget) {
                  return SlideAnimation(
                    horizontalOffset: 100.0,
                    child: FadeInAnimation(
                      child: widget,
                    ),
                  );
                },
                children: List.generate(
                  templates.length,
                  (int i) => TemplateTile(i),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class TemplateTile extends StatelessWidget {
  int i;
  Habit habit;
  TemplateTile(this.i) {
    habit = templates[i];
    icon = habitsIcons[habit.iconCode];
    title = habit.title;
  }

  String dayData(context) {
    if (ListEquality().equals(
      habit.repeatDays,
      [true, true, true, true, true, true, true],
    )) {
      return AppLocalizations.of(context).translate('createHabit_everyday');
    } else {
      String _dayData = '';
      for (var i = 0; i < 7; i++) {
        if (habit.repeatDays[i]) {
          _dayData +=
              AppLocalizations.of(context).translate(dayNames[i]) + ', ';
        }
      }
      // _dayData.join(', ');
      return _dayData.substring(0, _dayData.length - 2);
    }
  }

  // UI Elements
  IconData icon;
  String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 7),
      child: Row(
        children: <Widget>[
          // Icon
          Container(
            padding: EdgeInsets.all(7),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.circular(12.5),
            ),
            child: Icon(
              icon,
              color: Colors.white,
              size: 35,
            ),
          ),

          SizedBox(width: 10),

          // Title & days
          Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: Theme.of(context).textSelectionHandleColor,
                  ),
                ),
                Text(
                  dayData(context),
                  style: TextStyle(
                    fontSize: 14,
                    color: Theme.of(context).textSelectionColor,
                  ),
                ),
              ],
            ),
          ),

          // Go Icon
          Expanded(
            child: Align(
              alignment: Alignment.centerRight,
              child: Icon(
                Icons.chevron_right,
                color: Theme.of(context).textSelectionColor,
                size: 24,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
