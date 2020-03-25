import 'package:flutter/material.dart';
import 'package:habits_plus/core/enums/habitType.dart';
import 'package:habits_plus/core/enums/viewstate.dart';
import 'package:habits_plus/core/models/habit.dart';
import 'package:habits_plus/core/models/userData.dart';
import 'package:habits_plus/core/services/database.dart';
import 'package:habits_plus/core/util/constant.dart';
import 'package:habits_plus/core/viewmodels/create_model.dart';
import 'package:habits_plus/ui/widgets/chooseIcon_create.dart';
import 'package:habits_plus/ui/widgets/duration_create.dart';
import 'package:habits_plus/ui/widgets/textField_create.dart';
import 'package:provider/provider.dart';

import '../../localization.dart';
import '../../locator.dart';

class HabitViewOnCreatePage extends StatefulWidget {
  @override
  _HabitVieOnnCreatePageState createState() => _HabitVieOnnCreatePageState();
}

class _HabitVieOnnCreatePageState extends State<HabitViewOnCreatePage> {
  // Form
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _title = '';
  String _description = '';
  int _goalAmount;
  int currentIconIndex = 0;
  String currentDurationIndex = 'Week';
  DateTime fromDateDuration;
  DateTime toDateDuration;
  List<String> _days = [];
  List<bool> _enabledDays = [false, false, false, false, false, false, false];
  bool isEveryDay = true;
  bool isNums = false;
  bool hasReminder = false;
  TimeOfDay timeRemind;
  DateTime date;
  String timesADay = '1';

  @override
  void initState() {
    super.initState();
    // currentDurationIndex = AppLocalizations.of(context).translate('month');
  }

  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  String _validator(String value) => value.trim() == ''
      ? AppLocalizations.of(context).translate('createHabit_title_error')
      : null;

  Widget _buildDayBox(String name, bool isEnable, int i) {
    int elemInRow =
        ((MediaQuery.of(context).size.width - 56) / (45 + 6)).floor();
    elemInRow = elemInRow == 7 ? 8 : elemInRow;

    return GestureDetector(
      onTap: () {
        setState(() {
          _enabledDays[i] = !_enabledDays[i];
          if (_enabledDays.contains(true)) {
            isEveryDay = false;
          } else {
            isEveryDay = true;
          }
        });
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 150),
        margin: EdgeInsets.only(
          left: i == 0 || i == elemInRow ? 0 : 3,
          right: 3,
          top: 3,
          bottom: 3,
        ),
        width: 45,
        height: 45,
        decoration: BoxDecoration(
          color: isEnable && !isEveryDay
              ? Theme.of(context).primaryColor
              : Theme.of(context).disabledColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Text(
            name,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }

  CreateViewModel _model = locator<CreateViewModel>();

  @override
  Widget build(BuildContext context) {
    if (mounted) {
      setState(() {
        _days = AppLocalizations.of(context).translate('createHabit_days');
      });
    }

    return ChangeNotifierProvider<CreateViewModel>.value(
      value: _model,
      child: Consumer<CreateViewModel>(
        builder: (_, CreateViewModel model, child) {
          return Scaffold(
            backgroundColor: Theme.of(context).backgroundColor,
            key: _scaffoldKey,
            body: Form(
              key: _formKey,
              child: Stack(
                children: <Widget>[
                  Positioned(
                    left: 0,
                    right: 0,
                    top: 0,
                    bottom: 0,
                    child: Center(
                      child: model.state == ViewState.Busy
                          ? CircularProgressIndicator(
                              backgroundColor: Theme.of(context)
                                  .primaryColor
                                  .withOpacity(0.05),
                            )
                          : null,
                    ),
                  ),
                  Opacity(
                    opacity: model.state == ViewState.Busy ? 0.5 : 1,
                    child: SingleChildScrollView(
                      child: Column(
                        children: <Widget>[
                          // Icon Picker
                          ChooseIconOnCreatePage(
                            currentIconIndex: currentIconIndex,
                            onIconPressed: (int i) {
                              setState(() {
                                currentIconIndex = i;
                              });
                            },
                          ),

                          // Title
                          TextFieldOnCreatePage(
                            labelText: 'createHabit_title',
                            onSaved: (String value) => _title = value,
                            validator: _validator,
                          ),
                          SizedBox(height: 20),

                          // Description
                          TextFieldOnCreatePage(
                            labelText: 'createHabit_description',
                            onSaved: (String value) => _description = value,
                            validator: null,
                          ),
                          SizedBox(height: 25),

                          // Color picker

                          //Days
                          Container(
                            width: double.infinity,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  AppLocalizations.of(context)
                                      .translate('createHabit_calendar'),
                                  style: TextStyle(
                                    color: Theme.of(context)
                                        .textSelectionHandleColor,
                                    fontSize: 18,
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () => setState(
                                    () => isEveryDay = !isEveryDay,
                                  ),
                                  child: Text(
                                    AppLocalizations.of(context).translate(
                                      'createHabit_everyday',
                                    ),
                                    style: TextStyle(
                                      color: isEveryDay
                                          ? Theme.of(context).primaryColor
                                          : Theme.of(context).disabledColor,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 10),
                          Container(
                            width: MediaQuery.of(context).size.width,
                            child: Wrap(
                              alignment: WrapAlignment.spaceBetween,
                              children: List.generate(
                                _days.length,
                                (int i) =>
                                    _buildDayBox(_days[i], _enabledDays[i], i),
                              ),
                            ),
                          ),
                          SizedBox(height: 10),

                          DurationOnCreatePage(
                            onItemPressed: (String val) {
                              setState(
                                () => currentDurationIndex = val,
                              );
                            },
                            initCurrentIndexValue:
                                AppLocalizations.of(context).translate('month'),
                            submitCustom:
                                (DateTime _fromDate, DateTime _toDate) {
                              setState(() {
                                fromDateDuration = _fromDate;
                                toDateDuration = _toDate;
                                currentDurationIndex = 'custom';
                              });
                            },
                          ),

                          // Amount
                          Text(
                            AppLocalizations.of(context)
                                .translate('createHabit_amount'),
                            style: TextStyle(
                              color: Theme.of(context).textSelectionHandleColor,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: 20),
                          Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: <Widget>[
                                // Countable
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      isNums = false;
                                    });
                                  },
                                  child: AnimatedContainer(
                                    duration: Duration(milliseconds: 250),
                                    width: 150,
                                    height: 150,
                                    padding: EdgeInsets.all(15),
                                    decoration: BoxDecoration(
                                      color: !isNums
                                          ? Theme.of(context).primaryColor
                                          : Theme.of(context)
                                              .disabledColor
                                              .withOpacity(0.4),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: <Widget>[
                                        Text(
                                          AppLocalizations.of(context).translate(
                                              'createHabit_yes_or_no_title'),
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 22,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        SizedBox(height: 10),
                                        Text(
                                          AppLocalizations.of(context).translate(
                                              'createHabit_yes_or_no_subtitle'),
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),

                                // Countable
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      isNums = true;
                                    });
                                  },
                                  child: AnimatedContainer(
                                    duration: Duration(milliseconds: 250),
                                    width: 150,
                                    height: 150,
                                    padding: EdgeInsets.all(15),
                                    decoration: BoxDecoration(
                                      color: isNums
                                          ? Theme.of(context).primaryColor
                                          : Theme.of(context)
                                              .disabledColor
                                              .withOpacity(0.4),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: <Widget>[
                                        Text(
                                          AppLocalizations.of(context)
                                              .translate(
                                                  'createHabit_number_title'),
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 22,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        SizedBox(height: 10),
                                        Text(
                                          AppLocalizations.of(context).translate(
                                              'createHabit_number_subtitle'),
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 25),

                          // Reminder
                          Container(
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: () async {
                                  TimeOfDay _time =
                                      timeRemind = await showTimePicker(
                                    context: context,
                                    initialTime: timeRemind == null
                                        ? TimeOfDay.now()
                                        : timeRemind,
                                  );
                                  setState(() {
                                    timeRemind = _time;
                                  });
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(vertical: 10),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Container(
                                        child: Row(
                                          children: <Widget>[
                                            Icon(
                                              Icons.timelapse,
                                              size: 24,
                                              color: timeRemind != null
                                                  ? Theme.of(context)
                                                      .textSelectionColor
                                                  : Theme.of(context)
                                                      .disabledColor,
                                            ),
                                            SizedBox(width: 10),
                                            Text(
                                              timeRemind == null
                                                  ? AppLocalizations.of(context)
                                                      .translate(
                                                          'createHabit_reminder_button')
                                                  : timeRemind.format(context),
                                              style: TextStyle(
                                                fontSize: 18,
                                                color: timeRemind != null
                                                    ? Theme.of(context)
                                                        .textSelectionHandleColor
                                                    : Theme.of(context)
                                                        .disabledColor,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Icon(
                                        Icons.navigate_next,
                                        size: 24,
                                        color: timeRemind != null
                                            ? Theme.of(context)
                                                .textSelectionColor
                                            : Theme.of(context).disabledColor,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 7),
                          Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Container(
                                  child: Row(
                                    children: <Widget>[
                                      DropdownButton(
                                        value: timesADay,
                                        items: <String>[
                                          '1',
                                          '2',
                                          '3',
                                          '4',
                                          '5',
                                          '6',
                                          '7',
                                          '8',
                                          '9'
                                        ].map<DropdownMenuItem<String>>(
                                            (String value) {
                                          return DropdownMenuItem<String>(
                                            value: value.toString(),
                                            child: Text(value.toString()),
                                          );
                                        }).toList(),
                                        iconSize: 24,
                                        elevation: 16,
                                        style: TextStyle(
                                          color: Colors.deepPurple,
                                          fontSize: 16,
                                        ),
                                        disabledHint: Text(
                                          timesADay,
                                          style: TextStyle(
                                            fontSize: 16,
                                          ),
                                        ),
                                        onChanged: hasReminder
                                            ? (String newValue) {
                                                setState(() {
                                                  timesADay = newValue;
                                                });
                                              }
                                            : null,
                                      ),
                                      SizedBox(width: 15),
                                      Text(
                                        AppLocalizations.of(context).translate(
                                            'createHabit_reminder_time'),
                                        style: TextStyle(
                                          color: hasReminder
                                              ? Theme.of(context)
                                                  .textSelectionHandleColor
                                              : Theme.of(context)
                                                  .textSelectionColor,
                                          fontSize: 18,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Switch(
                                  value: hasReminder,
                                  onChanged: (value) {
                                    setState(() {
                                      hasReminder = value;
                                    });
                                  },
                                  activeTrackColor: Theme.of(context)
                                      .primaryColor
                                      .withOpacity(0.3),
                                  activeColor: Theme.of(context).primaryColor,
                                ),
                              ],
                            ),
                          ),

                          // Submit
                          SizedBox(height: 5),
                          Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                GestureDetector(
                                  onTap: () => Navigator.pop(context),
                                  child: Text(
                                    AppLocalizations.of(context)
                                        .translate('cancel'),
                                    style: TextStyle(
                                      color: Theme.of(context)
                                          .textSelectionHandleColor,
                                      fontSize: 24,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.symmetric(),
                                  width:
                                      AppLocalizations.of(context).lang == 'ru'
                                          ? 125
                                          : 90,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).primaryColor,
                                    borderRadius: BorderRadius.circular(100),
                                  ),
                                  child: Material(
                                    color: Colors.transparent,
                                    borderRadius: BorderRadius.circular(100),
                                    child: InkWell(
                                      borderRadius: BorderRadius.circular(100),
                                      onTap: () async {
                                        if (_formKey.currentState.validate()) {
                                          _formKey.currentState.save();

                                          List<DateTime> _duration = [];
                                          DateTime today = dateFormater
                                              .parse(DateTime.now().toString());
                                          String week =
                                              AppLocalizations.of(context)
                                                  .translate('week');
                                          String month =
                                              AppLocalizations.of(context)
                                                  .translate('month');

                                          String day_21 =
                                              AppLocalizations.of(context)
                                                  .translate('21_day');
                                          String day_66 =
                                              AppLocalizations.of(context)
                                                  .translate('66_day');
                                          String month_3 =
                                              AppLocalizations.of(context)
                                                  .translate('3_month');
                                          String year =
                                              AppLocalizations.of(context)
                                                  .translate('year');
                                          String always =
                                              AppLocalizations.of(context)
                                                  .translate('always');

                                          if (currentDurationIndex == week) {
                                            _duration.add(today);
                                            _duration.add(
                                              today.add(
                                                Duration(days: 7),
                                              ),
                                            );
                                          } else if (currentDurationIndex ==
                                              month) {
                                            _duration.add(today);
                                            _duration.add(
                                              today.add(
                                                Duration(days: 30),
                                              ),
                                            );
                                          } else if (currentDurationIndex ==
                                              day_21) {
                                            _duration.add(today);
                                            _duration.add(
                                              today.add(
                                                Duration(days: 21),
                                              ),
                                            );
                                          } else if (currentDurationIndex ==
                                              day_66) {
                                            _duration.add(today);
                                            _duration.add(
                                              today.add(
                                                Duration(days: 66),
                                              ),
                                            );
                                          } else if (currentDurationIndex ==
                                              month_3) {
                                            _duration.add(today);
                                            _duration.add(
                                              today.add(
                                                Duration(days: 90),
                                              ),
                                            );
                                          } else if (currentDurationIndex ==
                                              year) {
                                            _duration.add(today);
                                            _duration.add(
                                              today.add(
                                                Duration(days: 365),
                                              ),
                                            );
                                          } else if (currentDurationIndex ==
                                              always) {
                                            _duration.add(
                                              habitDurationMarkDate,
                                            );
                                            _duration.add(
                                              habitDurationMarkDate,
                                            );
                                          } else if (currentDurationIndex ==
                                              'custom') {
                                            _duration.add(fromDateDuration);
                                            _duration.add(toDateDuration);
                                          }
                                          print(currentDurationIndex);
                                          print('_duration = $_duration');

                                          // Create new habit
                                          Habit habit = Habit(
                                            description: _description,
                                            hasReminder: hasReminder,
                                            isDisable: false,
                                            repeatDays: isEveryDay
                                                ? [
                                                    true,
                                                    true,
                                                    true,
                                                    true,
                                                    true,
                                                    true,
                                                    true
                                                  ]
                                                : _enabledDays,
                                            timeOfDay: timeRemind,
                                            timesADay: int.parse(timesADay),
                                            timeStamp: DateTime.now(),
                                            duration: _duration,
                                            title: _title,
                                            type: isNums
                                                ? HabitType.Countable
                                                : HabitType.Uncountable,
                                            progressBin: <DateTime>[],
                                            almostDone: 0,
                                            goalAmount: 100,
                                            iconCode: currentIconIndex,
                                          );
                                          String userId = Provider.of<UserData>(
                                            context,
                                            listen: false,
                                          ).currentUserId;

                                          String _timeRemindLocal = '';

                                          if (timeRemind != null &&
                                              hasReminder) {
                                            _timeRemindLocal =
                                                timeRemind.format(context);
                                          }

                                          bool dbcode = await model.createHabit(
                                            habit,
                                            userId,
                                            _timeRemindLocal,
                                          );

                                          if (!dbcode) {
                                            _scaffoldKey.currentState
                                                .showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                  AppLocalizations.of(context)
                                                      .translate(
                                                    'error_user_doent_exists',
                                                  ),
                                                ),
                                                backgroundColor:
                                                    Colors.redAccent,
                                              ),
                                            );
                                          } else {
                                            Navigator.pop(context);
                                          }
                                        }
                                      },
                                      splashColor: Colors.white12,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          Icon(
                                            Icons.add,
                                            color: Colors.white,
                                            size: 20,
                                          ),
                                          SizedBox(width: 4),
                                          Text(
                                            AppLocalizations.of(context)
                                                .translate('add'),
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 10),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
