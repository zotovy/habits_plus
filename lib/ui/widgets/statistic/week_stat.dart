import 'package:flutter/material.dart';
import 'package:habits_plus/localization.dart';

class WeekStatWidget extends StatefulWidget {
  Map stats;

  WeekStatWidget({
    @required this.stats,
  });

  @override
  _WeekStatWidgetState createState() => _WeekStatWidgetState();
}

class _WeekStatWidgetState extends State<WeekStatWidget>
    with SingleTickerProviderStateMixin {
  List<String> _keys = ['count', 'completions', 'percent'];
  List<String> names = [];
  List<int> values = [0, 0, 0];

  // Animation
  AnimationController _animationController;
  List<Animation> _animation = [null, null, null];

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

    _animation[0] = IntTween(begin: 0, end: widget.stats[_keys[0]])
        .animate(_animationController)
          ..addListener(() {
            setState(() {
              values[0] = _animation[0].value;
            });
          });

    _animation[1] = IntTween(begin: 0, end: widget.stats[_keys[1]])
        .animate(_animationController)
          ..addListener(() {
            setState(() {
              values[1] = _animation[1].value;
            });
          });

    _animation[2] = IntTween(begin: 0, end: widget.stats[_keys[2]])
        .animate(_animationController)
          ..addListener(() {
            setState(() {
              values[2] = _animation[2].value;
            });
          });

    Future.delayed(Duration(milliseconds: 300)).then((onValue) {
      _animationController.forward();
    });
  }

  Widget _tile(int i) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            i == 2 ? values[i].toString() + '%' : values[i].toString(),
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w600,
            ),
          ),
          // SizedBox(height: 5),
          Text(
            names[i],
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    names = [];
    names.add(AppLocalizations.of(context).translate('habits'));
    names.add(AppLocalizations.of(context).translate('completions'));
    names.add(AppLocalizations.of(context).translate('complete'));
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
//
//
//
//
//
//

//========================================================================================
/*                                                                                      *
 *                                      SINGLE VIEW                                     *
 *                                                                                      */
//========================================================================================

class SingleWeekStatWidget extends StatefulWidget {
  Map stats;

  SingleWeekStatWidget({
    @required this.stats,
  });

  @override
  _SingleWeekStatWidgetState createState() => _SingleWeekStatWidgetState();
}

class _SingleWeekStatWidgetState extends State<SingleWeekStatWidget>
    with SingleTickerProviderStateMixin {
  List<String> _keys = ['completions', 'percent'];
  List<String> names = [];
  List<int> values = [0, 0];

  // Animation
  AnimationController _animationController;
  List<Animation> _animation = [null, null];

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

    _animation[0] = IntTween(begin: 0, end: widget.stats[_keys[0]])
        .animate(_animationController)
          ..addListener(() {
            setState(() {
              values[0] = _animation[0].value;
            });
          });

    _animation[1] = IntTween(begin: 0, end: widget.stats[_keys[1]])
        .animate(_animationController)
          ..addListener(() {
            setState(() {
              values[1] = _animation[1].value;
            });
          });

    Future.delayed(Duration(milliseconds: 300)).then((onValue) {
      _animationController.forward();
    });
  }

  Widget _tile(int i) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            i == 1 ? values[i].toString() + '%' : values[i].toString(),
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w600,
            ),
          ),
          // SizedBox(height: 5),
          Text(
            names[i],
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    names = [];
    names.add(AppLocalizations.of(context).translate('completions'));
    names.add(AppLocalizations.of(context).translate('complete'));
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(
          2,
          (int i) => _tile(i),
        ),
      ),
    );
  }
}
