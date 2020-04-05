import 'package:date_util/date_util.dart';
import 'package:flutter/material.dart';
import 'package:habits_plus/core/util/habit_templates.dart';
import 'package:habits_plus/localization.dart';
import 'package:habits_plus/core/models/habit.dart';
import 'package:habits_plus/core/models/task.dart';
import 'package:habits_plus/core/models/userData.dart';
import 'package:habits_plus/core/services/database.dart';
import 'package:habits_plus/core/util/constant.dart';
import 'package:habits_plus/ui/widgets/create/templates.dart';
import 'package:habits_plus/ui/widgets/createHabitView.dart';
import 'package:habits_plus/ui/widgets/createTaskView.dart';
import 'package:habits_plus/ui/widgets/progress_bar.dart';
import 'package:habits_plus/ui/widgets/textField_create.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class CreateHabitPage extends StatefulWidget {
  @override
  _CreateHabitPageState createState() => _CreateHabitPageState();
}

class _CreateHabitPageState extends State<CreateHabitPage> {
  // Services
  int _currentPage = 1; // 0 - Tasks, 1 - Habit
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    setupHabitTemplates(context);
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        body: SafeArea(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 18),
            child: Stack(
              children: <Widget>[
                // Task/Habit
                Positioned(
                  top: 5,
                  left: 0,
                  right: 0,
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

                Padding(
                  padding: const EdgeInsets.only(top: 55),
                  child: _currentPage == 0
                      ? CreateTask()
                      : Column(
                          children: <Widget>[
                            // Create button
                            Container(
                              decoration: BoxDecoration(
                                color: Theme.of(context).primaryColor,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Material(
                                borderRadius: BorderRadius.circular(10),
                                child: InkWell(
                                  onTap: () => Navigator.pushNamed(
                                    context,
                                    'createHabit_1',
                                  ),
                                  child: Container(
                                    padding: EdgeInsets.all(15),
                                    child: Center(
                                      child: Text(
                                        AppLocalizations.of(context)
                                            .translate('create_habit'),
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

                            SizedBox(height: 35),

                            // Template
                            HabitTemplateWidget(),
                          ],
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
