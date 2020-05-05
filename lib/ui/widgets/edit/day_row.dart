import 'package:flutter/material.dart';
import 'package:habits_plus/localization.dart';

// P.S. List == List<bool> repeatDays

class DayRow extends StatefulWidget {
  Function(List<bool> list) callback;
  List<bool> initialList;

  DayRow({this.callback, this.initialList});

  @override
  _DayRowState createState() => _DayRowState();
}

class _DayRowState extends State<DayRow> {
  // Track private list state
  List<bool> list;

  // ANCHOR: initState
  @override
  void initState() {
    super.initState();
    list = widget.initialList;
  }

  // ANCHOR: dayTile()
  // This function generate sibgle day UI tile
  // & handle day[i] callback
  Widget dayTile(int i) {
    return GestureDetector(
      onTap: () {
        setState(() {
          list[i] = !list[i];
        });
        widget.callback(list);
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        width: 35,
        height: 35,
        decoration: BoxDecoration(
          color: widget.initialList[i]
              ? Theme.of(context).primaryColor
              : Color(0xFFCDCDCD),
          borderRadius: BorderRadius.circular(7),
        ),
        child: Center(
          child: Text(
            AppLocalizations.of(context).translate('createHabit_days')[i],
            style: TextStyle(
              color: Colors.white,
              fontSize: 17,
            ),
          ),
        ),
      ),
    );
  }

  // ANCHOR: build()
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(7, (int i) => dayTile(i)),
      ),
    );
  }
}
