import 'package:flutter/material.dart';
import 'package:habits_plus/core/util/constant.dart';
import 'package:habits_plus/localization.dart';

class DayProgressWidget extends StatefulWidget {
  List<bool> repeatDays;
  Function(int i) pressed;

  DayProgressWidget({
    @required this.repeatDays,
    @required this.pressed,
  });

  @override
  _DayProgressWidgetState createState() => _DayProgressWidgetState();
}

class _DayProgressWidgetState extends State<DayProgressWidget> {
  Widget _tile(int i) => GestureDetector(
        onTap: () {
          setState(() {
            widget.pressed(i);
          });
        },
        child: AnimatedContainer(
          duration: Duration(milliseconds: 200),
          width: 35,
          height: 35,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: widget.repeatDays[i]
                ? Theme.of(context).primaryColor
                : Theme.of(context).disabledColor,
          ),
          child: Center(
            child: Text(
              AppLocalizations.of(context)
                  .translate(dayNames[i])
                  .substring(0, 1),
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(
          7,
          (int i) => _tile(i),
        ),
      ),
    );
  }
}
