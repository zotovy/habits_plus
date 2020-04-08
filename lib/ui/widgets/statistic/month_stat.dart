import 'package:flutter/material.dart';
import 'package:habits_plus/localization.dart';

class MonthStatWidget extends StatefulWidget {
  Map stats;

  MonthStatWidget({
    @required this.stats,
  });

  @override
  _MonthStatWidgetState createState() => _MonthStatWidgetState();
}

class _MonthStatWidgetState extends State<MonthStatWidget>
    with SingleTickerProviderStateMixin {
  int value = 0;

  // Animation
  AnimationController _animationController;
  Animation _animation;

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    print(widget.stats);
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    );

    _animation = IntTween(begin: 0, end: widget.stats['percent'])
        .animate(_animationController)
          ..addListener(() {
            setState(() {
              value = _animation.value;
            });
          });

    Future.delayed(Duration(milliseconds: 300)).then((onValue) {
      _animationController.forward();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 15),
      child: Row(
        children: <Widget>[
          Text(
            '$value%',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(width: 15),
          Text(
            AppLocalizations.of(context).translate('complete'),
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
