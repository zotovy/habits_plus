import 'package:flutter/material.dart';
import 'package:habits_plus/core/models/habit.dart';
import 'package:habits_plus/localization.dart';

class ChooseStatViewTypeWidget extends StatefulWidget {
  List<Habit> habits;
  Function(int index) callback;

  ChooseStatViewTypeWidget({
    @required this.habits,
    @required this.callback,
  });

  @override
  _ChooseStatViewTypeWidgetState createState() =>
      _ChooseStatViewTypeWidgetState();
}

class _ChooseStatViewTypeWidgetState extends State<ChooseStatViewTypeWidget> {
  int selectedIndex = 0;

  Widget _buildTile(int i) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 200),
      margin: EdgeInsets.only(right: i == widget.habits.length ? 0 : 20),
      decoration: BoxDecoration(
        color: selectedIndex == i
            ? Theme.of(context).primaryColor
            : Theme.of(context).backgroundColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Material(
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: () {
            setState(() {
              selectedIndex = i;
            });
            widget.callback(i);
          },
          child: Container(
            padding: EdgeInsets.all(10),
            child: Text(
              widget.habits[i - 1].title,
              style: TextStyle(
                color: selectedIndex == i
                    ? Colors.white
                    : Theme.of(context).textSelectionColor,
                fontSize: 16,
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 15),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: <Widget>[
                // All button
                AnimatedContainer(
                  duration: Duration(milliseconds: 200),
                  margin: EdgeInsets.only(right: 20),
                  decoration: BoxDecoration(
                    color: selectedIndex == 0
                        ? Theme.of(context).primaryColor
                        : Theme.of(context).disabledColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Material(
                    child: InkWell(
                      borderRadius: BorderRadius.circular(10),
                      onTap: () {
                        setState(() {
                          selectedIndex = 0;
                        });
                        widget.callback(0);
                      },
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        child: Text(
                          AppLocalizations.of(context).translate('all'),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ] +
              List.generate(
                widget.habits.length,
                (int i) => _buildTile(i + 1),
              ),
        ),
      ),
    );
  }
}
