import 'package:flutter/material.dart';
import 'package:habits_plus/core/models/statistic.dart';
import 'package:habits_plus/core/util/constant.dart';

class TopHabitsWidget extends StatefulWidget {
  List<TopHabitStat> stat;

  TopHabitsWidget(this.stat);

  @override
  _TopHabitsWidgetState createState() => _TopHabitsWidgetState();
}

class _TopHabitsWidgetState extends State<TopHabitsWidget> {
  Widget tile(int i) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: <Widget>[
          // icon
          Container(
            width: 45,
            height: 45,
            decoration: BoxDecoration(
              color: Theme.of(context).disabledColor.withOpacity(0.05),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              habitsIcons[widget.stat[i].origin.iconCode],
              color: Theme.of(context).primaryColor,
              size: 28,
            ),
          ),
          SizedBox(width: 10),

          // Title
          Text(
            widget.stat[i].origin.title,
            style: TextStyle(
              color: Theme.of(context).textSelectionHandleColor,
              fontSize: 16,
            ),
          ),

          // .. of ..
          Expanded(
            child: Align(
              alignment: Alignment.centerRight,
              child: Text(
                widget.stat[i].percent.toString() + '%',
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(widget.stat.length, (int i) => tile(i)),
      ),
    );
  }
}
