import 'package:flutter/material.dart';
import 'package:habits_plus/localization.dart';
import 'package:habits_plus/models/task.dart';
import 'package:habits_plus/models/userData.dart';
import 'package:habits_plus/notifiers/task.dart';
import 'package:habits_plus/services/database.dart';
import 'package:provider/provider.dart';
import 'package:habits_plus/main.dart';

class TaskListView extends StatefulWidget {
  @override
  _TaskListViewState createState() => _TaskListViewState();
}

class _TaskListViewState extends State<TaskListView>
    with TickerProviderStateMixin {
  // Provider
  TaskData taskNotifier;

  // Tasks
  // List<Task> doneTasks = [];
  // List<Task> notDoneTasks = [];
  // bool hasDoneTasks = false;
  // bool hasNotDoneTasks = fыalse;

  // Animation
  GlobalKey<AnimatedListState> _keyDoneTask = GlobalKey<AnimatedListState>();
  GlobalKey<AnimatedListState> _keyNotDoneTask = GlobalKey<AnimatedListState>();
  List<AnimationController> doneAnimationController = [];
  List<AnimationController> notDoneAnimationController = [];

  @override
  void initState() {
    super.initState();

    // Init provider
    taskNotifier = Provider.of<TaskData>(context);

    /// Activate apperance animation
    _startDoneTaskAnimation();
    _startNotDoneTaskAnimation();
  }

  /// Start apperance animation, ONLY [doneAnimationController]
  /// Duration is [100] milliseconds
  _startDoneTaskAnimation() async {
    /// We need Future to wait, when [build] method is done
    Future.delayed(Duration(milliseconds: 100)).then(
      (value) async {
        for (var i = 0; i < doneTasks.length; i++) {
          _keyDoneTask.currentState.insertItem(i);
          await Future.delayed(Duration(milliseconds: 250));
        }
      },
    );
  }

  /// Start apperance animation, ONLY [notDoneAnimationController]
  /// Duration is [100] milliseconds
  _startNotDoneTaskAnimation() async {
    /// We need Future to wait, when [build] method is done
    Future.delayed(Duration(milliseconds: 100)).then(
      (value) async {
        for (var i = 0; i < notDoneTasks.length; i++) {
          _keyNotDoneTask.currentState.insertItem(i);
          await Future.delayed(Duration(milliseconds: 250));
        }
      },
    );
  }

  /// This function push new task in DB
  _updateTaskInDB(Task task) async {
    await DatabaseServices.updateTask(
        task, Provider.of<UserData>(context, listen: false).currentUserId);
  }

  /// This function delete task from DB
  _deleteTaskInDB(Task task) async {
    await DatabaseServices.deleteTask(
        task.id, Provider.of<UserData>(context, listen: false).currentUserId);
  }

  /// Build [text] for Task Tile
  /// Only for [done] tasks
  Widget _buildDoneText(bool isDone, String title, String desc) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // Title
            AnimatedDefaultTextStyle(
              duration: Duration(milliseconds: 200),
              style: !isDone
                  ? TextStyle(
                      color: Theme.of(context).disabledColor.withOpacity(0.5),
                      fontSize: 18,
                      decoration: TextDecoration.lineThrough,
                    )
                  : TextStyle(
                      color: Theme.of(context).textSelectionHandleColor,
                      fontSize: 18,
                    ),
              child: Text(
                title,
              ),
            ),

            // Padding
            SizedBox(height: 3),

            // Subtitle
            Text(
              desc,
              style: TextStyle(
                color: !isDone
                    ? Theme.of(context).disabledColor.withOpacity(0.5)
                    : Theme.of(context).textSelectionColor,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Build [text] for Task Tile
  /// Only for [NOT done] tasks
  Widget _buildNotDoneText(bool isDone, String title, String desc) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // Title
            AnimatedDefaultTextStyle(
              duration: Duration(milliseconds: 200),
              style: isDone
                  ? TextStyle(
                      color: Theme.of(context).textSelectionColor,
                      fontSize: 18,
                      decoration: TextDecoration.lineThrough,
                    )
                  : TextStyle(
                      color: Theme.of(context).textSelectionHandleColor,
                      fontSize: 18,
                    ),
              child: Text(title),
            ),

            // Padding
            SizedBox(height: 3),

            // Subtitle
            Text(
              desc,
              style: TextStyle(
                color: Theme.of(context).textSelectionColor,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Build [box-button] for Task Tile
  /// Only for [done] tasks
  Widget _buildDoneButton(bool isDone) {
    return GestureDetector(
      child: AnimatedContainer(
        width: 25,
        height: 25,
        duration: Duration(milliseconds: 550),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          border: Border.all(
            width: 2,
            color: Theme.of(context).primaryColor,
          ),
          color: !isDone ? Theme.of(context).primaryColor : Colors.transparent,
        ),
        child: Icon(
          Icons.done,
          color: Colors.white,
          size: 16,
        ),
      ),
    );
  }

  /// Build [box-button] for Task Tile
  /// Only for [NOT done] tasks
  Widget _buildNotDoneButton(bool isDone) {
    return AnimatedContainer(
      width: 25,
      height: 25,
      duration: Duration(milliseconds: 250),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        border: Border.all(
          width: 2,
          color: Theme.of(context).primaryColor,
        ),
        color: isDone ? Theme.of(context).primaryColor : Colors.transparent,
      ),
      child: Icon(
        Icons.done,
        color: Theme.of(context).backgroundColor,
        size: 16,
      ),
    );
  }

  Widget _buildDoneListTile(
      BuildContext context, int i, Animation<double> animation) {
    /// This local [AnimationController] will controll
    /// removing the item by [SlideAnimation]

    // Dismissible -> Slide -> Fade -> Size
    return Dismissible(
      onDismissed: (DismissDirection direction) {
        // Remove task action
        if (direction == DismissDirection.startToEnd) {
          // Start title disappearance animation
          if (doneTasks.length == 1) {
            setState(() {
              hasDoneTasks = false;
            });
          }

          // Remove dissimissble from the list
          _keyDoneTask.currentState.removeItem(
            i,
            (BuildContext context, Animation<double> animation) {
              return Container(
                height: animation.value - 1,
                color: Colors.redAccent,
              );
            },
          );

          // Delete task in database
          _deleteTaskInDB(doneTasks[i]);

          /// Remove extra [notDoneTasks]
          if (notDoneTasks.length == 1) {
            Future.delayed(Duration(milliseconds: 300)).then((_) {
              setState(() {
                doneTasks.removeAt(i);
              });
            });
          } else {
            setState(() {
              doneTasks.removeAt(i);
            });
          }
        }
        // Submit task active
        else if (direction == DismissDirection.endToStart) {
          // Start title disappearance animation
          if (doneTasks.length == 1) {
            setState(() {
              hasDoneTasks = false;
            });
          }

          // Remove dissimissble from the list
          _keyDoneTask.currentState.removeItem(
            i,
            (BuildContext context, Animation<double> animation) {
              return Container(
                height: animation.value - 0.75,
                color: Colors.redAccent,
              );
            },
          );

          setState(() {
            /// Add [DoneTask] to [notDoneTasks], remove extra notDoneTask and insert into [AnimatedList]
            notDoneTasks.add(doneTasks[i]);
            _keyNotDoneTask.currentState.insertItem(notDoneTasks.length - 1);
            hasNotDoneTasks = true;
            // notDoneTasks.removeAt(i);
          });

          // Update task in database
          setState(() {
            doneTasks[i].done = false;
          });
          _updateTaskInDB(doneTasks[i]);

          /// Remove extra [doneTasks]
          if (doneTasks.length == 1) {
            Future.delayed(Duration(milliseconds: 300)).then((_) {
              setState(() {
                doneTasks.removeAt(i);
              });
            });
          } else {
            setState(() {
              doneTasks.removeAt(i);
            });
          }
        }
      },
      background: Container(
        margin: EdgeInsets.symmetric(horizontal: 10),
        color: Colors.red,
      ),
      secondaryBackground: Container(
        color: Theme.of(context).primaryColor.withOpacity(0.1),
      ),
      key: ValueKey(doneTasks[i].title),
      child: Container(
        height: 60,
        child: SlideTransition(
          position: CurvedAnimation(
            curve: Curves.easeOut,
            parent: animation,
          ).drive(
            Tween<Offset>(
              begin: Offset(1, 0),
              end: Offset(0, 0),
            ),
          ),
          child: FadeTransition(
            opacity: animation,
            child: SizeTransition(
              sizeFactor: animation,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  _buildDoneText(
                    false,
                    doneTasks[i].title,
                    doneTasks[i].description,
                  ),
                  _buildDoneButton(false),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNotDoneListTile(
      BuildContext context, int i, Animation<double> animation) {
    /// This local [AnimationController] will controll
    /// removing the item by [SlideAnimation]

    // Dismissible -> Slide -> Fade -> Size
    return Dismissible(
      onDismissed: (DismissDirection direction) {
        // Remove task action
        if (direction == DismissDirection.startToEnd) {
          // Start title disappearance animation
          if (notDoneTasks.length == 1) {
            setState(() {
              hasNotDoneTasks = false;
            });
          }

          // Remove dissimissble from the list
          _keyNotDoneTask.currentState.removeItem(
            i,
            (BuildContext context, Animation<double> animation) {
              return Container(
                height: animation.value,
                color: Colors.redAccent,
              );
            },
          );

          // Delete task in database
          _deleteTaskInDB(notDoneTasks[i]);

          /// Remove extra [notDoneTasks] and [animationDoneInNotDoneTaskList]
          if (notDoneTasks.length == 1) {
            Future.delayed(Duration(milliseconds: 300)).then((_) {
              setState(() {
                notDoneTasks.removeAt(i);
              });
            });
          } else {
            setState(() {
              notDoneTasks.removeAt(i);
            });
          }
        }
        //* Submit task active
        else if (direction == DismissDirection.endToStart) {
          // Start title disappearance animation
          if (notDoneTasks.length == 1) {
            setState(() {
              hasNotDoneTasks = false;
            });
          }

          // Remove dissimissble from the list
          _keyNotDoneTask.currentState.removeItem(
            i,
            (BuildContext context, Animation<double> animation) {
              return Container(
                height: animation.value - 0.75,
                color: Colors.redAccent,
              );
            },
          );

          // Future.delayed(Duration(milliseconds: 0)).then((_) {
          setState(() {
            /// Add [notDoneTask] to [doneTasks], remove extra doneTask and insert into [AnimatedList]
            doneTasks.add(notDoneTasks[i]);
            _keyDoneTask.currentState.insertItem(doneTasks.length - 1);
            hasDoneTasks = true;
            // notDoneTasks.removeAt(i);
          });
          // });

          // Update task in database
          setState(() {
            notDoneTasks[i].done = true;
          });
          _updateTaskInDB(notDoneTasks[i]);

          /// Remove extra [notDoneTasks]
          if (notDoneTasks.length == 1) {
            Future.delayed(Duration(milliseconds: 300)).then((_) {
              setState(() {
                notDoneTasks.removeAt(i);
              });
            });
          } else {
            setState(() {
              notDoneTasks.removeAt(i);
            });
          }
        }
      },
      background: Container(
        color: Colors.red,
      ),
      secondaryBackground: Container(
        color: Theme.of(context).primaryColor.withOpacity(0.1),
      ),
      key: ValueKey(notDoneTasks[i].title),
      child: Container(
        height: 60,
        child: SlideTransition(
          position: CurvedAnimation(
            curve: Curves.easeOut,
            parent: animation,
          ).drive(
            Tween<Offset>(
              begin: Offset(1, 0),
              end: Offset(0, 0),
            ),
          ),
          child: FadeTransition(
            opacity: animation,
            child: SizeTransition(
              sizeFactor: animation,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  _buildNotDoneText(
                    false,
                    notDoneTasks[i].title,
                    notDoneTasks[i].description,
                  ),
                  _buildNotDoneButton(false),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  removeItemFromDoneList(int i) {
    // Remind done variables as local variables
    String title = doneTasks[i].title;
    String desc = doneTasks[i].description;

    // Update task in DB
    setState(() {
      doneTasks[i].done = false;
    });
    _updateTaskInDB(doneTasks[i]);

    Future.delayed(Duration(milliseconds: 200)).then(
      (_) {
        setState(() {
          if (doneTasks.length == 1) {
            hasDoneTasks = false;
          }
          Future.delayed(Duration(milliseconds: 300)).then((_) {
            setState(() {
              /// Add [notDoneTask] to [doneTasks], remove extra doneTask and insert into [AnimatedList]
              notDoneTasks.add(doneTasks[i]);
              _keyNotDoneTask.currentState.insertItem(notDoneTasks.length - 1);
              hasNotDoneTasks = true;
              doneTasks.removeAt(i);
            });
          });
        });
        _keyDoneTask.currentState.removeItem(
          i,
          (context, Animation<double> animation) {
            // Slide -> Fade -> Size
            return SlideTransition(
              position: CurvedAnimation(
                curve: Curves.easeOut,
                parent: animation,
              ).drive(
                Tween<Offset>(
                  begin: Offset(1, 0),
                  end: Offset.zero,
                ),
              ),
              child: FadeTransition(
                opacity: animation,
                child: SizeTransition(
                  sizeFactor: animation,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      _buildDoneText(true, title, desc),
                      _buildDoneButton(true),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  removeItemFromNotDoneList(int i) async {
    // Remind done variables as local variables
    String title = notDoneTasks[i].title;
    String desc = notDoneTasks[i].description;

    // setState(() {
    notDoneTasks[i].done = true;
    // });
    await _updateTaskInDB(notDoneTasks[i]);

    setState(() {
      if (notDoneTasks.length == 1) {
        hasNotDoneTasks = false;
      }
      hasDoneTasks = true;
    });

    Future.delayed(Duration(milliseconds: 200)).then(
      (_) {
        setState(() {
          doneTasks.add(notDoneTasks[i]);
          notDoneTasks.removeAt(i);
          Future.delayed(Duration(milliseconds: 300)).then((_) {
            setState(() {
              /// Add [notDoneTask] to [doneTasks], remove extra doneTask and insert into [AnimatedList]
              _keyDoneTask.currentState.insertItem(doneTasks.length - 1);
            });
          });
        });
        _keyNotDoneTask.currentState.removeItem(
          i,
          (context, Animation<double> animation) {
            // Slide -> Fade -> Size
            return SlideTransition(
              position: CurvedAnimation(
                curve: Curves.easeOut,
                parent: animation,
              ).drive(
                Tween<Offset>(
                  begin: Offset(1, 0),
                  end: Offset.zero,
                ),
              ),
              child: FadeTransition(
                opacity: animation,
                child: SizeTransition(
                  sizeFactor: animation,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      _buildDoneText(true, title, desc),
                      _buildDoneButton(true),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  /// First block of main widget
  Widget _buildDoneTaskList() {
    return AnimatedList(
      key: _keyDoneTask,
      initialItemCount: 0,
      itemBuilder:
          (BuildContext context, int index, Animation<double> animation) {
        return Material(
          color: Colors.transparent,
          child: InkWell(
            onLongPress: () => removeItemFromDoneList(index),
            child: _buildDoneListTile(context, index, animation),
          ),
        );
      },
    );
  }

  /// Second block of main widget
  Widget _buildNotDoneTaskList() {
    return AnimatedList(
      key: _keyNotDoneTask,
      initialItemCount: 0,
      itemBuilder:
          (BuildContext context, int index, Animation<double> animation) {
        return Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => removeItemFromNotDoneList(index),
            child: _buildNotDoneListTile(context, index, animation),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
//========================================================================================
/*                                                                                      *
 *                                    NOT DONE TASKS                                    *
 *                                                                                      */
//========================================================================================

          // Padding
          notDoneTasks.length > 0
              ? AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  height: hasNotDoneTasks ? 20 : 0,
                )
              : SizedBox.shrink(),

          // Title
          AnimatedOpacity(
            duration: Duration(milliseconds: 300),
            opacity: hasNotDoneTasks ? 1 : 0,
            child: notDoneTasks.length > 0
                ? AnimatedDefaultTextStyle(
                    duration: Duration(milliseconds: 300),
                    style: hasNotDoneTasks
                        ? TextStyle(
                            fontSize: 18,
                            color: Theme.of(context)
                                .textSelectionColor
                                .withOpacity(0.75),
                            fontWeight: FontWeight.w600,
                          )
                        : TextStyle(
                            fontSize: 0,
                            color: Theme.of(context)
                                .textSelectionColor
                                .withOpacity(0.75),
                            fontWeight: FontWeight.w600,
                          ),
                    child: Text(
                      AppLocalizations.of(context)
                          .translate('todos_title')
                          .toUpperCase(),
                    ),
                  )
                : SizedBox.shrink(),
          ),

          // List
          AnimatedContainer(
            duration: Duration(milliseconds: 200),
            height: hasNotDoneTasks ? 60.0 * notDoneTasks.length : 0,
            child: _buildNotDoneTaskList(),
          ),

//========================================================================================
/*                                                                                      *
 *                                       DONE TASK                                      *
 *                                                                                      */
//========================================================================================

          // Padding
          doneTasks.length > 0
              ? AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  height: hasDoneTasks ? 20 : 0,
                )
              : SizedBox.shrink(),

          // Title
          AnimatedOpacity(
            duration: Duration(milliseconds: 300),
            opacity: hasDoneTasks ? 1 : 0,
            child: doneTasks.length > 0
                ? AnimatedDefaultTextStyle(
                    duration: Duration(milliseconds: 300),
                    style: hasDoneTasks
                        ? TextStyle(
                            fontSize: 18,
                            color: Theme.of(context)
                                .textSelectionColor
                                .withOpacity(0.75),
                            fontWeight: FontWeight.w600,
                          )
                        : TextStyle(
                            fontSize: 0,
                            color: Theme.of(context)
                                .textSelectionColor
                                .withOpacity(0.75),
                            fontWeight: FontWeight.w600,
                          ),
                    child: Text(
                      AppLocalizations.of(context)
                          .translate('todos_done')
                          .toUpperCase(),
                    ),
                  )
                : SizedBox.shrink(),
          ),

          // List
          AnimatedContainer(
            duration: Duration(milliseconds: 200),
            height: hasDoneTasks ? 60.0 * doneTasks.length : 0,
            child: _buildDoneTaskList(),
          )
        ],
      ),
    );
  }
}
