import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:habits_plus/core/util/constant.dart';
import 'package:habits_plus/localization.dart';
import 'package:habits_plus/ui/widgets/create/appbar.dart';
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

  List<AnimationController> dayRowController;
  List<Animation<double>> dayRowAnim;

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

    dayRowController = List.generate(
      7,
      (int i) => AnimationController(
        vsync: this,
        duration: Duration(milliseconds: 200),
      ),
    );
    dayRowAnim = List.generate(
      7,
      (int i) => Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
        curve: Curves.easeInOutCubic,
        parent: dayRowController[i],
      )),
    );

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
        _dayRowAnim();
        Future.delayed(Duration(milliseconds: 300)).then((onValue) {
          title2Controller.forward();
          Future.delayed(Duration(milliseconds: 300)).then((onValue) {
            calendarController.forward();
          });
        });
      });
    });
  }

  void _dayRowAnim() async {
    for (var i = 0; i < dayRowController.length; i++) {
      await Future.delayed(Duration(milliseconds: 50));
      dayRowController[i].forward();
    }
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
              Text(
                AppLocalizations.of(context).translate('calendar'),
                style: TextStyle(
                  fontSize: 18,
                  color: Theme.of(context).textSelectionHandleColor,
                  fontWeight: FontWeight.w600,
                ),
              ),

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
                child: Text(
                  AppLocalizations.of(context).translate('calendar_desc'),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Theme.of(context).textSelectionColor,
                    fontSize: 16,
                  ),
                ),
              ),

              SizedBox(height: 10),
              FadeTransition(
                opacity: dayRowAnim[6],
                child: Align(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        var eq = ListEquality().equals;
                        if (eq(
                          progressBin,
                          [true, true, true, true, true, true, true],
                        )) {
                          progressBin = [
                            false,
                            false,
                            false,
                            false,
                            false,
                            false,
                            false,
                          ];
                        } else {
                          progressBin = [
                            true,
                            true,
                            true,
                            true,
                            true,
                            true,
                            true,
                          ];
                        }
                      });
                    },
                    child: Container(
                      margin: EdgeInsets.only(right: 15),
                      child: Text(
                        AppLocalizations.of(context)
                            .translate('createHabit_everyday'),
                        style: TextStyle(
                          color: ListEquality().equals(
                            progressBin,
                            [true, true, true, true, true, true, true],
                          )
                              ? Theme.of(context).primaryColor
                              : Theme.of(context).textSelectionColor,
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 3),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(
                    7,
                    (int i) => FadeTransition(
                      opacity: dayRowAnim[i],
                      child: GestureDetector(
                        onTap: () => setState(() {
                          progressBin[i] = !progressBin[i];
                        }),
                        child: AnimatedContainer(
                          duration: Duration(milliseconds: 200),
                          width: 37,
                          height: 37,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: progressBin[i]
                                ? Theme.of(context).primaryColor
                                : Theme.of(context).disabledColor,
                          ),
                          child: Center(
                            child: Text(
                              AppLocalizations.of(context).lang == 'en'
                                  ? AppLocalizations.of(context)
                                      .translate(dayNames[i])[0]
                                  : AppLocalizations.of(context)
                                      .translate(dayNames[i]),
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 25),

              // "Choose time period"
              FadeTransition(
                opacity: title2Anim,
                child: Text(
                  AppLocalizations.of(context).translate('choose_time_period'),
                  style: TextStyle(
                    fontSize: 18,
                    color: Theme.of(context).textSelectionHandleColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              SizedBox(height: 5),

              // Time description
              Text(
                AppLocalizations.of(context).translate('time_period'),
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Theme.of(context).textSelectionColor,
                  fontSize: 16,
                ),
              ),
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
                  child: _Calendar(
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
              Container(
                margin: EdgeInsets.symmetric(horizontal: 15),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Material(
                  child: InkWell(
                    borderRadius: BorderRadius.circular(10),
                    onTap: () {
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
                        } else {
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
                              backgroundColor:
                                  Colors.redAccent.withOpacity(0.75),
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
                    child: Container(
                      padding: EdgeInsets.all(15),
                      child: Center(
                        child: Text(
                          AppLocalizations.of(context).translate('intro_next'),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 15),
            ],
          ),
        ),
      ),
    );
  }
}

typedef DayBuilder(BuildContext context, DateTime day);

class _Calendar extends StatefulWidget {
  final Function(DateTime _left, DateTime _right) onDateSelected;
  final ValueChanged<Tuple2<DateTime, DateTime>> onSelectedRangeChange;
  final bool isExpandable;
  final DayBuilder dayBuilder;
  final bool showChevronsToChangeRange;
  final bool showTodayAction;
  final bool showCalendarPickerIcon;
  final DateTime initialCalendarDateOverride;

  _Calendar({
    this.onDateSelected,
    this.onSelectedRangeChange,
    this.isExpandable: false,
    this.dayBuilder,
    this.showTodayAction: true,
    this.showChevronsToChangeRange: true,
    this.showCalendarPickerIcon: true,
    this.initialCalendarDateOverride,
  });

  @override
  __CalendarState createState() => __CalendarState();
}

class __CalendarState extends State<_Calendar> {
  final calendarUtils = Utils();
  List<DateTime> selectedMonthsDays;
  Iterable<DateTime> selectedWeeksDays;
  DateTime _selectedDate = DateTime.now();
  String currentMonth;
  bool isExpanded = true;
  String displayMonth;
  DateTime get selectedDate => _selectedDate;

  DateTime _left, _right;
  bool hasSelection = false;

  void initState() {
    super.initState();
    if (widget.initialCalendarDateOverride != null)
      _selectedDate = widget.initialCalendarDateOverride;
    selectedMonthsDays = Utils.daysInMonth(_selectedDate);
    var firstDayOfCurrentWeek = Utils.firstDayOfWeek(_selectedDate);
    var lastDayOfCurrentWeek = Utils.lastDayOfWeek(_selectedDate);
    selectedWeeksDays =
        Utils.daysInRange(firstDayOfCurrentWeek, lastDayOfCurrentWeek)
            .toList()
            .sublist(0, 7);
  }

  Widget get nameAndIconRow {
    var leftOuterIcon;
    var rightOuterIcon;

    if (widget.showChevronsToChangeRange) {
      leftOuterIcon = IconButton(
        onPressed: isExpanded ? previousMonth : previousWeek,
        icon: Icon(Icons.chevron_left),
      );
      rightOuterIcon = IconButton(
        onPressed: isExpanded ? nextMonth : nextWeek,
        icon: Icon(Icons.chevron_right),
      );
    } else {
      leftOuterIcon = Container();
      rightOuterIcon = Container();
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        leftOuterIcon ?? Container(),
        // leftInnerIcon ??  Container(),
        Text(
          displayMonth,
          style: TextStyle(
            fontSize: 16.0,
          ),
        ),
        // rightInnerIcon ??  Container(),
        rightOuterIcon ?? Container(),
      ],
    );
  }

  Widget get calendarGridView {
    return Container(
      child: GestureDetector(
        onHorizontalDragStart: (gestureDetails) => beginSwipe(gestureDetails),
        onHorizontalDragUpdate: (gestureDetails) =>
            getDirection(gestureDetails),
        onHorizontalDragEnd: (gestureDetails) => endSwipe(gestureDetails),
        child: GridView.count(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          crossAxisCount: 7,
          children: calendarBuilder(),
        ),
      ),
    );
  }

  List<Widget> calendarBuilder() {
    List<Widget> dayWidgets = [];
    List<DateTime> calendarDays = selectedMonthsDays;

    Utils.weekdays.forEach(
      (day) {
        dayWidgets.add(
          CalendarTile(
            isDayOfWeek: true,
            dayOfWeek: day,
          ),
        );
      },
    );

    bool monthStarted = false;
    bool monthEnded = false;

    calendarDays.forEach(
      (day) {
        if (monthStarted && day.day == 01) {
          monthEnded = true;
        }

        if (Utils.isFirstDayOfMonth(day)) {
          monthStarted = true;
        }

        if (this.widget.dayBuilder != null) {
          dayWidgets.add(
            CalendarTile(
              child: this.widget.dayBuilder(context, day),
              date: day,
              onDateSelected: () => handleSelectedDateAndUserCallback(day),
              isLeft: _left == null ? false : _left == day,
              isRight: _right == day,
              isMiddle: day == null
                  ? false
                  : day.isAfter(_left) && day.isBefore(_right),
            ),
          );
        } else {
          dayWidgets.add(
            CalendarTile(
              onDateSelected: () => handleSelectedDateAndUserCallback(day),
              date: day,
              dateStyles: configureDateStyle(monthStarted, monthEnded),
              isSelected: Utils.isSameDay(selectedDate, day),
              isLeft: _left == null ? false : _left == day,
              isRight: _right == null ? false : _right == day,
              isMiddle: _left == null || _right == null
                  ? false
                  : day.isAfter(_left) && day.isBefore(_right),
              hasSelection: hasSelection,
            ),
          );
        }
      },
    );
    return dayWidgets;
  }

  TextStyle configureDateStyle(monthStarted, monthEnded) {
    TextStyle dateStyles;
    final TextStyle body1Style = Theme.of(context).textTheme.body1;

    if (isExpanded) {
      final TextStyle body1StyleDisabled = body1Style.copyWith(
          color: Color.fromARGB(
        100,
        body1Style.color.red,
        body1Style.color.green,
        body1Style.color.blue,
      ));

      dateStyles =
          monthStarted && !monthEnded ? body1Style : body1StyleDisabled;
    } else {
      dateStyles = body1Style;
    }
    return dateStyles;
  }

  @override
  Widget build(BuildContext context) {
    List _mothSplit = Utils.formatMonth(_selectedDate).split(' ');
    displayMonth = AppLocalizations.of(context).translate(_mothSplit[0]) +
        ' ${_mothSplit[1]}';
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          nameAndIconRow,
          ExpansionCrossFade(
            collapsed: calendarGridView,
            expanded: calendarGridView,
            isExpanded: isExpanded,
          ),
          // expansionButtonRow
        ],
      ),
    );
  }

  void resetToToday() {
    _selectedDate = DateTime.now();
    var firstDayOfCurrentWeek = Utils.firstDayOfWeek(_selectedDate);
    var lastDayOfCurrentWeek = Utils.lastDayOfWeek(_selectedDate);

    setState(() {
      selectedWeeksDays =
          Utils.daysInRange(firstDayOfCurrentWeek, lastDayOfCurrentWeek)
              .toList();
      selectedMonthsDays = Utils.daysInMonth(_selectedDate);
      displayMonth = Utils.formatMonth(_selectedDate);
    });

    _launchDateSelectionCallback(_selectedDate);
  }

  void nextMonth() {
    setState(() {
      _selectedDate = Utils.nextMonth(_selectedDate);
      var firstDateOfMonth = Utils.firstDayOfMonth(_selectedDate);
      var lastDateOfMonth = Utils.lastDayOfMonth(_selectedDate);
      updateSelectedRange(firstDateOfMonth, lastDateOfMonth);
      selectedMonthsDays = Utils.daysInMonth(_selectedDate);
      displayMonth = Utils.formatMonth(_selectedDate);
    });
  }

  void previousMonth() {
    setState(() {
      _selectedDate = Utils.previousMonth(_selectedDate);
      var firstDateOfMonth = Utils.firstDayOfMonth(_selectedDate);
      var lastDateOfMonth = Utils.lastDayOfMonth(_selectedDate);
      updateSelectedRange(firstDateOfMonth, lastDateOfMonth);
      selectedMonthsDays = Utils.daysInMonth(_selectedDate);
      displayMonth = Utils.formatMonth(_selectedDate);
    });
  }

  void nextWeek() {
    setState(() {
      _selectedDate = Utils.nextWeek(_selectedDate);
      var firstDayOfCurrentWeek = Utils.firstDayOfWeek(_selectedDate);
      var lastDayOfCurrentWeek = Utils.lastDayOfWeek(_selectedDate);
      updateSelectedRange(firstDayOfCurrentWeek, lastDayOfCurrentWeek);
      selectedWeeksDays =
          Utils.daysInRange(firstDayOfCurrentWeek, lastDayOfCurrentWeek)
              .toList()
              .sublist(0, 7);
      displayMonth = Utils.formatMonth(_selectedDate);
    });
    _launchDateSelectionCallback(_selectedDate);
  }

  void previousWeek() {
    setState(() {
      _selectedDate = Utils.previousWeek(_selectedDate);
      var firstDayOfCurrentWeek = Utils.firstDayOfWeek(_selectedDate);
      var lastDayOfCurrentWeek = Utils.lastDayOfWeek(_selectedDate);
      updateSelectedRange(firstDayOfCurrentWeek, lastDayOfCurrentWeek);
      selectedWeeksDays =
          Utils.daysInRange(firstDayOfCurrentWeek, lastDayOfCurrentWeek)
              .toList()
              .sublist(0, 7);
      displayMonth = Utils.formatMonth(_selectedDate);
    });
    _launchDateSelectionCallback(_selectedDate);
  }

  void updateSelectedRange(DateTime start, DateTime end) {
    var selectedRange = Tuple2<DateTime, DateTime>(start, end);
    if (widget.onSelectedRangeChange != null) {
      widget.onSelectedRangeChange(selectedRange);
    }
  }

  Future<Null> selectDateFromPicker() async {
    DateTime selected = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(1960),
      lastDate: DateTime(2050),
    );

    if (selected != null) {
      var firstDayOfCurrentWeek = Utils.firstDayOfWeek(selected);
      var lastDayOfCurrentWeek = Utils.lastDayOfWeek(selected);

      setState(() {
        _selectedDate = selected;
        selectedWeeksDays =
            Utils.daysInRange(firstDayOfCurrentWeek, lastDayOfCurrentWeek)
                .toList();
        selectedMonthsDays = Utils.daysInMonth(selected);
        displayMonth = Utils.formatMonth(selected);
      });
      // updating selected date range based on selected week
      updateSelectedRange(firstDayOfCurrentWeek, lastDayOfCurrentWeek);
      _launchDateSelectionCallback(selected);
    }
  }

  var gestureStart;
  var gestureDirection;

  void beginSwipe(DragStartDetails gestureDetails) {
    gestureStart = gestureDetails.globalPosition.dx;
  }

  void getDirection(DragUpdateDetails gestureDetails) {
    if (gestureDetails.globalPosition.dx < gestureStart) {
      gestureDirection = 'rightToLeft';
    } else {
      gestureDirection = 'leftToRight';
    }
  }

  void endSwipe(DragEndDetails gestureDetails) {
    if (gestureDirection == 'rightToLeft') {
      if (isExpanded) {
        nextMonth();
      } else {
        nextWeek();
      }
    } else {
      if (isExpanded) {
        previousMonth();
      } else {
        previousWeek();
      }
    }
  }

  void toggleExpanded() {
    if (widget.isExpandable) {
      setState(() => isExpanded = !isExpanded);
    }
  }

  void handleSelectedDateAndUserCallback(DateTime day) {
    var firstDayOfCurrentWeek = Utils.firstDayOfWeek(day);
    var lastDayOfCurrentWeek = Utils.lastDayOfWeek(day);
    setState(() {
      _selectedDate = day;
      selectedWeeksDays =
          Utils.daysInRange(firstDayOfCurrentWeek, lastDayOfCurrentWeek)
              .toList();
      selectedMonthsDays = Utils.daysInMonth(day);
      displayMonth = Utils.formatMonth(_selectedDate);

      if (_left == null && !hasSelection) {
        _left = day;
      } else if (_left != null && _right == null) {
        if (_left.isAfter(day)) {
          _right = _left;
          _left = day;
        } else {
          _right = day;
        }
        hasSelection = true;
      } else if (_left != null && _right != null) {
        hasSelection = false;
        _left = day;
        _right = null;
      }

      widget.onDateSelected(_left, _right);
    });
    _launchDateSelectionCallback(day);
  }

  void _launchDateSelectionCallback(DateTime day) {
    if (widget.onDateSelected != null) {
      widget.onDateSelected(_left, _right);
    }
  }
}

class ExpansionCrossFade extends StatelessWidget {
  final Widget collapsed;
  final Widget expanded;
  final bool isExpanded;

  ExpansionCrossFade({this.collapsed, this.expanded, this.isExpanded});

  @override
  Widget build(BuildContext context) {
    return Flexible(
      flex: 1,
      child: AnimatedCrossFade(
        firstChild: collapsed,
        secondChild: expanded,
        firstCurve: const Interval(0.0, 1.0, curve: Curves.fastOutSlowIn),
        secondCurve: const Interval(0.0, 1.0, curve: Curves.fastOutSlowIn),
        sizeCurve: Curves.decelerate,
        crossFadeState:
            isExpanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
        duration: const Duration(milliseconds: 300),
      ),
    );
  }
}

class CalendarTile extends StatelessWidget {
  final VoidCallback onDateSelected;
  final DateTime date;
  final String dayOfWeek;
  final bool isDayOfWeek;
  final bool isSelected;
  final TextStyle dayOfWeekStyles;
  final TextStyle dateStyles;
  final Widget child;

  bool isLeft;
  bool isRight;
  bool isMiddle;
  bool hasSelection;

  CalendarTile({
    this.onDateSelected,
    this.date,
    this.child,
    this.dateStyles,
    this.dayOfWeek,
    this.dayOfWeekStyles,
    this.isDayOfWeek: false,
    this.isSelected: false,
    this.isLeft,
    this.isRight,
    this.isMiddle,
    this.hasSelection,
  });

  Widget renderDateOrDayOfWeek(BuildContext context) {
    if (isDayOfWeek) {
      return InkWell(
        child: Container(
          alignment: Alignment.center,
          child: Text(
            // dayOfWeek,
            AppLocalizations.of(context).translate(dayOfWeek),
            style: TextStyle(
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      );
    } else {
      return Container(
        child: InkWell(
          onTap: onDateSelected,
          child: Container(
            decoration: isLeft || isRight || isMiddle
                ? BoxDecoration(
                    borderRadius: isMiddle
                        ? BorderRadius.only(
                            topLeft: isLeft
                                ? Radius.circular(50)
                                : Radius.circular(0),
                            bottomLeft: isLeft
                                ? Radius.circular(50)
                                : Radius.circular(0),
                            topRight: isRight
                                ? Radius.circular(50)
                                : Radius.circular(0),
                            bottomRight: isRight
                                ? Radius.circular(50)
                                : Radius.circular(0),
                          )
                        : BorderRadius.circular(15),
                    color: isLeft || isRight
                        ? Theme.of(context).primaryColor
                        : Colors.transparent,
                  )
                : BoxDecoration(),
            alignment: Alignment.center,
            child: Container(
              margin: EdgeInsets.symmetric(
                horizontal:
                    isSelected && !isMiddle && !isRight && !isLeft ? 5 : 0,
                vertical:
                    isMiddle || isRight || isLeft ? 5 : isSelected ? 5 : 0,
              ),
              decoration: BoxDecoration(
                borderRadius: isLeft || isRight
                    ? BorderRadius.only(
                        topLeft:
                            isLeft ? Radius.circular(50) : Radius.circular(0),
                        bottomLeft:
                            isLeft ? Radius.circular(50) : Radius.circular(0),
                        topRight:
                            isRight ? Radius.circular(50) : Radius.circular(0),
                        bottomRight:
                            isRight ? Radius.circular(50) : Radius.circular(0),
                      )
                    : null,
                color: isLeft || isRight || isMiddle
                    ? hasSelection
                        ? Theme.of(context).primaryColor.withOpacity(0.6)
                        : Colors.transparent
                    : Colors.transparent,
              ),
              child: Center(
                child: Text(
                  Utils.formatDay(date).toString()[0] == '0'
                      ? Utils.formatDay(date).toString()[1]
                      : Utils.formatDay(date).toString(),
                  style: isLeft || isRight || isMiddle
                      ? Theme.of(context).primaryTextTheme.body1
                      : dateStyles,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (child != null) {
      return InkWell(
        child: child,
        onTap: onDateSelected,
      );
    }
    return Container(
      child: renderDateOrDayOfWeek(context),
    );
  }
}
