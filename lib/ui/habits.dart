import 'package:calendar_strip/calendar_strip.dart';
import 'package:flutter/material.dart';
import 'package:habits_plus/localization.dart';
import 'package:habits_plus/models/habit.dart';
import 'package:habits_plus/models/task.dart';
import 'package:habits_plus/models/userData.dart';
import 'package:habits_plus/notifiers/task.dart';
import 'package:habits_plus/services/database.dart';
import 'package:habits_plus/ui/home.dart';
import 'package:habits_plus/ui/task_ListView.dart';
import 'package:habits_plus/util/constant.dart';
import 'package:implicitly_animated_reorderable_list/implicitly_animated_reorderable_list.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../main.dart';

class HabitsPage extends StatefulWidget {
  List<Habit> habits;

  HabitsPage({
    this.habits,
  });

  @override
  Key get key => habitsPageKey;

  @override
  HabitsPageState createState() => HabitsPageState();
}

class HabitsPageState extends State<HabitsPage> with TickerProviderStateMixin {
  // Provider
  TaskData taskNotifier;

  // Calendar
  List<DateTime> markedDates = [];
  DateTime currentDate = dateFormater.parse(DateTime.now().toString());

  // Habits
  Map<int, List<DateTime>> habitsDate = {};
  List<Habit> habits = [];
  List<Habit> todayHabits = [];
  List<bool> openedHabits = [false, false];

  // Tasks
  List<Task> tasks = [];
  List<Task> todayTasks = [];
  List<Task> doneTodayTasks = [];
  List<Task> notDoneTodayTasks = [];
  bool hasNotDoneTasks = false;
  bool hasDoneTasks = false;

  void initHabits() {
    // Init markedDates
    DateTime today = DateTime.now();
    DateTime _firstDayOfTheweek = DateTime.now();
    if (today.weekday != 1) {
      _firstDayOfTheweek = today.subtract(
        new Duration(days: today.weekday - 1),
      );
    }
    _firstDayOfTheweek = _firstDayOfTheweek.subtract(
      new Duration(days: 210),
    );
    for (var i = 0; i < widget.habits.length; i++) {
      for (var j = 0; j < widget.habits[i].repeatDays.length; j++) {
        DateTime current = _firstDayOfTheweek.add(Duration(days: j));
        if (widget.habits[i].repeatDays[j]) {
          for (var a = 0; a < 60; a++) {
            DateTime date = current.add(Duration(days: a * 7));
            markedDates.add(date);

            habitsDate[i] == null
                ? habitsDate[i] = [dateFormater.parse(date.toString())]
                : habitsDate[i].add(dateFormater.parse(date.toString()));
          }
        }
      }
    }
  }

  void initTasks() {
    // Init markedDates
    DateTime today = DateTime.now();
    DateTime _firstDayOfTheweek = DateTime.now();
    if (today.weekday != 1) {
      _firstDayOfTheweek = today.subtract(
        new Duration(days: today.weekday - 1),
      );
    }
    _firstDayOfTheweek = _firstDayOfTheweek.subtract(
      new Duration(days: 210),
    );
    for (var i = 0; i < tasks.length; i++) {
      if (tasks[i].date != null) {
        markedDates.add(tasks[i].date);
      }
    }

    markedDates = markedDates.toSet().toList();
  }

  setTodayHabits(DateTime date) {
    todayHabits = [];
    for (var i = 0; i < habits.length; i++) {
      for (var j = 0; j < habitsDate[i].length; j++) {
        if (habitsDate[i][j] == dateFormater.parse(date.toString())) {
          todayHabits.add(habits[i]);
        }
      }
    }
  }

  setTodayTasks(DateTime date) {
    todayTasks = [];
    doneTodayTasks = [];
    notDoneTodayTasks = [];
    for (var i = 0; i < tasks.length; i++) {
      if (tasks[i].date != null) {
        if (dateFormater.format(tasks[i].date) == dateFormater.format(date)) {
          todayTasks.add(tasks[i]);
          if (tasks[i].done) {
            doneTodayTasks.add(tasks[i]);
          } else {
            notDoneTodayTasks.add(tasks[i]);
          }
        }
      } else {
        todayTasks.add(tasks[i]);
        if (tasks[i].done) {
          doneTodayTasks.add(tasks[i]);
        } else {
          notDoneTodayTasks.add(tasks[i]);
        }
      }

      // Set section view
      if (!tasks[i].done) {
        hasNotDoneTasks = true;
      } else {
        hasDoneTasks = true;
      }
    }

    // Update provider
    taskNotifier.todayTasks = todayTasks;
    taskNotifier.notDoneTodayTasks = notDoneTodayTasks;
    taskNotifier.doneTodayTasks = doneTodayTasks;
  }

  @override
  void initState() {
    super.initState();

    // Init provider
    taskNotifier = Provider.of<TaskData>(context);

    // Init habits & tasks
    habits = widget.habits;
    tasks = taskNotifier.allTasks;

    initHabits();
    initTasks();

    setTodayHabits(DateTime.now());
    setTodayTasks(DateTime.now());
  }

  Widget _buildClosedProgressRow(int index) {
    // Used in _buildHabitBox() method if box is not opened
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: List.generate(
            todayHabits[index].progressBin.length % 7,
            (int i) {
              int currentItem =
                  (todayHabits[index].progressBin.length / 7).floor() + i;
              // Init icon
              Icon _icon = Icon(Icons.signal_cellular_null);
              if (todayHabits[index].progressBin[currentItem] == 1) {
                // Tick
                _icon = Icon(
                  Icons.done,
                  size: 28,
                  color: Colors.white,
                );
              } else if (todayHabits[index].progressBin[currentItem] == -1) {
                _icon = Icon(
                  Icons.close,
                  size: 24,
                  color: Colors.white24,
                );
              } else {
                _icon = _icon = Icon(
                  Icons.close,
                  size: 28,
                  color: Colors.white,
                );
              }

              return Container(
                margin: EdgeInsets.all(5),
                child: Material(
                  color: Colors.transparent,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100)),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(100),
                    onTap: () {
                      setState(() {
                        todayHabits[index].progressBin[currentItem] = 1;
                        DatabaseServices.updateHabit(
                          todayHabits[index],
                          Provider.of<UserData>(context, listen: false)
                              .currentUserId,
                        );
                      });
                    },
                    onLongPress: () {
                      setState(() {
                        if (habits[index].progressBin[currentItem] == 1) {
                          todayHabits[index].progressBin[currentItem] = 0;
                          DatabaseServices.updateHabit(
                            todayHabits[index],
                            Provider.of<UserData>(context, listen: false)
                                .currentUserId,
                          );
                        } else {
                          todayHabits[index].progressBin[currentItem] = -1;
                          DatabaseServices.updateHabit(
                            todayHabits[index],
                            Provider.of<UserData>(context, listen: false)
                                .currentUserId,
                          );
                        }
                      });
                    },
                    child: _icon,
                  ),
                ),
              );
            },
          ) +

          // Not marked
          List.generate(
            7 - todayHabits[index].progressBin.length % 7,
            (int i) {
              return Container(
                margin: EdgeInsets.all(5),
                child: Material(
                  color: Colors.transparent,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100)),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(100),
                    onTap: () {
                      setState(() {
                        todayHabits[index].progressBin.add(1);
                        DatabaseServices.updateHabit(
                          todayHabits[index],
                          Provider.of<UserData>(context, listen: false)
                              .currentUserId,
                        );
                        if (todayHabits[index].progressBin.length % 7 == 0) {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              // TODO: implement dialog
                              return AlertDialog(
                                content: Text('Nice!'),
                              );
                            },
                          );
                        }
                      });
                    },
                    child: Icon(
                      Icons.close,
                      size: 24,
                      color: Colors.white24,
                    ),
                  ),
                ),
              );
            },
          ),
    );
  }

  Widget _buildOpenedProgressRow(int index) {
    int rowIndexLimit =
        ((todayHabits[index].progressBin.length / 7) + 0.5).round();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
            Text(
              todayHabits[index].description,
              style: TextStyle(
                color: Colors.white.withOpacity(0.8),
                fontSize: 16,
              ),
            ),
            SizedBox(height: 25),
          ] +
          List.generate(
            rowIndexLimit,
            (int rowIndex) {
              return Container(
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[] +
                        List.generate(
                          rowIndex == rowIndexLimit - 1
                              ? todayHabits[index].progressBin.length % 7
                              : 7,
                          (int progressIndex) {
                            // Init icon
                            int currentProgressItem =
                                rowIndex * 7 + progressIndex;
                            Icon _icon = Icon(Icons.signal_cellular_null);
                            if (todayHabits[index]
                                    .progressBin[currentProgressItem] ==
                                1) {
                              // Done icon
                              _icon = Icon(
                                Icons.done,
                                size: 28,
                                color: Colors.white,
                              );
                            } else if (todayHabits[index]
                                    .progressBin[currentProgressItem] ==
                                -1) {
                              // Not executed icon
                              _icon = Icon(
                                Icons.close,
                                size: 24,
                                color: Colors.white24,
                              );
                            } else {
                              // Not marked icon
                              _icon = _icon = Icon(
                                Icons.close,
                                size: 28,
                                color: Colors.white,
                              );
                            }

                            return Container(
                              margin: EdgeInsets.all(5),
                              child: Material(
                                color: Colors.transparent,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(100)),
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(100),
                                  onTap: () {
                                    setState(() {
                                      todayHabits[index]
                                          .progressBin[currentProgressItem] = 1;
                                      DatabaseServices.updateHabit(
                                        todayHabits[index],
                                        Provider.of<UserData>(context,
                                                listen: false)
                                            .currentUserId,
                                      );
                                    });
                                  },
                                  onLongPress: () {
                                    setState(() {
                                      if (habits[index].progressBin[
                                              currentProgressItem] ==
                                          1) {
                                        todayHabits[index].progressBin[
                                            currentProgressItem] = 0;
                                        DatabaseServices.updateHabit(
                                          todayHabits[index],
                                          Provider.of<UserData>(context,
                                                  listen: false)
                                              .currentUserId,
                                        );
                                      } else {
                                        todayHabits[index].progressBin[
                                            currentProgressItem] = -1;
                                        DatabaseServices.updateHabit(
                                          todayHabits[index],
                                          Provider.of<UserData>(context,
                                                  listen: false)
                                              .currentUserId,
                                        );
                                      }
                                    });
                                  },
                                  child: _icon,
                                ),
                              ),
                            );
                          },
                        ) +

                        // Not marked
                        List.generate(
                          rowIndex == rowIndexLimit - 1
                              ? 7 - todayHabits[index].progressBin.length % 7
                              : 0,
                          (int i) {
                            return Container(
                              margin: EdgeInsets.all(5),
                              child: Material(
                                color: Colors.transparent,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(100)),
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(100),
                                  onTap: () {
                                    setState(() {
                                      todayHabits[index].progressBin.add(1);
                                      DatabaseServices.updateHabit(
                                        todayHabits[index],
                                        Provider.of<UserData>(context,
                                                listen: false)
                                            .currentUserId,
                                      );
                                      if (todayHabits[index]
                                                  .progressBin
                                                  .length %
                                              7 ==
                                          0) {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            // TODO: implement dialog
                                            return AlertDialog(
                                              content: Text('Nice!'),
                                            );
                                          },
                                        );
                                      }
                                    });
                                  },
                                  child: Icon(
                                    Icons.close,
                                    size: 24,
                                    color: Colors.white24,
                                  ),
                                ),
                              ),
                            );
                          },
                        )),
              );
            },
          ) +
          <Widget>[
            SizedBox(height: 5),
            GestureDetector(
              onTap: () => print('go to setting page'),
              child: Container(
                padding: EdgeInsets.only(left: 5),
                child: Icon(
                  Icons.more_horiz,
                  size: 24,
                  color: Colors.white,
                ),
              ),
            ),
          ],
    );
  }

  dateTileBuilder(
      date, selectedDate, rowIndex, dayName, isDateMarked, isDateOutOfRange) {
    bool isSelectedDate = date.compareTo(selectedDate) == 0;

    // Day style
    TextStyle normalStyle = TextStyle(
      fontSize: 17,
      fontWeight: FontWeight.w800,
      color: Theme.of(context).textSelectionColor,
    );
    TextStyle selectedStyle = TextStyle(
      fontSize: 17,
      color: Colors.white,
    );

    // Translate day
    dayName = AppLocalizations.of(context).translate(dayName);

    // Name of Day Style
    TextStyle dayNameStyle = TextStyle(
      fontSize: 12,
      color: Theme.of(context).disabledColor,
    );
    TextStyle daySelectedStyle = TextStyle(
      fontSize: 12,
      color: Colors.white.withOpacity(0.75),
    );

    // Build column
    List<Widget> _children = [
      Text(
        dayName,
        style: isSelectedDate ? daySelectedStyle : dayNameStyle,
      ),
      Text(
        date.day.toString(),
        style: !isSelectedDate ? normalStyle : selectedStyle,
      ),
      SizedBox(height: 5),
      isDateMarked
          ? AnimatedContainer(
              duration: Duration(milliseconds: 250),
              width: 5,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
            )
          : SizedBox(height: 5),
    ];

    // Build day box
    return AnimatedContainer(
      margin: EdgeInsets.symmetric(horizontal: 3),
      duration: Duration(milliseconds: 250),
      alignment: Alignment.center,
      padding: EdgeInsets.only(top: 8, left: 5, right: 5, bottom: 5),
      decoration: BoxDecoration(
        color: !isSelectedDate
            ? Colors.transparent
            : Theme.of(context).primaryColor,
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: Column(
        children: _children,
      ),
    );
  }

  Widget _buildMoreHabits() {
    return Container(
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: AppLocalizations.of(context).translate('habits_span_1'),
              style: TextStyle(
                color: Theme.of(context).textSelectionHandleColor,
                fontSize: 18,
              ),
            ),
            TextSpan(
              text: (todayHabits.length - 2).toString() +
                  AppLocalizations.of(context).translate('habits_span_2'),
              style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontSize: 18,
              ),
            ),
            TextSpan(
              text: AppLocalizations.of(context).translate('habits_span_3'),
              style: TextStyle(
                color: Theme.of(context).textSelectionHandleColor,
                fontSize: 18,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHabitBox(int index) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      width: MediaQuery.of(context).size.width - 20,
      decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              offset: Offset(0, 3),
              blurRadius: 5,
              color: Theme.of(context).primaryColor.withOpacity(0.25),
            ),
          ]),
      child: Column(
        children: <Widget>[
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  child: Row(
                    children: <Widget>[
                      Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          border: Border.all(width: 1, color: Colors.white70),
                          color: colors[todayHabits[index].colorCode],
                          shape: BoxShape.circle,
                        ),
                      ),
                      SizedBox(width: 10),
                      Text(
                        todayHabits[index].title,
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                openedHabits[index]
                    ? IconButton(
                        splashColor: Colors.white12,
                        icon: Icon(Icons.arrow_drop_up),
                        color: Colors.white,
                        onPressed: () {
                          setState(() {
                            openedHabits[index] = false;
                          });
                        },
                      )
                    : IconButton(
                        splashColor: Colors.white12,
                        icon: Icon(Icons.arrow_drop_down),
                        color: Colors.white,
                        onPressed: () {
                          setState(() {
                            openedHabits[index] = true;
                          });
                        },
                      ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(bottom: 10),
            child: openedHabits[index]
                ? _buildOpenedProgressRow(index)
                : _buildClosedProgressRow(index),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    print('in parent ${doneTodayTasks.length}, ${notDoneTodayTasks.length}');
    Widget child = Container(
      color: Theme.of(context).backgroundColor,
      padding: EdgeInsets.only(left: 10, right: 10, top: 36),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // Calendar
            Container(
              child: CalendarStrip(
                containerHeight: 77,
                startDate: DateTime.utc(2015),
                endDate: DateTime.utc(2030),
                onDateSelected: (DateTime date) {
                  setTodayHabits(date);
                  setTodayTasks(date);
                  setState(() {
                    currentDate = dateFormater.parse(date.toString());
                  });
                },
                dateTileBuilder: dateTileBuilder,
                iconColor: Theme.of(context).disabledColor,
                monthNameWidget: (String name) => SizedBox.shrink(),
                markedDates: markedDates,
              ),
            ),

            // Habits for today
            SizedBox(height: 15),
            todayHabits.length > 0
                ? Text(
                    AppLocalizations.of(context)
                        .translate('habits_for_today')
                        .toUpperCase(),
                    style: TextStyle(
                      fontSize: 18,
                      color: Theme.of(context)
                          .textSelectionColor
                          .withOpacity(0.75),
                      fontWeight: FontWeight.w600,
                    ),
                  )
                : SizedBox.shrink(),
            SizedBox(height: 5),
            todayHabits.length >= 1 ? _buildHabitBox(0) : SizedBox.shrink(),
            SizedBox(height: 15),
            todayHabits.length >= 2 ? _buildHabitBox(1) : SizedBox.shrink(),
            SizedBox(height: 15),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  (todayHabits.length - 2) > 0
                      ? _buildMoreHabits()
                      : SizedBox.shrink(),
                ],
              ),
            ),
            // SizedBox(height: 0),

            TaskListView(),
          ],
        ),
      ),
    );

    // Update mark to reload this widget
    isHabitsPageBuild = true;

    return child;
  }
}
