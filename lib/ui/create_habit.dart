import 'package:flutter/material.dart';

class CreateHabitPage extends StatefulWidget {
  static final String id = 'createHabit_page';

  @override
  _CreateHabitPageState createState() => _CreateHabitPageState();
}

class _CreateHabitPageState extends State<CreateHabitPage> {
  int _currentPage = 1; // 0 - Tasks, 1 - Habit

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: Container(
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
                                      color:
                                          Theme.of(context).textSelectionColor,
                                    ),
                              duration: Duration(milliseconds: 150),
                              child: Text('Task'),
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
                                      color:
                                          Theme.of(context).textSelectionColor,
                                    ),
                              duration: Duration(milliseconds: 150),
                              child: Text('Habit'),
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
            ],
          ),
        ),
      ),
    );
  }
}
