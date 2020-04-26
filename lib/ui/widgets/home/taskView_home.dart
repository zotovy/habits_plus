import 'package:flutter/material.dart';
import 'package:habits_plus/core/models/task.dart';
import 'package:habits_plus/core/models/userData.dart';
import 'package:habits_plus/core/viewmodels/home_model.dart';
import 'package:habits_plus/localization.dart';
import 'package:habits_plus/locator.dart';
import 'package:provider/provider.dart';

class TaskViewOnHomePage extends StatefulWidget {
  @override
  _TaskViewOnHomePageState createState() => _TaskViewOnHomePageState();
}

class _TaskViewOnHomePageState extends State<TaskViewOnHomePage> {
  // Model
  HomeViewModel _model = locator<HomeViewModel>();

  GlobalKey<AnimatedListState> _keyDoneTask = GlobalKey<AnimatedListState>();
  GlobalKey<AnimatedListState> _keyNotDoneTask = GlobalKey<AnimatedListState>();

  @override
  void initState() {
    super.initState();

    // Start Animation
    HomeViewModel model = locator<HomeViewModel>();
    _startDoneTaskAnimation(model);
    _startNotDoneTaskAnimation(model);
  }

  /// Start apperance animation, ONLY [doneAnimationController]
  /// Duration is [100] milliseconds
  _startDoneTaskAnimation(HomeViewModel model) async {
    /// We need Future to wait, when [build] method is done
    Future.delayed(Duration(milliseconds: 100)).then(
      (value) async {
        for (var i = 0; i < model.doneTodayTasks.length; i++) {
          if (_keyDoneTask.currentState != null) {
            _keyDoneTask.currentState.insertItem(i);
          }
          await Future.delayed(Duration(milliseconds: 250));
        }
      },
    );
  }

  /// Start apperance animation, ONLY [notDoneAnimationController]
  /// Duration is [100] milliseconds
  _startNotDoneTaskAnimation(HomeViewModel model) async {
    /// We need Future to wait, when [build] method is done
    Future.delayed(Duration(milliseconds: 100)).then(
      (value) async {
        for (var i = 0; i < model.notDoneTodayTasks.length; i++) {
          if (_keyNotDoneTask.currentState != null) {
            _keyNotDoneTask.currentState.insertItem(i);
          }
          await Future.delayed(Duration(milliseconds: 250));
        }
      },
    );

    model.setNeedReload(false);
  }

  /// Build [text] for Task Tile
  /// Only for [done] tasks
  Widget _buildDoneText(Task task) {
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
              style: task.done
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
                task.title,
              ),
            ),

            // Padding
            SizedBox(height: 3),

            // Subtitle
            Text(
              task.description,
              style: TextStyle(
                color: task.done
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
  Widget _buildNotDoneText(Task task) {
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
              style: task.done
                  ? TextStyle(
                      color: Theme.of(context).textSelectionColor,
                      fontSize: 18,
                      decoration: TextDecoration.lineThrough,
                    )
                  : TextStyle(
                      color: Theme.of(context).textSelectionHandleColor,
                      fontSize: 18,
                    ),
              child: Text(task.title),
            ),

            // Padding
            SizedBox(height: 3),

            // Subtitle
            Text(
              task.description,
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
    BuildContext context,
    int i,
    Animation<double> animation,
    HomeViewModel model,
  ) {
    /// This local [AnimationController] will controll
    /// removing the item by [SlideAnimation]
    // Dismissible -> Slide -> Fade -> Size
    return Dismissible(
      onDismissed: (DismissDirection direction) {
        // Remove task action
        if (direction == DismissDirection.startToEnd) {
          // Start title disappearance animation
          if (model.doneTodayTasks.length == 1) {
            model.hasDoneTasks = false;
          }

          // Remove dissimissble from the list
          _keyDoneTask.currentState.removeItem(
            i,
            (BuildContext context, Animation<double> animation) {
              return Container(
                height: animation.value,
                color: Colors.redAccent,
              );
            },
          );

          // Delete task in database
          String userId = Provider.of<UserData>(
            context,
            listen: false,
          ).currentUserId;
          model.removeTaskFromDB(model.doneTodayTasks[i], userId);

          /// Remove extra [model.notDoneTodayTasks]
          if (model.doneTodayTasks.length == 1) {
            Future.delayed(Duration(milliseconds: 300)).then((_) {
              model.removeFromDoneTasks(i);
            });
          } else {
            model.removeFromDoneTasks(i);
          }
        }
        // Submit task active
        else if (direction == DismissDirection.endToStart) {
          // Start title disappearance animation
          if (model.doneTodayTasks.length == 1) {
            model.hasDoneTasks = false;
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
            /// Add [DoneTask] to [model.notDoneTodayTasks], remove extra notDoneTask and insert into [AnimatedList]
            model.addNotDoneTasks(model.doneTodayTasks[i]);
            _keyNotDoneTask.currentState.insertItem(
              model.notDoneTodayTasks.length - 1,
            );
            model.hasNotDoneTasks = true;
          });

          // Update task in database
          model.updateDoneProperty(model.doneTodayTasks[i], false);
          String userId = Provider.of<UserData>(
            context,
            listen: false,
          ).currentUserId;
          model.updateTask(model.doneTodayTasks[i], userId);

          /// Remove extra [model.doneTodayTasks]
          if (model.doneTodayTasks.length == 1) {
            Future.delayed(Duration(milliseconds: 300)).then((_) {
              model.removeFromDoneTasks(i);
            });
          } else {
            model.removeFromDoneTasks(i);
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
      key: ValueKey(model.doneTodayTasks[i].title),
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
                  _buildDoneText(model.doneTodayTasks[i]),
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
    BuildContext context,
    int i,
    Animation<double> animation,
    HomeViewModel model,
  ) {
    /// This local [AnimationController] will controll
    /// removing the item by [SlideAnimation]
    // Dismissible -> Slide -> Fade -> Size
    return Dismissible(
      onDismissed: (DismissDirection direction) {
        // Remove task action
        if (direction == DismissDirection.startToEnd) {
          // Start title disappearance animation
          if (model.notDoneTodayTasks.length == 1) {
            model.hasNotDoneTasks = false;
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
          String userId = Provider.of<UserData>(
            context,
            listen: false,
          ).currentUserId;
          model.removeTaskFromDB(model.notDoneTodayTasks[i], userId);

          /// Remove extra [model.notDoneTodayTasks] and [animationDoneInNotDoneTaskList]
          if (model.doneTodayTasks.length == 1) {
            Future.delayed(Duration(milliseconds: 300)).then((_) {
              model.removeFromNotDoneTasks(i);
            });
          } else {
            model.removeFromDoneTasks(i);
          }
        }
        //* Submit task active
        else if (direction == DismissDirection.endToStart) {
          // Start title disappearance animation
          if (model.notDoneTodayTasks.length == 1) {
            model.hasNotDoneTasks = false;
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

          setState(() {
            /// Add [notDoneTask] to [model.doneTodayTasks], remove extra doneTask and insert into [AnimatedList]
            model.addDoneTask(model.notDoneTodayTasks[i]);
            _keyDoneTask.currentState.insertItem(
              model.doneTodayTasks.length - 1,
            );
            model.hasDoneTasks = true;
          });

          // Update task in database
          model.updateDoneProperty(model.notDoneTodayTasks[i], true);
          String userId = Provider.of<UserData>(
            context,
            listen: false,
          ).currentUserId;
          model.updateTask(model.notDoneTodayTasks[i], userId);

          /// Remove extra [model.notDoneTodayTasks]
          if (model.notDoneTodayTasks.length == 1) {
            Future.delayed(Duration(milliseconds: 300)).then((_) {
              model.removeFromNotDoneTasks(i);
            });
          } else {
            model.removeFromNotDoneTasks(i);
          }
        }
      },
      background: Container(
        color: Colors.red,
      ),
      secondaryBackground: Container(
        color: Theme.of(context).primaryColor.withOpacity(0.1),
      ),
      key: ValueKey(model.notDoneTodayTasks[i].title),
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
                  _buildNotDoneText(model.notDoneTodayTasks[i]),
                  _buildNotDoneButton(false),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  removeItemFromDoneList(int i, HomeViewModel model) {
    // Remind done variables as local variables
    Task _localTask = model.doneTodayTasks[i];

    // Update task in DB
    model.doneTodayTasks[i].done = false;
    String userId = Provider.of<UserData>(
      context,
      listen: false,
    ).currentUserId;
    model.updateTask(model.doneTodayTasks[i], userId);

    Future.delayed(Duration(milliseconds: 200)).then(
      (_) {
        if (model.doneTodayTasks.length == 1) {
          model.hasDoneTasks = false;
        }
        Future.delayed(Duration(milliseconds: 300)).then((_) {
          /// Add [notDoneTask] to [model.doneTodayTasks], remove extra doneTask and insert into [AnimatedList]
          model.addNotDoneTasks(model.doneTodayTasks[i]);

          _keyNotDoneTask.currentState.insertItem(
            model.notDoneTodayTasks.length - 1,
          );
          model.hasNotDoneTasks = true;
          model.removeFromDoneTasks(i);
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
                      _buildDoneText(_localTask),
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

  removeItemFromNotDoneList(int i, HomeViewModel model) async {
    // Remind done variables as local variables
    Task _localTask = model.notDoneTodayTasks[i];

    model.updateDoneProperty(model.notDoneTodayTasks[i], true);
    String userId = Provider.of<UserData>(context, listen: false).currentUserId;
    model.updateTask(model.notDoneTodayTasks[i], userId);

    if (model.notDoneTodayTasks.length == 1) {
      model.hasNotDoneTasks = false;
    }
    model.hasDoneTasks = true;

    Future.delayed(Duration(milliseconds: 200)).then(
      (_) {
        model.addDoneTask(model.notDoneTodayTasks[i]);
        model.removeFromNotDoneTasks(i);
        Future.delayed(Duration(milliseconds: 300)).then((_) {
          /// Add [notDoneTask] to [model.doneTodayTasks]
          _keyDoneTask.currentState.insertItem(model.doneTodayTasks.length - 1);
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
                      _buildDoneText(_localTask),
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
  Widget _buildDoneTaskList(HomeViewModel model) {
    return model.doneTodayTasks.length == 0
        ? SizedBox.shrink()
        : AnimatedList(
            key: _keyDoneTask,
            initialItemCount: 0,
            itemBuilder:
                (BuildContext context, int index, Animation<double> animation) {
              return Material(
                color: Colors.transparent,
                child: InkWell(
                  onLongPress: () => removeItemFromDoneList(index, model),
                  child: _buildDoneListTile(context, index, animation, model),
                ),
              );
            },
          );
  }

  /// Second block of main widget
  Widget _buildNotDoneTaskList(HomeViewModel model) {
    return model.notDoneTodayTasks.length == 0
        ? SizedBox.shrink()
        : AnimatedList(
            key: _keyNotDoneTask,
            initialItemCount: 0,
            itemBuilder:
                (BuildContext context, int index, Animation<double> animation) {
              return Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => removeItemFromNotDoneList(index, model),
                  child:
                      _buildNotDoneListTile(context, index, animation, model),
                ),
              );
            },
          );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _model,
      child: Consumer(
        builder: (_, HomeViewModel model, child) {
          //
          // Start animation
          if (model.needTransition) {
            _startDoneTaskAnimation(model);
            _startNotDoneTaskAnimation(model);
          }

          // print('tasks: ${model.tasks}');
          // print('done: ${model.doneTodayTasks}');
          // print('not done: ${model.notDoneTodayTasks}');

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
                model.notDoneTodayTasks.length > 0
                    ? AnimatedContainer(
                        duration: Duration(milliseconds: 300),
                        height: model.hasNotDoneTasks ? 20 : 0,
                      )
                    : SizedBox.shrink(),

                // Title
                AnimatedOpacity(
                  duration: Duration(milliseconds: 300),
                  opacity: model.hasNotDoneTasks ? 1 : 0,
                  child: model.notDoneTodayTasks.length > 0
                      ? AnimatedDefaultTextStyle(
                          duration: Duration(milliseconds: 300),
                          style: model.hasNotDoneTasks
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
                  height: model.hasNotDoneTasks
                      ? 60.0 * model.notDoneTodayTasks.length
                      : 0,
                  child: _buildNotDoneTaskList(model),
                ),

//========================================================================================
/*                                                                                      *
 *                                       DONE TASK                                      *
 *                                                                                      */
//========================================================================================

                // Padding
                model.doneTodayTasks.length > 0
                    ? AnimatedContainer(
                        duration: Duration(milliseconds: 300),
                        height: model.hasDoneTasks ? 20 : 0,
                      )
                    : SizedBox.shrink(),

                // Title
                AnimatedOpacity(
                  duration: Duration(milliseconds: 300),
                  opacity: model.hasDoneTasks ? 1 : 0,
                  child: model.doneTodayTasks.length > 0
                      ? AnimatedDefaultTextStyle(
                          duration: Duration(milliseconds: 300),
                          style: model.hasDoneTasks
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
                  height: model.hasDoneTasks
                      ? 60.0 * model.doneTodayTasks.length
                      : 0,
                  child: _buildDoneTaskList(model),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
