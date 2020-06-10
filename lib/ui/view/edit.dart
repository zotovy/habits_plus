import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:habits_plus/core/models/comment.dart';
import 'package:habits_plus/core/models/habit.dart';
import 'package:habits_plus/core/viewmodels/edit_model.dart';
import 'package:habits_plus/localization.dart';
import 'package:habits_plus/ui/widgets/confirm_button.dart';
import 'package:habits_plus/ui/widgets/create/calendar.dart';
import 'package:habits_plus/ui/widgets/edit/appbar.dart';
import 'package:habits_plus/ui/widgets/edit/comment_tile.dart';
import 'package:habits_plus/ui/widgets/edit/day_row.dart';
import 'package:habits_plus/ui/widgets/edit/iconRow.dart';
import 'package:habits_plus/ui/widgets/error_snackbar.dart';
import 'package:habits_plus/ui/widgets/rounded_textfield.dart';
import 'package:habits_plus/ui/widgets/switch.dart';
import 'package:habits_plus/ui/widgets/texts.dart';
import 'package:provider/provider.dart';
import "package:habits_plus/ui/widgets/loading_modal.dart";

import '../../locator.dart';

class EditHabitPage extends StatefulWidget {
  Habit habit;

  EditHabitPage(this.habit);

  @override
  _EditHabitPageState createState() => _EditHabitPageState();
}

class _EditHabitPageState extends State<EditHabitPage> {
  // Model
  EditViewModel _model = locator<EditViewModel>();

  // Form
  int _iconCode;
  String _title;
  String _desc;
  List<bool> _repeatDays;
  List<DateTime> _dates;
  bool _hasNotifications;
  TimeOfDay _time;
  List<Comment> _comments;

  // Widgets
  TextWidgets _textWidgets;

  // Keys
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // ANCHOR: initState()
  @override
  void initState() {
    super.initState();
    _textWidgets = TextWidgets(context);

    _iconCode = widget.habit.iconCode;
    _title = widget.habit.title;
    _desc = widget.habit.description;
    _repeatDays = widget.habit.repeatDays;
    _dates = widget.habit.duration;
    _hasNotifications = widget.habit.hasReminder;
    _time = widget.habit.timeOfDay;
    _comments = widget.habit.comments;
  }

  // ANCHOR: isHabitChanged
  /// This function return [true] if user change some habit & [false] if not
  bool isHabitChanged() {
    if (_iconCode != widget.habit.iconCode) return true;
    if (_title != widget.habit.title) return true;
    if (_desc != widget.habit.description) return true;
    if (_repeatDays != widget.habit.repeatDays) return true;
    if (_dates != widget.habit.duration) return true;
    if (_hasNotifications != widget.habit.hasReminder) return true;
    if (_time != widget.habit.timeOfDay) return true;
    if (!ListEquality().equals(_comments, widget.habit.comments)) return true;

    return false;
  }

  // ANCHOR: onSubmit
  /// Function save all edit data
  void _onSubmit(EditViewModel model) async {
    if (!isHabitChanged()) {
      Navigator.pop(context);
      return null;
    }
    if (!_formKey.currentState.validate()) return null;

    // save to local variables
    _formKey.currentState.save();

    // Change habit
    widget.habit.comments = _comments;
    widget.habit.description = _desc;
    widget.habit.duration = _dates;
    widget.habit.goalAmount = _dates[1].difference(_dates[0]).inDays.abs() + 1;
    widget.habit.hasReminder = _hasNotifications;
    widget.habit.iconCode = _iconCode;
    widget.habit.repeatDays = _repeatDays;
    widget.habit.timeOfDay = _time;
    widget.habit.title = _title;

    // Show loading dialog
    showDialog(context: context, builder: (_) => LoadingModal());

    // submit
    bool code = await model.save(widget.habit);

    // exit loading dialog
    Navigator.pop(context);

    // show error message
    if (!code) {
      _scaffoldKey.currentState.showSnackBar(
        errorSnackBar(context, 'save_error'),
      );
      return null; // eit
    }

    Navigator.pop(context);
  }

  // ANCHOR: isEveryday
  /// Function return [true] if widget.habit.repeatDays is all true
  /// & [false] if not
  bool _isEveryday() => ListEquality().equals(
        List.filled(7, true),
        widget.habit.repeatDays,
      );

  // ANCHOR: getTime
  /// Function return formatted time if habit has time
  /// and '12:00' if not
  String _getTime() {
    String hour, minutes;
    if (_time == null) {
      hour = '12';
      minutes = '00';
    } else {
      // format hour
      if (_time.hour < 10) {
        hour = '0' + _time.hour.toString();
      } else {
        hour = _time.hour.toString();
      }

      // format minutes
      if (_time.minute < 10) {
        minutes = '0' + _time.minute.toString();
      } else {
        minutes = _time.minute.toString();
      }
    }

    return '$hour:$minutes';
  }

  // ANCHOR: UI
  List<Widget> _ui(context, model) {
    return [
          // Title
          _textWidgets.title('general'),
          SizedBox(height: 10),

          // Icon row
          IconRowWidget(
            initialIconCode: _iconCode,
            callback: (int i) => _iconCode = i,
          ),
          SizedBox(height: 10),

          // #####################

          // Title text field
          RoundedTextField(
            text: _title,
            margin: EdgeInsets.symmetric(horizontal: 15),
            labelLocalizationPath: 'title',
            onChanged: (String val) => _title = val,
          ),
          SizedBox(height: 10),

          // Description text field
          RoundedTextField(
            text: _desc,
            margin: EdgeInsets.symmetric(horizontal: 15),
            labelLocalizationPath: 'desc',
            onChanged: (String val) => _desc = val,
            validator: (String val) => null,
          ),
          SizedBox(height: 20),

          // ######################

          // "Calendar" title
          _textWidgets.title('calendar'),
          SizedBox(height: 5),

          // Day row
          DayRow(
            initialList: widget.habit.repeatDays,
            callback: (List<bool> list) {
              setState(() {
                _repeatDays = list;
              });
            },
          ),
          SizedBox(height: 10),

          // Calendar title
          Container(
            margin: EdgeInsets.symmetric(horizontal: 15),
            padding: EdgeInsets.all(5),
            decoration: BoxDecoration(
              border: Border.all(
                color: Theme.of(context).primaryColor,
                width: 1,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: CalendarRangePicker(
              onDateSelected: (DateTime date1, DateTime date2) =>
                  _dates = [date1, date2],
              initialDates: _dates,
            ),
          ),
          SizedBox(height: 20),

          // Push Notification title
          _textWidgets.title('push_notification'),
          SizedBox(height: 5),

          // Push Notification switcher
          Container(
            margin: EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                // Push Notifications
                Text(
                  AppLocalizations.of(context).translate('push_notification'),
                  style: TextStyle(
                    fontSize: 18,
                    color: Theme.of(context).textSelectionColor,
                  ),
                ),

                // Switcher
                CustomSwitch(
                  value: _hasNotifications,
                  callback: (bool value) {
                    setState(() {
                      _hasNotifications = value;
                    });
                    return value;
                  },
                  isDisable: false,
                ),
              ],
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
            ),
          ),
          SizedBox(height: 5),

          // Time Picker
          GestureDetector(
            onTap: () async {
              TimeOfDay time = await showTimePicker(
                context: context,
                initialTime:
                    _time == null ? TimeOfDay(hour: 12, minute: 0) : _time,
              );
              setState(() {
                _time = time;
              });
            },
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 15),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  // Push Notifications
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        AppLocalizations.of(context).translate('time'),
                        style: TextStyle(
                          fontSize: 18,
                          color: Theme.of(context).textSelectionColor,
                        ),
                      ),
                    ),
                  ),

                  // Time
                  Text(
                    widget.habit.timeOfDay == null ? '12:00' : _getTime(),
                    style: TextStyle(
                      fontSize: 16,
                      color: Theme.of(context).textSelectionColor,
                    ),
                  ),
                  SizedBox(width: 5),

                  // Icon
                  Icon(
                    Icons.chevron_right,
                    color:
                        Theme.of(context).textSelectionColor.withOpacity(0.5),
                  )
                ],
                mainAxisAlignment: MainAxisAlignment.end,
              ),
            ),
          ),
          SizedBox(height: 20),

          // Comments
          _comments.length > 0
              ? _textWidgets.title('comments')
              : SizedBox.shrink(),
        ] +
        List.generate(
          _comments.length,
          (int i) => CommentTile(
            comment: _comments[i],
            onCommentChange: (Comment comm) {
              setState(() {
                _comments[i] = comm;
              });
            },
            onDelete: () {
              setState(() {
                _comments.removeAt(i);
              });
            },
          ),
        ) +
        [
          SizedBox(height: 20),
          ConfirmButton(
            submit: () => _onSubmit(model),
            text: 'confirm',
          ),
          SizedBox(height: 15),
        ];
  }

  // ANCHOR: build
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _model,
      child: Consumer<EditViewModel>(
        builder: (_, model, child) {
          return GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: Scaffold(
              key: _scaffoldKey,
              appBar: EditAppBar(
                context: context,
                isHabitChanged: isHabitChanged,
              ).appbar(),
              backgroundColor: Theme.of(context).backgroundColor,
              body: Form(
                key: _formKey,
                child: SafeArea(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: _ui(context, model),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
