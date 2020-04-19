import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:habits_plus/core/enums/habitType.dart';
import 'package:habits_plus/core/models/habit.dart';
import 'package:habits_plus/core/models/userData.dart';
import 'package:habits_plus/core/services/notifications.dart';
import 'package:habits_plus/core/util/constant.dart';
import 'package:habits_plus/core/viewmodels/create_model.dart';
import 'package:habits_plus/localization.dart';
import 'package:habits_plus/ui/widgets/create/appbar.dart';
import 'package:habits_plus/ui/widgets/create/confirm_button.dart';
import 'package:habits_plus/ui/widgets/create/goal_amount_bottom_sheet.dart';
import 'package:habits_plus/ui/widgets/create/texts.dart';
import 'package:provider/provider.dart';

import '../../../locator.dart';

class CreateHabitView4 extends StatefulWidget {
  String title;
  String desc;
  int iconCode;
  List<bool> progressBin;
  List<DateTime> duration;
  HabitType habitType;

  CreateHabitView4({
    this.title,
    this.desc,
    this.iconCode,
    this.progressBin,
    this.duration,
    this.habitType,
  });

  @override
  _CreateHabitView4State createState() => _CreateHabitView4State();
}

class _CreateHabitView4State extends State<CreateHabitView4>
    with TickerProviderStateMixin {
  bool hasReminder = true;
  DateTime time;
  TimeOfDay dayTime;
  CreateViewModel _model = locator<CreateViewModel>();
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int goalAmount;

  // Animation
  AnimationController _pushExampleTransController;
  Animation<double> _pushExampleTransAnim;

  AnimationController _iconTransitionController;
  Animation<double> _iconTransitionAnim;
  bool isIconTransitionHappend = false;

  AnimationController _nameTransitionController;
  Animation<double> _nameTransitionAnim;
  bool isNameTransitionHappend = false;

  AnimationController _descTransController;
  Animation<double> _descTransAnim;

  AnimationController _switchTransController;
  Animation<double> _switchTransAnim;

  AnimationController _timePickerTransController;
  Animation<double> _timePickerTransAnim;

  AnimationController _confirmButtonTransController;
  Animation<double> _confirmButtonTransAnim;

  @override
  void initState() {
    super.initState();

    // Animation
    _pushExampleTransController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 700),
    );
    _pushExampleTransAnim =
        Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
      curve: Curves.easeInOutCubic,
      parent: _pushExampleTransController,
    ));

    _iconTransitionController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 275),
    );
    _iconTransitionAnim =
        Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
      curve: Curves.easeInOutExpo,
      parent: _iconTransitionController,
    ));

    _nameTransitionController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 275),
    );
    _nameTransitionAnim =
        Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
      curve: Curves.easeInOutExpo,
      parent: _nameTransitionController,
    ));

    _descTransController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
    _descTransAnim = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
      curve: Curves.easeInOut,
      parent: _descTransController,
    ));

    _switchTransController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
    _switchTransAnim = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
      curve: Curves.easeInOut,
      parent: _switchTransController,
    ));

    _timePickerTransController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
    _timePickerTransAnim =
        Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
      curve: Curves.easeInOut,
      parent: _timePickerTransController,
    ));

    _confirmButtonTransController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
    _confirmButtonTransAnim =
        Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
      curve: Curves.easeInOut,
      parent: _confirmButtonTransController,
    ));

    Future.delayed(Duration(milliseconds: 300)).then((onValue) {
      _pushExampleTransController.forward();
      Future.delayed(Duration(milliseconds: 600)).then((onValue) {
        _iconTransitionController.forward();
        _nameTransitionController.forward();
        setState(() {
          isIconTransitionHappend = true;
          isNameTransitionHappend = true;
        });
      });
      Future.delayed(Duration(milliseconds: 600)).then((onValue) {
        _descTransController.forward();
        Future.delayed(Duration(milliseconds: 200)).then((onValue) {
          _switchTransController.forward();
          Future.delayed(Duration(milliseconds: 200)).then((onValue) {
            _timePickerTransController.forward();
            Future.delayed(Duration(milliseconds: 200)).then((onValue) {
              _confirmButtonTransController.forward();
            });
          });
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _model,
      child: Consumer(
        builder: (_, CreateViewModel model, child) {
          return GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: Scaffold(
              key: _scaffoldKey,
              appBar: CreatePageAppBar(stage: 4),
              backgroundColor: Theme.of(context).backgroundColor,
              body: SafeArea(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(height: 25),

                      // "Habit Type"
                      titleText(context, 'push_notification'),

                      // Push preview
                      SizeTransition(
                        sizeFactor: _pushExampleTransAnim,
                        child: AnimatedContainer(
                          duration: Duration(milliseconds: 300),
                          margin: EdgeInsets.symmetric(
                              horizontal: 15, vertical: 10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Theme.of(context).brightness ==
                                    Brightness.dark
                                ? Color.fromARGB(
                                    Theme.of(context).backgroundColor.alpha,
                                    (Theme.of(context).backgroundColor.red *
                                            1.5)
                                        .round(),
                                    (Theme.of(context).backgroundColor.green *
                                            1.5)
                                        .round(),
                                    (Theme.of(context).backgroundColor.blue *
                                            1.5)
                                        .round(),
                                  )
                                : Color.fromARGB(
                                    Theme.of(context).backgroundColor.alpha,
                                    (Theme.of(context).backgroundColor.red *
                                            0.99)
                                        .round(),
                                    (Theme.of(context).backgroundColor.green *
                                            0.99)
                                        .round(),
                                    (Theme.of(context).backgroundColor.blue *
                                            0.99)
                                        .round(),
                                  ),
                            boxShadow: [
                              BoxShadow(
                                blurRadius: 5.0,
                                color: Colors.black26,
                                offset: Offset(-1, 5),
                              )
                            ],
                          ),
                          child: Material(
                            child: InkWell(
                              onTap: () {},
                              child: AnimatedPadding(
                                duration: Duration(milliseconds: 300),
                                padding: EdgeInsets.only(
                                  top: 15,
                                  bottom: 15,
                                  left: isIconTransitionHappend ? 15 : 0,
                                  right: 15,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    // Icon, Name & Time
                                    Container(
                                      child: Row(
                                        children: <Widget>[
                                          // Icon
                                          FadeTransition(
                                            opacity: _iconTransitionAnim,
                                            child: AnimatedContainer(
                                              duration:
                                                  Duration(milliseconds: 300),
                                              width: 30,
                                              height: 30,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                                color: hasReminder
                                                    ? Theme.of(context)
                                                        .primaryColor
                                                    : Theme.of(context)
                                                        .disabledColor,
                                              ),
                                              child: Center(
                                                child: Text(
                                                  'h',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 24,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),

                                          AnimatedPadding(
                                            duration:
                                                Duration(milliseconds: 300),
                                            padding: EdgeInsets.only(
                                              left: isNameTransitionHappend
                                                  ? 10
                                                  : 0,
                                            ),
                                          ),

                                          // Name
                                          FadeTransition(
                                            opacity: _nameTransitionAnim,
                                            child: AnimatedDefaultTextStyle(
                                              duration:
                                                  Duration(milliseconds: 300),
                                              child: Text(
                                                "HABIT+",
                                              ),
                                              style: hasReminder
                                                  ? TextStyle(
                                                      fontSize: 18,
                                                      color: Theme.of(context)
                                                          .textSelectionHandleColor,
                                                    )
                                                  : TextStyle(
                                                      fontSize: 18,
                                                      color: Theme.of(context)
                                                          .disabledColor,
                                                    ),
                                            ),
                                          ),

                                          // Time
                                          Expanded(
                                            child: FadeTransition(
                                              opacity: _nameTransitionAnim,
                                              child: Align(
                                                alignment:
                                                    Alignment.centerRight,
                                                child: AnimatedDefaultTextStyle(
                                                  duration: Duration(
                                                      milliseconds: 300),
                                                  child: Text(
                                                    AppLocalizations.of(context)
                                                        .translate('push_time'),
                                                  ),
                                                  style: hasReminder
                                                      ? TextStyle(
                                                          color: Theme.of(
                                                                  context)
                                                              .textSelectionHandleColor,
                                                        )
                                                      : TextStyle(
                                                          color: Theme.of(
                                                                  context)
                                                              .disabledColor,
                                                        ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: 3),

                                    // Title
                                    FadeTransition(
                                      opacity: _nameTransitionAnim,
                                      child: AnimatedOpacity(
                                        duration: Duration(milliseconds: 300),
                                        opacity: hasReminder ? 1 : 0.5,
                                        child: RichText(
                                          textAlign: TextAlign.center,
                                          text: TextSpan(children: [
                                            TextSpan(
                                              text: widget.title,
                                              style: TextStyle(
                                                color: Theme.of(context)
                                                    .textSelectionHandleColor,
                                                fontSize: 18,
                                              ),
                                            ),
                                            TextSpan(
                                              text: ' · ',
                                              style: TextStyle(
                                                color: Theme.of(context)
                                                    .textSelectionHandleColor,
                                                fontSize: 18,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            TextSpan(
                                              text:
                                                  '${widget.duration[0].difference(widget.duration[1]).inDays.abs() == 0 ? 0 : widget.duration[0].difference(widget.duration[1]).inDays.abs() - 1}/${widget.duration[0].difference(widget.duration[1]).inDays.abs() + 1}',
                                              style: TextStyle(
                                                color: Theme.of(context)
                                                    .textSelectionColor,
                                                fontSize: 16,
                                              ),
                                            ),
                                          ]),
                                        ),
                                      ),
                                    ),

                                    // Time
                                    FadeTransition(
                                      opacity: _nameTransitionAnim,
                                      child: AnimatedOpacity(
                                        duration: Duration(milliseconds: 300),
                                        opacity: hasReminder ? 1 : 0.5,
                                        child: Text(
                                          time == null
                                              ? AppLocalizations.of(context)
                                                  .translate('push_today_at')
                                              : time ==
                                                      dateFormater.parse(
                                                          DateTime.now()
                                                              .toString())
                                                  ? '${AppLocalizations.of(context).translate('push_today_at_template')}${time.hour}:${time.minute}'
                                                  : '${time.day} ${AppLocalizations.of(context).translate(monthNames[time.month] + '_')} ${time.hour}:${time.minute}',
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 10),

                      // Desc
                      FadeTransition(
                        opacity: _descTransAnim,
                        child: descText(context, 'push_desc'),
                      ),
                      SizedBox(height: 15),

                      // Turn on / off
                      FadeTransition(
                        opacity: _switchTransAnim,
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 15),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                AppLocalizations.of(context)
                                    .translate('push_notification'),
                                style: TextStyle(
                                  color: Theme.of(context).textSelectionColor,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 20,
                                ),
                              ),
                              Switch(
                                value: hasReminder,
                                onChanged: (bool val) {
                                  setState(() {
                                    hasReminder = val;
                                  });
                                },
                                activeColor: Theme.of(context).primaryColor,
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Time picker
                      FadeTransition(
                        opacity: _timePickerTransAnim,
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 15),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              AnimatedDefaultTextStyle(
                                duration: Duration(milliseconds: 300),
                                style: hasReminder
                                    ? TextStyle(
                                        color: Theme.of(context)
                                            .textSelectionColor,
                                        fontSize: 18,
                                      )
                                    : TextStyle(
                                        color: Theme.of(context).disabledColor,
                                        fontSize: 18,
                                      ),
                                child: Text(
                                  AppLocalizations.of(context)
                                      .translate('time'),
                                ),
                              ),
                              GestureDetector(
                                onTap: () async {
                                  TimeOfDay _dayTime = await showTimePicker(
                                    context: context,
                                    initialTime: dayTime ?? TimeOfDay.now(),
                                  );
                                  setState(() {
                                    dayTime = _dayTime;
                                  });
                                },
                                child: Row(
                                  children: <Widget>[
                                    AnimatedDefaultTextStyle(
                                      duration: Duration(milliseconds: 300),
                                      child: Text(dayTime != null
                                          ? '${dayTime.hour}:${dayTime.minute}'
                                          : '12:00'),
                                      style: hasReminder
                                          ? TextStyle(
                                              color: Theme.of(context)
                                                  .textSelectionColor,
                                              fontSize: 16,
                                            )
                                          : TextStyle(
                                              color: Theme.of(context)
                                                  .disabledColor,
                                              fontSize: 16,
                                            ),
                                    ),
                                    SizedBox(width: 7),
                                    Icon(
                                      Icons.chevron_right,
                                      color: hasReminder
                                          ? Theme.of(context).textSelectionColor
                                          : Theme.of(context).disabledColor,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 20),

                      // Confirm
                      FadeTransition(
                        opacity: _confirmButtonTransAnim,
                        child: ConfirmButton(
                          onPress: () async {
                            if (widget.habitType == HabitType.Uncountable &&
                                goalAmount == null) {
                              goalAmount = widget.duration[0]
                                      .difference(widget.duration[1])
                                      .inDays
                                      .abs() +
                                  1;
                            } else if (widget.habitType ==
                                    HabitType.Countable &&
                                goalAmount == null) {
                              showModalBottomSheet(
                                context: context,
                                builder: (_) => GoalAmountBottomSheet(
                                  onSave: (int value) {
                                    if (value > 0) {
                                      goalAmount = value;
                                    }
                                  },
                                ),
                              );
                              return null;
                            }

                            Habit habit = Habit(
                              almostDone: 0,
                              countableProgress: {},
                              description: widget.desc,
                              duration: widget.duration,
                              goalAmount: goalAmount,
                              hasReminder: hasReminder,
                              iconCode: widget.iconCode,
                              isDisable: false,
                              progressBin: [],
                              repeatDays: widget.progressBin,
                              timeOfDay: dayTime,
                              timeStamp: DateTime.now(),
                              title: widget.title,
                              type: widget.habitType,
                              comments: [],
                            );
                            String userId =
                                Provider.of<UserData>(context, listen: false)
                                    .currentUserId;

                            bool dbCode = await model.createHabit(
                              habit,
                              userId,
                            );
                            if (dbCode) {
                              // plan notifications
                              await locator<NotificationServices>()
                                  .createNotifications(
                                context,
                                habit,
                              );

                              Navigator.pushNamed(context, '/');
                              return null;
                            }

                            _scaffoldKey.currentState.showSnackBar(
                              SnackBar(
                                content: Text(
                                  AppLocalizations.of(context)
                                      .translate('error_user_doent_exists'),
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                                backgroundColor: Colors.redAccent,
                              ),
                            );
                          },
                          stringPath: 'finish',
                        ),
                      ),
                      SizedBox(height: 15),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
