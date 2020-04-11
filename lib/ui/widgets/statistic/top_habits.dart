import 'package:flutter/material.dart';
import 'package:habits_plus/core/enums/habitType.dart';
import 'package:habits_plus/core/models/habit.dart';

class TopHabitsWidget extends StatelessWidget {
  List<Habit> habits;

  TopHabitsWidget({
    this.habits,
  });

  Widget _tile(context, int i) {
    int percentage;

    if (habits[i].type == HabitType.Countable) {
      double sum = 0;
      habits[i].countableProgress.forEach((_, elem) {
        sum += elem[0];
      });
      percentage = (sum / habits[i].goalAmount * 100).toInt();
    } else {
      percentage =
          (habits[i].progressBin.length / habits[i].goalAmount * 100).toInt();
    }

    return GestureDetector(
      onTap: () => Navigator.pushNamed(
        context,
        'habit_detail',
        arguments: habits[i],
      ),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 15),
        padding: EdgeInsets.symmetric(vertical: 3),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              habits[i].title.length > 35
                  ? habits[i].title.substring(0, 35) + '...'
                  : habits[i].title,
              style: TextStyle(
                color: Theme.of(context).textSelectionHandleColor,
                fontSize: 18,
              ),
            ),
            Text(
              percentage.toString() + '%',
              style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontSize: 18,
                fontWeight: FontWeight.w600,
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
      child: Column(
        children: List.generate(
          habits.length,
          (int i) => _tile(context, i),
        ),
      ),
    );
  }
}
