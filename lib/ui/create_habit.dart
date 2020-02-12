import 'package:date_util/date_util.dart';
import 'package:flutter/material.dart';
import 'package:habits_plus/localization.dart';
import 'package:habits_plus/models/habit.dart';
import 'package:habits_plus/models/userData.dart';
import 'package:habits_plus/services/database.dart';
import 'package:habits_plus/util/constant.dart';
import 'package:provider/provider.dart';

class CreateHabitPage extends StatefulWidget {
  static final String id = 'createHabit_page';

  @override
  _CreateHabitPageState createState() => _CreateHabitPageState();
}

class _CreateHabitPageState extends State<CreateHabitPage> {
  // Services
  int _currentPage = 1; // 0 - Tasks, 1 - Habit
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // Form
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _title = '';
  String _description = '';
  int currentColorIndex = 0;
  List<String> _days = [];
  List<bool> _enabledDays = [false, false, false, false, false, false, false];
  bool isEveryDay = true;
  bool isNums = false;
  bool hasReminder = false;
  TimeOfDay timeRemind;
  String timesADay = '1';

  Widget _buildTaskPage() {
    return Text('task');
  }

  _submitHabit() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();

      // Create new habit
      Habit habit = Habit(
        colorCode: currentColorIndex,
        description: _description,
        hasReminder: hasReminder,
        isDisable: false,
        repeatDays: isEveryDay
            ? [true, true, true, true, true, true, true]
            : _enabledDays,
        timeOfDay: timeRemind,
        timesADay: int.parse(timesADay),
        timeStamp: DateTime.now(),
        title: _title,
        type: isNums ? 1 : 0,
      );

      String _timeRemindLocal = '';

      if (timeRemind != null && hasReminder) {
        _timeRemindLocal = timeRemind.format(context);
      }

      if (!await DatabaseServices.createHabit(
        habit,
        Provider.of<UserData>(context, listen: false).currentUserId,
        _timeRemindLocal,
      )) {
        _scaffoldKey.currentState.showSnackBar(
          SnackBar(
            content: Text(
              AppLocalizations.of(context).translate('error_user_doent_exists'),
            ),
            backgroundColor: Colors.redAccent,
          ),
        );
      } else {
        Navigator.pop(context);
      }
    }
  }

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

  Widget _buildChooseTimeButton() {
    return AnimatedContainer(
      duration: Duration(milliseconds: 200),
      height: 45,
      width: AppLocalizations.of(context).lang == 'ru' ? 150 : 135,
      decoration: BoxDecoration(
        color: hasReminder
            ? Theme.of(context).primaryColor.withOpacity(0.85)
            : Theme.of(context).disabledColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Material(
        borderRadius: BorderRadius.circular(10),
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: () async {
            if (hasReminder) {
              TimeOfDay time = await showTimePicker(
                context: context,
                initialTime: TimeOfDay.fromDateTime(
                  DateTime.now(),
                ),
              );
              setState(() {
                timeRemind = time;
              });
            }
          },
          child: Center(
            child: Text(
              AppLocalizations.of(context)
                  .translate('createHabit_reminder_button'),
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildColorBox(int i) {
    double size =
        (MediaQuery.of(context).size.width - 28 - (colors.length * 10)) /
            colors.length;
    return GestureDetector(
      onTap: () {
        setState(() {
          currentColorIndex = i;
        });
      },
      child: AnimatedContainer(
        width: size,
        height: size,
        duration: Duration(milliseconds: 250),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            width: currentColorIndex == i ? 1.5 : 0,
            color: currentColorIndex == i
                ? colors[i]
                : Theme.of(context).backgroundColor,
          ),
        ),
        child: Center(
          child: Container(
            padding: EdgeInsets.all(3),
            width: size - 7,
            height: size - 7,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: colors[i],
            ),
            child: AnimatedOpacity(
              opacity: currentColorIndex == i ? 1 : 0,
              duration: Duration(milliseconds: 250),
              child: Icon(
                Icons.done,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHabitPage() {
    if (mounted) {
      setState(() {
        _days = AppLocalizations.of(context).translate('createHabit_days');
      });
    }

    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          // Title
          TextFormField(
            style: TextStyle(
              fontSize: 18,
            ),
            decoration: InputDecoration(
              labelText:
                  AppLocalizations.of(context).translate('createHabit_title'),
              labelStyle: TextStyle(
                fontSize: 18,
              ),
              // enabledBorder: OutlineInputBorder(
              //   borderSide: BorderSide(color: Colors.black26, width: 1),
              //   borderRadius: BorderRadius.circular(10),
              // ),
              // border: OutlineInputBorder(
              //   borderRadius: BorderRadius.circular(10),
              // ),
            ),
            validator: (String value) =>
                value.trim() == '' ? 'Please, enter title' : null,
            onSaved: (String value) {
              setState(() {
                _title = value;
              });
            },
          ),
          SizedBox(height: 20),

          // Description
          TextFormField(
            keyboardType: TextInputType.multiline,
            style: TextStyle(
              fontSize: 18,
            ),
            decoration: InputDecoration(
              labelText: AppLocalizations.of(context)
                  .translate('createHabit_description'),
              labelStyle: TextStyle(
                fontSize: 18,
              ),
              // enabledBorder: OutlineInputBorder(
              //   borderSide: BorderSide(color: Colors.black26, width: 1),
              //   borderRadius: BorderRadius.circular(10),
              // ),
              // border: OutlineInputBorder(
              //   borderRadius: BorderRadius.circular(10),
              // ),
            ),
            validator: (String value) =>
                value.trim() == '' ? 'Please, enter description' : null,
            onSaved: (String value) {
              setState(() {
                _description = value;
              });
            },
          ),
          SizedBox(height: 20),

          // Color picker
          Container(
            height: 50,
            width: MediaQuery.of(context).size.width - 56,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(
                colors.length,
                (int i) => _buildColorBox(i),
              ),
            ),
          ),
          SizedBox(height: 10),

          // Days
          Container(
            child: Row(
              children: <Widget>[
                Icon(
                  Icons.calendar_today,
                  color: Theme.of(context).textSelectionColor,
                ),
                SizedBox(width: 7),
                Text(
                  AppLocalizations.of(context)
                      .translate('createHabit_calendar'),
                  style: TextStyle(
                    color: Theme.of(context).textSelectionHandleColor,
                    fontSize: 18,
                  ),
                )
              ],
            ),
          ),
          SizedBox(height: 10),
          Container(
            width: MediaQuery.of(context).size.width,
            child: Wrap(
              // alignment: WrapAlignment.start,
              children: List.generate(
                _days.length,
                (int i) => _buildDayBox(_days[i], _enabledDays[i], i),
              ),
            ),
          ),
          SizedBox(height: 10),
          GestureDetector(
            onTap: () {
              setState(() {
                isEveryDay = !isEveryDay;
                _enabledDays = [
                  false,
                  false,
                  false,
                  false,
                  false,
                  false,
                  false
                ];
              });
            },
            child: Container(
              child: Row(
                children: <Widget>[
                  // CheckBox
                  AnimatedContainer(
                    duration: Duration(milliseconds: 150),
                    padding: EdgeInsets.all(3),
                    width: 25,
                    height: 25,
                    decoration: BoxDecoration(
                      color: isEveryDay
                          ? Theme.of(context).primaryColor
                          : Theme.of(context).disabledColor,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: AnimatedOpacity(
                      duration: Duration(milliseconds: 100),
                      opacity: isEveryDay ? 1 : 0,
                      child: Icon(
                        Icons.done,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                  ),

                  SizedBox(width: 10),
                  Text(
                    AppLocalizations.of(context)
                        .translate('createHabit_everyday'),
                    style: TextStyle(
                      color: Theme.of(context).textSelectionHandleColor,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Amount
          SizedBox(height: 25),
          Text(
            AppLocalizations.of(context).translate('createHabit_amount'),
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
                          : Theme.of(context).disabledColor.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          AppLocalizations.of(context)
                              .translate('createHabit_yes_or_no_title'),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          AppLocalizations.of(context)
                              .translate('createHabit_yes_or_no_subtitle'),
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
                          : Theme.of(context).disabledColor.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          AppLocalizations.of(context)
                              .translate('createHabit_number_title'),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          AppLocalizations.of(context)
                              .translate('createHabit_number_subtitle'),
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
          GestureDetector(
            onTap: () {
              setState(() {
                hasReminder = !hasReminder;
              });
            },
            child: Container(
              child: Row(
                children: <Widget>[
                  // CheckBox
                  AnimatedContainer(
                    duration: Duration(milliseconds: 150),
                    padding: EdgeInsets.all(3),
                    width: 25,
                    height: 25,
                    decoration: BoxDecoration(
                      color: hasReminder
                          ? Theme.of(context).primaryColor
                          : Theme.of(context).disabledColor,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: AnimatedOpacity(
                      duration: Duration(milliseconds: 100),
                      opacity: hasReminder ? 1 : 0,
                      child: Icon(
                        Icons.done,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  Container(
                    child: Text(
                      AppLocalizations.of(context)
                          .translate('createHabit_reminder'),
                      style: TextStyle(
                        color: Theme.of(context).textSelectionHandleColor,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 7),
          Container(
            child: timeRemind == null
                ? Row(
                    children: <Widget>[
                      _buildChooseTimeButton(),
                    ],
                  )
                : Row(
                    children: <Widget>[
                      Container(
                        child: AnimatedDefaultTextStyle(
                          duration: Duration(milliseconds: 250),
                          child: Text(timeRemind.format(context)),
                          style: hasReminder
                              ? TextStyle(
                                  color: Theme.of(context).textSelectionColor,
                                  fontSize: 28,
                                )
                              : TextStyle(
                                  color: Theme.of(context).disabledColor,
                                  fontSize: 28,
                                ),
                        ),
                      ),
                      SizedBox(width: 25),
                      GestureDetector(
                        onTap: () {
                          if (hasReminder) {
                            setState(() {
                              timeRemind = null;
                            });
                          }
                        },
                        child: AnimatedDefaultTextStyle(
                          duration: Duration(milliseconds: 250),
                          child: Text(AppLocalizations.of(context)
                              .translate('createHabit_reminder_clear')),
                          style: hasReminder
                              ? TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontSize: 18,
                                )
                              : TextStyle(
                                  color: Theme.of(context).disabledColor,
                                  fontSize: 18,
                                ),
                        ),
                      ),
                    ],
                  ),
          ),
          SizedBox(height: 7),
          Container(
            child: Row(
              children: <Widget>[
                DropdownButton(
                  value: timesADay,
                  items: <String>['1', '2', '3', '4', '5', '6', '7', '8', '9']
                      .map<DropdownMenuItem<String>>((String value) {
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
                  AppLocalizations.of(context)
                      .translate('createHabit_reminder_time'),
                  style: TextStyle(
                    color: hasReminder
                        ? Theme.of(context).textSelectionHandleColor
                        : Theme.of(context).textSelectionColor,
                    fontSize: 18,
                  ),
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
                    AppLocalizations.of(context).translate('cancel'),
                    style: TextStyle(
                      color: Theme.of(context).textSelectionHandleColor,
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(),
                  width: AppLocalizations.of(context).lang == 'ru' ? 125 : 90,
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
                      onTap: _submitHabit,
                      splashColor: Colors.white12,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(
                            Icons.add,
                            color: Colors.white,
                            size: 20,
                          ),
                          SizedBox(width: 4),
                          Text(
                            AppLocalizations.of(context).translate('add'),
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: Theme.of(context).backgroundColor,
        body: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.only(left: 28, right: 28, top: 36),
              child: Column(
                children: <Widget>[
                  // Task/Habit
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        // Task
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _currentPage = 0;
                            });
                          },
                          child: Container(
                            height: 55,
                            child: Column(
                              children: <Widget>[
                                AnimatedDefaultTextStyle(
                                  style: _currentPage == 0
                                      ? TextStyle(
                                          fontSize: 24,
                                          color: Theme.of(context).primaryColor,
                                        )
                                      : TextStyle(
                                          fontSize: 24,
                                          color: Theme.of(context)
                                              .textSelectionColor,
                                        ),
                                  duration: Duration(milliseconds: 150),
                                  child: Text(AppLocalizations.of(context)
                                      .translate('createHabit_task')),
                                ),
                                SizedBox(height: 5),
                                AnimatedOpacity(
                                  duration: Duration(milliseconds: 150),
                                  opacity: _currentPage == 0 ? 1 : 0,
                                  child: Container(
                                    width: 7,
                                    height: 7,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Theme.of(context).primaryColor,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        SizedBox(width: 100),

                        // Habit
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _currentPage = 1;
                            });
                          },
                          child: Container(
                            height: 55,
                            child: Column(
                              children: <Widget>[
                                AnimatedDefaultTextStyle(
                                  style: _currentPage == 1
                                      ? TextStyle(
                                          fontSize: 24,
                                          color: Theme.of(context).primaryColor,
                                        )
                                      : TextStyle(
                                          fontSize: 24,
                                          color: Theme.of(context)
                                              .textSelectionColor,
                                        ),
                                  duration: Duration(milliseconds: 150),
                                  child: Text(AppLocalizations.of(context)
                                      .translate('createHabit_habit')),
                                ),
                                SizedBox(height: 5),
                                AnimatedOpacity(
                                  duration: Duration(milliseconds: 150),
                                  opacity: _currentPage == 1 ? 1 : 0,
                                  child: Container(
                                    width: 7,
                                    height: 7,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Theme.of(context).primaryColor,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  _currentPage == 0 ? _buildTaskPage() : _buildHabitPage(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
