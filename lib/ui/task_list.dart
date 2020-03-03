import 'package:flutter/material.dart';
import 'package:habits_plus/models/task.dart';
import 'package:habits_plus/models/taskData.dart';
import 'package:provider/provider.dart';

class TaskList extends StatefulWidget {
  bool isDone;
  String header = '';
  Function callback;
  List<Task> tasks = [];
  List<bool> doneAnimation = [];
  List<bool> tickAnimation = [];

  TaskList({
    this.isDone,
    this.header,
    this.callback,
    this.tasks,
    this.doneAnimation,
    this.tickAnimation,
  });

  @override
  _TaskListState createState() => _TaskListState();
}

class _TaskListState extends State<TaskList> with TickerProviderStateMixin {
  // Animation
  AnimationController controller;
  Tween tween;
  Animation<double> animation;
  double padding = 100;

  @override
  void initState() {
    super.initState();

    // This animation section is used when you first open the page
    // Translate tasks tiles -100px to left
    // Duration: 900ms
    controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 900),
    );
    tween = new Tween<double>(begin: 100.0, end: 0.0);
    animation = tween.animate(
      CurvedAnimation(parent: controller, curve: Curves.easeInOutCubic),
    );
    animation.addListener(() {
      setState(() {
        padding = animation.value;
      });
    });
    controller.forward();
  }

  @override
  void dispose() {
    // Animation
    controller.dispose();
    super.dispose();
  }

  // Function, which update global variables and reload state
  // of parent widgets (habits.dart)
  void _onClick() {
    setState(
      () {
        // Update global variables using Provider package
        if (widget.isDone) {
          Provider.of<TaskData>(context, listen: false).doneTasks =
              widget.tasks;
        } else {
          Provider.of<TaskData>(context, listen: false).notDoneTasks =
              widget.tasks;
        }
      },
    );

    // Callback
    widget.callback();
  }

  Widget _buildText(i) {
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
              // IF task is done :
              //  IF now is going tick animation:
              // <-- Line-Throught style
              //  ELSE now is NOT going tick animation:
              // <-- Not Line-Throught style
              // ELSE:
              //  IF now is going tick animation:
              // <-- Not Line-Throught style
              //  ELSE now is NOT going tick animation:
              // <-- Line-Throught style
              style: !widget.isDone
                  ? widget.tickAnimation[i]
                      ? TextStyle(
                          color: Theme.of(context).textSelectionColor,
                          fontSize: 18,
                          decoration: TextDecoration.lineThrough,
                        )
                      : TextStyle(
                          color: Theme.of(context).textSelectionHandleColor,
                          fontSize: 18,
                        )
                  : widget.tickAnimation[i]
                      ? TextStyle(
                          color: Theme.of(context).textSelectionHandleColor,
                          fontSize: 18,
                        )
                      : TextStyle(
                          color: Theme.of(context).textSelectionColor,
                          fontSize: 18,
                          decoration: TextDecoration.lineThrough,
                        ),
              child: Text(
                widget.tasks[i].title,
              ),
            ),

            // Padding
            SizedBox(height: 3),

            // Subtitle
            Text(
              widget.tasks[i].description,
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

  Widget _buildButton(i) {
    return GestureDetector(
      onTap: () {
        setState(() {
          // Activate tick animations and strikethrough text animations
          widget.tickAnimation[i] = true;
        });

        // Activate doneAnimations with 200ms delay
        Future.delayed(Duration(milliseconds: 200)).then((value) {
          setState(() {
            widget.doneAnimation[i] = true;
          });
          Future.delayed(Duration(milliseconds: 200)).then(
            (value) => setState(
              () {
                // Update local task "done" property with 200ms delay
                widget.tasks[i].done = !widget.tasks[i].done;
                Future.delayed(Duration(milliseconds: 200)).then((value) {
                  // Update global variables using Provider package
                  setState(() {
                    if (widget.isDone) {
                      Provider.of<TaskData>(context, listen: false)
                          .notDoneTasks
                          .add(widget.tasks[i]);
                    } else {
                      Provider.of<TaskData>(context, listen: false)
                          .doneTasks
                          .add(widget.tasks[i]);
                    }

                    // Remove extra task from the lists of Tasks and animations
                    widget.doneAnimation.removeAt(i);
                    widget.tasks.removeAt(i);
                    widget.tickAnimation.removeAt(i);

                    _onClick();
                  });
                });
              },
            ),
          );
        });
      },
      child: AnimatedContainer(
        width: 25,
        height: 25,
        duration: Duration(milliseconds: 250),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          border: Border.all(
            width: 2,
            color: widget.isDone
                ? Colors.transparent
                : Theme.of(context).primaryColor,
          ),
          color: widget.isDone
              ? Theme.of(context).disabledColor
              : widget.tickAnimation[i]
                  ? Theme.of(context).primaryColor
                  : Colors.transparent,
        ),
        child: Icon(
          Icons.done,
          color: Colors.white,
          size: 16,
        ),
      ),
    );
  }

  List<Widget> _buildTasksList() {
    // print(animation.value);

    return widget.tasks
        .asMap()
        .map(
          (i, Task task) => MapEntry(
            i,
            Dismissible(
              onDismissed: (DismissDirection direction) {
                // Remove task action
                if (direction == DismissDirection.startToEnd) {
                  setState(() {
                    widget.tasks.removeAt(i);
                    widget.doneAnimation.removeAt(i);
                    widget.tickAnimation.removeAt(i);
                  });
                  // Submit task active
                } else if (direction == DismissDirection.endToStart) {
                  setState(() {
                    widget.tasks[i].done = !widget.tasks[i].done;
                    if (widget.isDone) {
                      Provider.of<TaskData>(context, listen: false)
                          .notDoneTasks
                          .add(widget.tasks[i]);
                    } else {
                      Provider.of<TaskData>(context, listen: false)
                          .doneTasks
                          .add(widget.tasks[i]);
                    }

                    widget.tasks.removeAt(i);
                    widget.doneAnimation.removeAt(i);
                    widget.tickAnimation.removeAt(i);
                  });
                }

                _onClick();
              },
              background: Container(
                color: Colors.red,
              ),
              secondaryBackground: Container(
                color: Theme.of(context).primaryColor.withOpacity(0.1),
              ),
              key: ValueKey(widget.tasks[i].title),
              child: Container(
                // Start animation padding
                margin: EdgeInsets.only(left: padding),
                padding: EdgeInsets.symmetric(horizontal: 5),
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 200),
                  curve: Curves.bounceInOut,
                  // Task tile height animation
                  height: widget.isDone ? 60 : widget.tasks[i].done ? 0 : 60,
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 200),
                    padding: EdgeInsets.only(
                      left: widget.doneAnimation[i] ? 100 : 0,
                    ),
                    child: AnimatedOpacity(
                      duration: Duration(milliseconds: 200),
                      // Opacity animation
                      opacity: widget.doneAnimation[i] ? 0 : 1,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          _buildText(i),
                          _buildButton(i),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        )
        .values
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        // Header
        widget.tasks.length == 0
            ? SizedBox.shrink()
            : Text(
                widget.header,
                style: TextStyle(
                  fontSize: 18,
                  color: Theme.of(context).textSelectionColor.withOpacity(0.75),
                  fontWeight: FontWeight.w600,
                ),
              ),

        // List of tasks
        Container(
          child: Column(
            children: _buildTasksList(),
          ),
        ),
      ],
    );
  }
}
