import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:habits_plus/core/util/constant.dart';
import 'package:habits_plus/core/viewmodels/detail_model.dart';

import '../../../localization.dart';

class DetailAppBar extends StatelessWidget implements PreferredSizeWidget {
  DetailPageView model;

  DetailAppBar(this.model);

  @override
  Size get preferredSize => Size.fromHeight(
      (model.habit.title.length / 22 + 0.5).round().toDouble() * 30 + 40);

  String _getDesc(BuildContext context) {
    String time = model.habit.hasReminder
        ? model.habit.timeOfDay.hour.toString() +
            ':' +
            '${model.habit.timeOfDay.minute.toString().length == 1 ? '0' + model.habit.timeOfDay.minute.toString() : model.habit.timeOfDay.minute.toString()}'
        : AppLocalizations.of(context).translate('todos_reminder');

    String days = '';
    Function eq = const ListEquality().equals;

    if (eq(
      model.habit.repeatDays,
      [true, true, true, true, true, true, true],
    )) {
      days = AppLocalizations.of(context).translate('createHabit_everyday');
    } else {
      List tmp = model.habit.repeatDays
          .asMap()
          .map(
            (int i, bool _val) => MapEntry(
                i,
                _val
                    ? AppLocalizations.of(context).translate(dayNames[i])[0]
                    : ''),
          )
          .values
          .toList();
      print(tmp);
      tmp.forEach((_val) => days += _val == '' ? '' : '$_val,');
    }
    int last = ((MediaQuery.of(context).size.width - 89) ~/ 7.5).toInt() -
        time.length -
        days.length;

    String desc = model.habit.description.length > last
        ? model.habit.description.substring(0, last) + '...'
        : model.habit.description;
    return '$desc $time, $days';
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        color: Theme.of(context).backgroundColor,
        child: Column(
          children: <Widget>[
            // Up Row
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  // Back & Text
                  Container(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        // Back Icon
                        Container(
                          padding: EdgeInsets.only(top: 10),
                          child: GestureDetector(
                            child: Icon(
                              Icons.chevron_left,
                              size: 24,
                            ),
                            onTap: () => Navigator.pop(context),
                          ),
                        ),

                        SizedBox(width: 10),

                        // Title & subtitle
                        Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              SizedBox(height: 10),
                              SizedBox(
                                width: MediaQuery.of(context).size.width - 106,
                                child: Hero(
                                  tag: '${model.habit.title}_title',
                                  child: Text(
                                    model.habit.title,
                                    softWrap: true,
                                    style: TextStyle(
                                      color: Theme.of(context).primaryColor,
                                      fontSize: 24,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                              Text(
                                _getDesc(context),
                                style: TextStyle(),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Edit
                  GestureDetector(
                    child: Container(
                      padding: EdgeInsets.all(10),
                      child: Icon(
                        Icons.edit,
                        color: Theme.of(context).disabledColor,
                      ),
                    ),
                    onTap: () => print('edit'),
                  ),
                ],
              ),
            ),

            // Underline
            SizedBox(height: 10),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 15),
              height: 1,
              color: Theme.of(context).textSelectionColor.withOpacity(0.5),
            ),
          ],
        ),
      ),
    );
  }
}
