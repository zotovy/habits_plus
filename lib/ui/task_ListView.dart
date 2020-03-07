import 'package:flutter/material.dart';
import 'package:habits_plus/localization.dart';
import 'package:habits_plus/models/task.dart';
import 'package:habits_plus/models/userData.dart';
import 'package:habits_plus/services/database.dart';
import 'package:provider/provider.dart';

class TaskListView extends StatefulWidget {
  List<Task> doneTasks;
  List<Task> notDoneTasks;
  bool hasDoneTasks;
  bool hasNotDoneTasks;

  TaskListView({
    this.doneTasks,
    this.notDoneTasks,
  }) {
    hasDoneTasks = doneTasks.length > 0 ? true : false;
    hasNotDoneTasks = notDoneTasks.length > 0 ? true : false;
  }

  @override
  _TaskListViewState createState() => _TaskListViewState();
}

class _TaskListViewState extends State<TaskListView>
    with TickerProviderStateMixin {
  // Animation
  GlobalKey<AnimatedListState> _keyDoneTask = GlobalKey<AnimatedListState>();
  GlobalKey<AnimatedListState> _keyNotDoneTask = GlobalKey<AnimatedListState>();
  List<AnimationController> doneAnimationController = [];
  List<AnimationController> notDoneAnimationController = [];

  @override
  void initState() {
    super.initState();

    /**
     * Init list of AnimationController to make apperance animation.
     * Length of [doneAnimationController] is the same as [widget.doneTasks]
     * Length of [notDoneAnimationController] is the same as [widget.notDoneTasks]
     * Duration is [300ms]
    **/
    doneAnimationController = List.generate(
      widget.doneTasks.length,
      (int i) => AnimationController(
        vsync: this,
        duration: Duration(milliseconds: 300),
      ),
    );
    notDoneAnimationController = List.generate(
      widget.notDoneTasks.length,
      (int i) => AnimationController(
        vsync: this,
        duration: Duration(milliseconds: 300),
      ),
    );

    /**
     * Init list of bool, which used in [text-strikethrough]
     * and in boxButtonTick animation
     * Length of [doneAnimationController] is the same as [widget.doneTasks]
     * Length of [notDoneAnimationController] is the same as [widget.notDoneTasks]
     * True -> tile has got [text-strikethrough] and [boxButtonTick] animation
     * False -> tile hasn't got [text-strikethrough] and [boxButtonTick] animation
     * Default: all values is false
     */

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
        for (var i = 0; i < widget.doneTasks.length; i++) {
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
        for (var i = 0; i < widget.notDoneTasks.length; i++) {
          _keyNotDoneTask.currentState.insertItem(i);
          await Future.delayed(Duration(milliseconds: 250));
        }
      },
    );
  }

  /// This function push new task in DB
  _updateTaskInDB(Task task) async {
    DatabaseServices.updateTask(
        task, Provider.of<UserData>(context, listen: false).currentUserId);
  }

  /// This function delete task from DB
  _deleteTaskInDB(Task task) async {
    DatabaseServices.deleteTask(
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
                      color: Theme.of(context).textSelectionColor,
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
                color: Theme.of(context).textSelectionColor,
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
        color: Colors.white,
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
          if (widget.notDoneTasks.length == 1) {
            setState(() {
              widget.hasDoneTasks = false;
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
          // _deleteTaskInDB(widget.notDoneTasks[i]);

          /// Remove extra [notDoneTasks]
          if (widget.notDoneTasks.length == 1) {
            Future.delayed(Duration(milliseconds: 300)).then((_) {
              setState(() {
                widget.doneTasks.removeAt(i);
              });
            });
          } else {
            setState(() {
              widget.doneTasks.removeAt(i);
            });
          }
        }
        // Submit task active
        else if (direction == DismissDirection.endToStart) {
          // Start title disappearance animation
          if (widget.doneTasks.length == 1) {
            setState(() {
              widget.hasDoneTasks = false;
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
            widget.notDoneTasks.add(widget.doneTasks[i]);
            _keyNotDoneTask.currentState
                .insertItem(widget.notDoneTasks.length - 1);
            widget.hasNotDoneTasks = true;
            // widget.notDoneTasks.removeAt(i);
          });

          // Delete task in database
          // _deleteTaskInDB(widget.notDoneTasks[i]);

          /// Remove extra [doneTasks]
          if (widget.doneTasks.length == 1) {
            Future.delayed(Duration(milliseconds: 300)).then((_) {
              setState(() {
                widget.doneTasks.removeAt(i);
              });
            });
          } else {
            setState(() {
              widget.doneTasks.removeAt(i);
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
      key: ValueKey(widget.doneTasks[i].title),
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
                    widget.doneTasks[i].title,
                    widget.doneTasks[i].description,
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
          if (widget.notDoneTasks.length == 1) {
            setState(() {
              widget.hasNotDoneTasks = false;
            });
          }

          // Remove dissimissble from the list
          _keyNotDoneTask.currentState.removeItem(
            i,
            (BuildContext context, Animation<double> animation) {
              return Container(
                height: animation.value - 1,
                color: Colors.redAccent,
              );
            },
          );

          // Delete task in database
          // _deleteTaskInDB(widget.notDoneTasks[i]);

          /// Remove extra [notDoneTasks] and [animationDoneInNotDoneTaskList]
          if (widget.notDoneTasks.length == 1) {
            Future.delayed(Duration(milliseconds: 300)).then((_) {
              setState(() {
                widget.notDoneTasks.removeAt(i);
              });
            });
          } else {
            setState(() {
              widget.notDoneTasks.removeAt(i);
            });
          }
        }
        //* Submit task active
        else if (direction == DismissDirection.endToStart) {
          // Start title disappearance animation
          if (widget.notDoneTasks.length == 1) {
            setState(() {
              widget.hasNotDoneTasks = false;
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
            widget.doneTasks.add(widget.notDoneTasks[i]);
            _keyDoneTask.currentState.insertItem(widget.doneTasks.length - 1);
            widget.hasDoneTasks = true;
            // widget.notDoneTasks.removeAt(i);
          });
          // });

          // Delete task in database
          // _deleteTaskInDB(widget.notDoneTasks[i]);

          /// Remove extra [notDoneTasks]
          if (widget.notDoneTasks.length == 1) {
            Future.delayed(Duration(milliseconds: 300)).then((_) {
              setState(() {
                widget.notDoneTasks.removeAt(i);
              });
            });
          } else {
            setState(() {
              widget.notDoneTasks.removeAt(i);
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
      key: ValueKey(widget.notDoneTasks[i].title),
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
                    widget.notDoneTasks[i].title,
                    widget.notDoneTasks[i].description,
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
    String title = widget.doneTasks[i].title;
    String desc = widget.doneTasks[i].description;

    // TODO: update in DB

    Future.delayed(Duration(milliseconds: 200)).then(
      (_) {
        setState(() {
          if (widget.doneTasks.length == 1) {
            widget.hasDoneTasks = false;
          }
          Future.delayed(Duration(milliseconds: 300)).then((_) {
            setState(() {
              /// Add [notDoneTask] to [doneTasks], remove extra doneTask and insert into [AnimatedList]
              widget.notDoneTasks.add(widget.doneTasks[i]);
              _keyNotDoneTask.currentState
                  .insertItem(widget.notDoneTasks.length - 1);
              widget.hasNotDoneTasks = true;
              widget.doneTasks.removeAt(i);
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

  removeItemFromNotDoneList(int i) {
    // Remind done variables as local variables
    String title = widget.notDoneTasks[i].title;
    String desc = widget.notDoneTasks[i].description;

    // TODO: update in DB

    setState(() {
      if (widget.notDoneTasks.length == 1) {
        widget.hasNotDoneTasks = false;
      }
      widget.hasDoneTasks = true;
    });

    Future.delayed(Duration(milliseconds: 200)).then(
      (_) {
        setState(() {
          widget.doneTasks.add(widget.notDoneTasks[i]);
          widget.notDoneTasks.removeAt(i);
          Future.delayed(Duration(milliseconds: 300)).then((_) {
            setState(() {
              /// Add [notDoneTask] to [doneTasks], remove extra doneTask and insert into [AnimatedList]
              _keyDoneTask.currentState.insertItem(widget.doneTasks.length - 1);
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
          widget.notDoneTasks.length > 0
              ? AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  height: widget.hasNotDoneTasks ? 20 : 0,
                )
              : SizedBox.shrink(),

          // Title
          AnimatedOpacity(
            duration: Duration(milliseconds: 300),
            opacity: widget.hasNotDoneTasks ? 1 : 0,
            child: widget.notDoneTasks.length > 0
                ? AnimatedDefaultTextStyle(
                    duration: Duration(milliseconds: 300),
                    style: widget.hasNotDoneTasks
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
            height:
                widget.hasNotDoneTasks ? 60.0 * widget.notDoneTasks.length : 0,
            child: _buildNotDoneTaskList(),
          ),

//========================================================================================
/*                                                                                      *
 *                                       DONE TASK                                      *
 *                                                                                      */
//========================================================================================

          // Padding
          widget.doneTasks.length > 0
              ? AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  height: widget.hasDoneTasks ? 20 : 0,
                )
              : SizedBox.shrink(),

          // Title
          AnimatedOpacity(
            duration: Duration(milliseconds: 300),
            opacity: widget.hasDoneTasks ? 1 : 0,
            child: widget.doneTasks.length > 0
                ? AnimatedDefaultTextStyle(
                    duration: Duration(milliseconds: 300),
                    style: widget.hasDoneTasks
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
            height: widget.hasDoneTasks ? 60.0 * widget.doneTasks.length : 0,
            child: _buildDoneTaskList(),
          )
        ],
      ),
    );
  }
}
