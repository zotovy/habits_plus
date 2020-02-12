import 'package:date_util/date_util.dart';
import 'package:flutter/material.dart';
import 'package:habits_plus/localization.dart';
import 'package:habits_plus/util/constant.dart';

class CreateHabitPage extends StatefulWidget {
  static final String id = 'createHabit_page';

  @override
  _CreateHabitPageState createState() => _CreateHabitPageState();
}

class _CreateHabitPageState extends State<CreateHabitPage> {
  // Services
  int _currentPage = 1; // 0 - Tasks, 1 - Habit

  // Form
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _title = '';
  String _description = '';
  // List<Color> colors = [
  //   Color.fromARGB(100, 0, 122, 255),
  //   Color.fromARGB(100, 90, 200, 250),
  //   Color.fromARGB(100, 52, 199, 89),
  //   Color.fromARGB(100, 88, 86, 214),
  //   Color.fromARGB(100, 255, 149, 0),
  //   Color.fromARGB(100, 255, 45, 85),
  //   Color.fromARGB(100, 175, 82, 222),
  //   Color.fromARGB(100, 255, 59, 48),
  //   Color.fromARGB(100, 255, 204, 0),
  // ];
  int currentColorIndex = 0;
  List<String> _days = [];
  List<bool> _enabledDays = [false, false, false, false, false, false, false];
  bool isEveryDay = true;
  bool isNums = false;
  bool hasReminder = false;
  TimeOfDay timeRemind;

  Widget _buildTaskPage() {
    return Text('task');
  }

  @override
  void initState() {
    super.initState();
  }

  Widget _buildDayBox(String name, bool isEnable, int i) {
    int elemInRow =
        ((MediaQuery.of(context).size.width - 56) / (45 + 6)).floor();
    elemInRow = elemInRow == 7 ? 8 : elemInRow;

    return GestureDetector(
      onTap: () {
        setState(() {
          _enabledDays[i] = !_enabledDays[i];
          isEveryDay = false;
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
      width: 135,
      decoration: BoxDecoration(
        color: hasReminder
            ? Theme.of(context).primaryColor.withOpacity(0.85)
            : Theme.of(context).disabledColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
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
              'Choose time',
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
                  'Calendar',
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
          SizedBox(height: 30),
          Text(
            'Amount',
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
                          'Yes or No',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Mark whether you completed the task today',
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
                          'Number',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Write down number in your habit',
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
          SizedBox(height: 30),

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
                      'Reminder',
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
                          child: Text('Clear'),
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
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: Container(
          padding: EdgeInsets.only(left: 28, right: 28, top: 36),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
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
