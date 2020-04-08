import 'package:flutter/material.dart';
import 'package:habits_plus/localization.dart';
import 'package:tuple/tuple.dart';
import 'package:date_utils/date_utils.dart';

typedef DayBuilder(BuildContext context, DateTime day);

class CalendarRangePicker extends StatefulWidget {
  final Function(DateTime _left, DateTime _right) onDateSelected;
  final ValueChanged<Tuple2<DateTime, DateTime>> onSelectedRangeChange;
  final bool isExpandable;
  final DayBuilder dayBuilder;
  final bool showChevronsToChangeRange;
  final bool showTodayAction;
  final bool showCalendarPickerIcon;
  final DateTime initialCalendarDateOverride;

  CalendarRangePicker({
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
  _CalendarRangePickerState createState() => _CalendarRangePickerState();
}

class _CalendarRangePickerState extends State<CalendarRangePicker> {
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
