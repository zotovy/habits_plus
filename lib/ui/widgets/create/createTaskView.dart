import 'package:flutter/material.dart';
import 'package:habits_plus/core/enums/viewstate.dart';
import 'package:habits_plus/core/models/task.dart';
import 'package:habits_plus/core/models/userData.dart';
import 'package:habits_plus/core/viewmodels/create_model.dart';
import 'package:habits_plus/locator.dart';
import 'package:habits_plus/ui/view/shell.dart';
import 'package:habits_plus/ui/widgets/create/single_picker_calendar.dart';
import 'package:habits_plus/ui/widgets/progress_bar.dart';
import 'package:habits_plus/ui/widgets/textField_create.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../localization.dart';

class CreateTask extends StatefulWidget {
  @override
  _CreateTaskState createState() => _CreateTaskState();
}

class _CreateTaskState extends State<CreateTask> {
  // Form
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _title = '';
  String _description = '';
  bool isEveryDay = true;
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  DateTime date;
  TimeOfDay timeRemind;
  bool hasReminder = false;

  // Validator function
  String _taskValidator(String value) => value.trim() == ''
      ? AppLocalizations.of(context).translate('createHabit_title_error')
      : null;

  // Model
  CreateViewModel _model = locator<CreateViewModel>();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<CreateViewModel>.value(
      value: _model,
      child: Consumer(
        builder: (_, CreateViewModel model, child) {
          return Scaffold(
            backgroundColor: Theme.of(context).backgroundColor,
            key: _scaffoldKey,
            body: Stack(
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
                  child: Form(
                    key: _formKey,
                    child: Container(
                      child: SingleChildScrollView(
                        child: Column(
                          children: <Widget>[
                            // Title
                            TextFieldOnCreatePage(
                              labelText: 'createHabit_title',
                              validator: _taskValidator,
                              onSaved: (String value) =>
                                  setState(() => _title = value),
                            ),
                            SizedBox(height: 20),

                            // Description
                            TextFieldOnCreatePage(
                              labelText: 'createHabit_description',
                              validator: null,
                              onSaved: (String value) =>
                                  setState(() => _description = value),
                            ),
                            SizedBox(height: 20),

//========================================================================================
/*                                                                                      *
 *                                       Calendar                                       *
 *                                                                                      */
//========================================================================================

                            // CalendarSinglePicker(
                            //   onDateSelected: (DateTime day) => date = day,
                            // ),
                            Container(
                              padding: EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: Theme.of(context).primaryColor,
                                  width: 2,
                                ),
                              ),
                              child: CalendarSinglePicker(
                                onDateSelected: (DateTime day) => date = day,
                              ),
                            ),
                            SizedBox(height: 25),

//========================================================================================
/*                                                                                      *
 *                                       Reminder                                       *
 *                                                                                      */
//========================================================================================

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
                                                color: !hasReminder
                                                    ? Theme.of(context)
                                                        .textSelectionColor
                                                    : Theme.of(context)
                                                        .disabledColor,
                                              ),
                                              SizedBox(width: 10),
                                              Text(
                                                timeRemind == null
                                                    ? AppLocalizations.of(
                                                            context)
                                                        .translate(
                                                            'createHabit_reminder_button')
                                                    : timeRemind
                                                        .format(context),
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  color: !hasReminder
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
                                          color: !hasReminder
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
                            SizedBox(height: 5),
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
                                            .translate('todos_reminder'),
                                        style: TextStyle(
                                          color: Theme.of(context)
                                              .textSelectionHandleColor,
                                          fontSize: 18,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),

//========================================================================================
/*                                                                                      *
 *                                        Submit                                        *
 *                                                                                      */
//========================================================================================

                            SizedBox(height: 20),
                            Container(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                                    width: AppLocalizations.of(context).lang ==
                                            'ru'
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
                                        borderRadius:
                                            BorderRadius.circular(100),
                                        onTap: () async {
                                          if (_formKey.currentState
                                              .validate()) {
                                            // Save title & desc form
                                            _formKey.currentState.save();

                                            // Check date != null and is not every day
                                            if (date == null && !isEveryDay) {
                                              // Show warning message
                                              _scaffoldKey.currentState
                                                  .showSnackBar(SnackBar(
                                                content: Text(
                                                  AppLocalizations.of(context)
                                                      .translate(
                                                          'todos_date_warning'),
                                                ),
                                              ));

                                              // Exit from function _submitTask
                                              return null;
                                            }

                                            // Create new Task obj and get user ID
                                            print(_title);
                                            print(_description);
                                            print(date);
                                            print(timeRemind);
                                            print(isEveryDay);

                                            Task task = Task(
                                              title: _title,
                                              description: _description,
                                              timestamp: DateTime
                                                  .now(), // Creation date
                                              date: date,
                                              time: timeRemind,
                                              hasTime: timeRemind != null,
                                              isEveryDay: isEveryDay,
                                              done: false,
                                            );
                                            String userId =
                                                Provider.of<UserData>(context,
                                                        listen: false)
                                                    .currentUserId;

                                            // Push data to DB
                                            bool dbCode =
                                                await model.createTask(task);

                                            // Check DataBase Code (dbCode)
                                            if (!dbCode) {
                                              // If operation has error -> make failed message
                                              _scaffoldKey.currentState
                                                  .showSnackBar(
                                                SnackBar(
                                                  behavior:
                                                      SnackBarBehavior.floating,
                                                  content: Text(
                                                    AppLocalizations.of(context)
                                                        .translate(
                                                      'error_user_doent_exists',
                                                    ),
                                                  ),
                                                ),
                                              );

                                              // Exit from function _submitTask
                                              return null;
                                            }

                                            // Return Navigator to home page
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (_) => MainShell(),
                                              ),
                                            );
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
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
