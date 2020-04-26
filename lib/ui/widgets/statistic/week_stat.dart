import 'package:flutter/material.dart';
import 'package:habits_plus/core/enums/habitType.dart';
import 'package:habits_plus/core/models/statistic.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class WeekStatWidget extends StatefulWidget {
  List<WeekStatHabit> stat;

  WeekStatWidget(this.stat);

  @override
  _WeekStatWidgetState createState() => _WeekStatWidgetState();
}

class _WeekStatWidgetState extends State<WeekStatWidget> {
  Widget _tile(int i) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(
        context,
        'habit_detail',
        arguments: widget.stat[i].origin,
      ),
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 2),
        child: Row(
          children: <Widget>[
            // Icon
            Container(
              child: CircularPercentIndicator(
                radius: 22.5,
                lineWidth: 4.0,
                percent: widget.stat[i].percent,
                progressColor: Theme.of(context).primaryColor,
                backgroundColor: Theme.of(context).disabledColor,
                animation: true,
                circularStrokeCap: CircularStrokeCap.round,
                animationDuration: 500,
              ),
            ),
            SizedBox(width: 5),

            // Title
            Text(
              widget.stat[i].title,
              style: TextStyle(
                fontSize: 16,
                color: Theme.of(context).textSelectionHandleColor,
              ),
            ),

            // 1 / 4
            Expanded(
              child: Align(
                alignment: Alignment.centerRight,
                child: Text(
                  widget.stat[i].doneProgress,
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(
          widget.stat.length,
          (int i) => _tile(i),
        ),
      ),
    );
  }
}
