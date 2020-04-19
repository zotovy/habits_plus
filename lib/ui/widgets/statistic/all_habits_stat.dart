import 'package:flutter/material.dart';
import 'package:habits_plus/localization.dart';

class AllHabitStatWidget extends StatefulWidget {
  AllHabitStatData data;

  AllHabitStatWidget(
    this.data,
  );

  @override
  _AllHabitStatWidgetState createState() => _AllHabitStatWidgetState();
}

class _AllHabitStatWidgetState extends State<AllHabitStatWidget> {
  double width;
  List<String> _text = [];
  List<String> _subText = [];
  List<bool> isPressed = [false, false, false];

  @override
  void initState() {
    super.initState();
  }

  Widget _tile(int i) {
    return GestureDetector(
      onTapDown: (TapDownDetails _details) {
        setState(() {
          isPressed[i] = true;
        });
      },
      onTapUp: (TapUpDetails _details) {
        setState(() {
          isPressed[i] = false;
        });
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        margin: EdgeInsets.only(bottom: 10),
        width: width,
        height: width,
        decoration: BoxDecoration(
          color: Theme.of(context).brightness == Brightness.light
              ? Colors.white
              : Theme.of(context).disabledColor.withOpacity(0.05),
          boxShadow:
              Theme.of(context).brightness == Brightness.light && !isPressed[i]
                  ? [
                      BoxShadow(
                        offset: Offset(3, 3),
                        blurRadius: 7,
                        color: Colors.black.withOpacity(0.07),
                      ),
                    ]
                  : null,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              _text[i],
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.w600,
                fontSize: 32,
              ),
            ),
            SizedBox(height: 3),
            Text(
              _subText[i],
              textAlign: TextAlign.center,
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    width = (MediaQuery.of(context).size.width - 50) / 3 >= 115
        ? 115
        : (MediaQuery.of(context).size.width - 50) / 3;

    _text = [
      '${widget.data.done}/${widget.data.today}'.length > 4
          ? '${widget.data.done}'
          : '${widget.data.done}/${widget.data.today}',
      widget.data.all > 999 ? '999+' : '${widget.data.all}',
      '${widget.data.percent}%',
    ];

    _subText = [
      AppLocalizations.of(context).translate('done_habits'),
      AppLocalizations.of(context).translate('all_habits'),
      AppLocalizations.of(context).translate('realized_habits'),
    ];

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(
          3,
          (int i) => _tile(i),
        ),
      ),
    );
  }
}

class AllHabitStatData {
  int all;
  int today;
  int done;
  int percent;

  AllHabitStatData({
    this.all,
    this.done,
    this.percent,
    this.today,
  });
}
