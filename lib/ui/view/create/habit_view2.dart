import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:habits_plus/core/util/constant.dart';
import 'package:habits_plus/localization.dart';
import 'package:habits_plus/ui/widgets/create/appbar.dart';
import 'package:habits_plus/ui/widgets/create/calendar.dart';
import 'package:habits_plus/ui/widgets/create/confirm_button.dart';
import 'package:habits_plus/ui/widgets/create/dayRow.dart';
import 'package:habits_plus/ui/widgets/create/texts.dart';
import 'package:tuple/tuple.dart';
import 'package:date_utils/date_utils.dart';

class CreateHabitView2 extends StatefulWidget {
  String title;
  String desc;
  int iconCode;

  CreateHabitView2({
    this.title,
    this.desc,
    this.iconCode,
  });

  @override
  _CreateHabitView2State createState() => _CreateHabitView2State();
}

class _CreateHabitView2State extends State<CreateHabitView2>
    with TickerProviderStateMixin {
  List<bool> progressBin = [false, false, false, false, false, false, false];
  DateTime _left, _right;

  AnimationController boxController;
  Animation<double> boxAnim;

  AnimationController desc1Controller;
  Animation<double> desc1Anim;

  AnimationController title2Controller;
  Animation<double> title2Anim;

  AnimationController calendarController;
  Animation<double> calendarAnim;

  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();

    // Animation
    boxController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );
    boxAnim = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
      curve: Curves.easeInOutCubic,
      parent: boxController,
    ));

    desc1Controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
    desc1Anim = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
      curve: Curves.easeInOutCubic,
      parent: desc1Controller,
    ));

    title2Controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
    title2Anim = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
      curve: Curves.easeInOutCubic,
      parent: title2Controller,
    ));

    calendarController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
    calendarAnim = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
      curve: Curves.easeInOutCubic,
      parent: calendarController,
    ));

    Future.delayed(Duration(milliseconds: 500)).then((onValue) {
      boxController.forward();
      Future.delayed(Duration(milliseconds: 300)).then((onValue) {
        desc1Controller.forward();
        Future.delayed(Duration(milliseconds: 300)).then((onValue) {
          title2Controller.forward();
          Future.delayed(Duration(milliseconds: 300)).then((onValue) {
            calendarController.forward();
          });
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    DateTime _firstDayOfWeek =
        dateFormater.parse(DateTime.now().toString()).weekday != 1
            ? dateFormater.parse(DateTime.now().toString()).subtract(
                  Duration(
                      days: dateFormater
                              .parse(DateTime.now().toString())
                              .weekday -
                          1),
                )
            : dateFormater.parse(DateTime.now().toString());

    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      key: _scaffoldKey,
      appBar: CreatePageAppBar(stage: 2),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              SizedBox(height: 25),

              // "Calendar"
              titleText(context, 'calendar'),

              SizedBox(height: 10),

              // Habit View
              Hero(
                tag: 'create_HabitView2',
                flightShuttleBuilder: (_, Animation<double> animation,
                    HeroFlightDirection _direction, __, ___) {
                  return Scaffold(
                    body: Container(
                      margin: EdgeInsets.symmetric(horizontal: 15),
                      padding: EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Theme.of(context).primaryColor,
                      ),
                      child: Container(
                        child: SingleChildScrollView(
                          physics: NeverScrollableScrollPhysics(),
                          child: Column(
                            children: <Widget>[
                              Container(
                                // Up Row
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Container(
                                      child: Row(
                                        children: <Widget>[
                                          // Icon
                                          Container(
                                            decoration: BoxDecoration(
                                              color: Colors.white24,
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            padding: EdgeInsets.all(5),
                                            child: Icon(
                                              habitsIcons[widget.iconCode],
                                              size: 32,
                                              color: Colors.white,
                                            ),
                                          ),

                                          // Title & desc
                                          Container(
                                            padding:
                                                EdgeInsets.only(left: 12.5),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: <Widget>[
                                                // Title
                                                Text(
                                                  widget.title != null
                                                      ? widget.title.length > 25
                                                          ? widget.title
                                                                  .substring(
                                                                      0, 25) +
                                                              '...'
                                                          : widget.title
                                                      : AppLocalizations.of(
                                                              context)
                                                          .translate(
                                                              'noHabitTitle_hint'),
                                                  style: TextStyle(
                                                    fontSize: 18,
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),

                                                // Padding
                                                AnimatedContainer(
                                                  duration: Duration(
                                                      milliseconds: 300),
                                                  height:
                                                      widget.desc != '' ? 3 : 0,
                                                ),

                                                // Description
                                                Container(
                                                    child: AnimatedContainer(
                                                  duration: Duration(
                                                      milliseconds: 300),
                                                  height: widget.desc == ''
                                                      ? 0
                                                      : 15,
                                                  child: Text(
                                                    widget.desc.length > 30
                                                        ? widget.desc.substring(
                                                                0, 30) +
                                                            '...'
                                                        : widget.desc,
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      color: Colors.white
                                                          .withOpacity(0.75),
                                                      // fontWeight: FontWeight.w600,
                                                    ),
                                                  ),
                                                )),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    FadeTransition(
                                      opacity: animation,
                                      child: Align(
                                        alignment: Alignment.centerRight,
                                        child: AnimatedContainer(
                                          duration: Duration(milliseconds: 200),
                                          width: 30,
                                          height: 30,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(6),
                                            border: Border.all(
                                              color: Colors.white,
                                              width: 2,
                                            ),
                                            color: Colors.white,
                                          ),
                                          child: Icon(
                                            Icons.done,
                                            color:
                                                Theme.of(context).primaryColor,
                                            size: 24,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizeTransition(
                                sizeFactor: animation,
                                child: SizedBox(height: 10),
                              ),

                              // Days
                              SizeTransition(
                                sizeFactor: animation,
                                child: Container(
                                  height: 31,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: List.generate(
                                      7,
                                      (int i) => Container(
                                        width: 30,
                                        height: 30,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          color: Colors.white12,
                                        ),
                                        // padding: EdgeInsets.all(3),
                                        child: Center(
                                          child: AnimatedDefaultTextStyle(
                                            duration:
                                                Duration(milliseconds: 200),
                                            style: progressBin[i]
                                                ? TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.w600,
                                                  )
                                                : TextStyle(
                                                    color: Colors.white30,
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                            child: Text(
                                              AppLocalizations.of(context)
                                                          .lang ==
                                                      'en'
                                                  ? AppLocalizations.of(context)
                                                      .translate(dayNames[i])[0]
                                                  : AppLocalizations.of(context)
                                                      .translate(dayNames[i]),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  margin: EdgeInsets.symmetric(horizontal: 15),
                  padding: EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Theme.of(context).primaryColor,
                  ),
                  child: Container(
                    child: SingleChildScrollView(
                      physics: NeverScrollableScrollPhysics(),
                      child: Column(
                        children: <Widget>[
                          Container(
                            // Up Row
                            child: Row(
                              children: <Widget>[
                                // Icon
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white24,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  padding: EdgeInsets.all(5),
                                  child: Icon(
                                    habitsIcons[widget.iconCode],
                                    size: 32,
                                    color: Colors.white,
                                  ),
                                ),

                                // Title & desc
                                Container(
                                  padding: EdgeInsets.only(left: 12.5),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      // Title
                                      Text(
                                        widget.title != null
                                            ? widget.title.length > 25
                                                ? widget.title
                                                        .substring(0, 25) +
                                                    '...'
                                                : widget.title
                                            : AppLocalizations.of(context)
                                                .translate('noHabitTitle_hint'),
                                        style: TextStyle(
                                          fontSize: 18,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),

                                      // Padding
                                      AnimatedContainer(
                                        duration: Duration(milliseconds: 300),
                                        height: widget.desc != '' ? 3 : 0,
                                      ),

                                      // Description
                                      Container(
                                          child: AnimatedContainer(
                                        duration: Duration(milliseconds: 300),
                                        height: widget.desc == '' ? 0 : 15,
                                        child: Text(
                                          widget.desc.length > 30
                                              ? widget.desc.substring(0, 30) +
                                                  '...'
                                              : widget.desc,
                                          style: TextStyle(
                                            fontSize: 14,
                                            color:
                                                Colors.white.withOpacity(0.75),
                                            // fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      )),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),

                          SizeTransition(
                            sizeFactor: boxAnim,
                            child: SizedBox(height: 10),
                          ),

                          // Days
                          SizeTransition(
                            sizeFactor: boxAnim,
                            child: Container(
                              // height: 31,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: List.generate(
                                  7,
                                  (int i) => SizeTransition(
                                    sizeFactor: boxAnim,
                                    child: Container(
                                      width: 30,
                                      height: 30,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        color: Colors.white12,
                                      ),
                                      // padding: EdgeInsets.all(3),
                                      child: Center(
                                        child: AnimatedDefaultTextStyle(
                                          duration: Duration(milliseconds: 200),
                                          style: progressBin[i]
                                              ? TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w600,
                                                )
                                              : TextStyle(
                                                  color: Colors.white30,
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                          child: Text(
                                            AppLocalizations.of(context).lang ==
                                                    'en'
                                                ? AppLocalizations.of(context)
                                                    .translate(dayNames[i])[0]
                                                : AppLocalizations.of(context)
                                                    .translate(dayNames[i]),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),

              // Calendar description
              FadeTransition(
                opacity: desc1Anim,
                child: descText(context, 'calendar_desc'),
              ),

              Container(
                margin: EdgeInsets.symmetric(horizontal: 15),
                child: DayPickerRow(
                  onPressed: (List<bool> _progressBin) {
                    setState(() {
                      progressBin = _progressBin;
                    });
                  },
                ),
              ),
              SizedBox(height: 25),

              // "Choose time period"
              FadeTransition(
                opacity: title2Anim,
                child: titleText(context, 'choose_time_period'),
              ),
              SizedBox(height: 5),

              // Time description
              descText(context, 'time_period'),
              SizedBox(height: 10),

              // Calendar
              FadeTransition(
                opacity: calendarAnim,
                child: Container(
                  padding: EdgeInsets.all(7),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Theme.of(context).primaryColor,
                      width: 1.5,
                    ),
                  ),
                  margin: EdgeInsets.symmetric(horizontal: 15),
                  child: CalendarRangePicker(
                    onDateSelected: (left, right) {
                      setState(() {
                        _left = left;
                        _right = right;
                      });
                    },
                  ),
                ),
              ),
              SizedBox(height: 20),

              // Confirm
              ConfirmButton(
                onPress: () {
                  if (!ListEquality().equals(
                    progressBin,
                    [false, false, false, false, false, false, false],
                  )) {
                    if (_left != null && _right != null) {
                      Navigator.pushNamed(
                        context,
                        'createHabit_3',
                        arguments: [
                          widget.title,
                          widget.desc,
                          widget.iconCode,
                          progressBin,
                          [_left, _right],
                        ],
                      );
                    } else if (_left != null && _right == null) {
                      Navigator.pushNamed(
                        context,
                        'createHabit_3',
                        arguments: [
                          widget.title,
                          widget.desc,
                          widget.iconCode,
                          progressBin,
                          [_left, _left],
                        ],
                      );
                    } else {
                      print('$_left $_right');
                      _scaffoldKey.currentState.showSnackBar(
                        SnackBar(
                          content: Text(
                            AppLocalizations.of(context)
                                .translate('noDurationSelectedError'),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                          backgroundColor: Colors.redAccent.withOpacity(0.75),
                        ),
                      );
                    }
                  } else {
                    _scaffoldKey.currentState.showSnackBar(
                      SnackBar(
                        content: Text(
                          AppLocalizations.of(context)
                              .translate('noDaySelectedError'),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                        backgroundColor: Colors.redAccent.withOpacity(0.75),
                      ),
                    );
                  }
                },
                stringPath: 'intro_next',
              ),

              SizedBox(height: 15),
            ],
          ),
        ),
      ),
    );
  }
}
