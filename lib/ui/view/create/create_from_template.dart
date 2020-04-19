import 'package:flutter/material.dart';
import 'package:habits_plus/core/enums/habitType.dart';
import 'package:habits_plus/core/models/habit.dart';
import 'package:habits_plus/core/models/userData.dart';
import 'package:habits_plus/core/viewmodels/create_model.dart';
import 'package:habits_plus/localization.dart';
import 'package:habits_plus/locator.dart';
import 'package:habits_plus/ui/widgets/create/CreatetextField.dart';
import 'package:habits_plus/ui/widgets/create/Icon_choose_row.dart';
import 'package:habits_plus/ui/widgets/create/calendar.dart';
import 'package:habits_plus/ui/widgets/create/confirm_button.dart';
import 'package:habits_plus/ui/widgets/create/dayProgress.dart';
import 'package:habits_plus/ui/widgets/create/texts.dart';
import 'package:provider/provider.dart';

class CreateFromTemplatePage extends StatefulWidget {
  Habit templateHabit;

  CreateFromTemplatePage({
    @required this.templateHabit,
  });

  @override
  _CreateFromTemplatePageState createState() => _CreateFromTemplatePageState();
}

class _CreateFromTemplatePageState extends State<CreateFromTemplatePage> {
  CreateViewModel _model = locator<CreateViewModel>();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _model,
      child: Consumer(
        builder: (_, CreateViewModel model, child) {
          return GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: Scaffold(
              key: _scaffoldKey,
              backgroundColor: Theme.of(context).backgroundColor,
              body: Form(
                key: _formKey,
                child: SafeArea(
                  child: Container(
                    width: double.infinity,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          SizedBox(height: 10),
                          titleText(context, 'create_habit'),
                          SizedBox(height: 20),

                          // Choose Icon Row
                          IconChooseRow(
                            initIconCodeValue: widget.templateHabit.iconCode,
                            onChosen: (int index) {
                              widget.templateHabit.iconCode = index;
                            },
                          ),
                          SizedBox(height: 20),

                          // Title
                          CreateTextField(
                            errorLocalizationPath: 'error_noTextFieldData',
                            hintPath: 'createHabit_title',
                            initValue: widget.templateHabit.title,
                            onSaved: (String val) {
                              widget.templateHabit.title = val;
                            },
                            validator: (String val) => val.trim() == ''
                                ? AppLocalizations.of(context)
                                    .translate('createHabit_title_error')
                                : null,
                          ),
                          SizedBox(height: 10),

                          // Description
                          CreateTextField(
                            hintPath: 'createHabit_description',
                            initValue: widget.templateHabit.description,
                            onSaved: (String val) {
                              widget.templateHabit.description = val;
                            },
                          ),
                          SizedBox(height: 20),

                          // Progress Days
                          DayProgressWidget(
                            repeatDays: widget.templateHabit.repeatDays,
                            pressed: (int i) {
                              widget.templateHabit.repeatDays[i] =
                                  !widget.templateHabit.repeatDays[i];
                            },
                          ),
                          SizedBox(height: 20),

                          // Duration
                          Container(
                            padding: EdgeInsets.all(7),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: Theme.of(context).primaryColor,
                                width: 1.5,
                              ),
                            ),
                            margin: EdgeInsets.symmetric(horizontal: 15),
                            child: CalendarRangePicker(
                              onDateSelected:
                                  (DateTime _left, DateTime _right) {
                                widget.templateHabit.duration[0] = _left;
                                widget.templateHabit.duration[1] = _right;
                              },
                            ),
                          ),
                          SizedBox(height: 20),

                          // Cards
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: 15),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                // Uncountable
                                GestureDetector(
                                  onTap: () => setState(() {
                                    widget.templateHabit.type =
                                        HabitType.Uncountable;
                                  }),
                                  child: Container(
                                    width:
                                        MediaQuery.of(context).size.width / 2 -
                                            40,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: widget.templateHabit.type ==
                                              HabitType.Uncountable
                                          ? Theme.of(context).primaryColor
                                          : Theme.of(context).disabledColor,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.1),
                                          offset: Offset(0, 3),
                                          blurRadius: 5,
                                          spreadRadius: 3,
                                        )
                                      ],
                                    ),
                                    height: 275,
                                    padding: EdgeInsets.all(15),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        // Title
                                        Text(
                                          AppLocalizations.of(context)
                                              .translate('create_card1_title'),
                                          style: TextStyle(
                                            fontSize: 24,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        SizedBox(height: 15),

                                        // Description
                                        Text(
                                          AppLocalizations.of(context)
                                              .translate('create_card1_desc'),
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.white,
                                          ),
                                        ),
                                        SizedBox(height: 10),

                                        // Example
                                        Text(
                                          AppLocalizations.of(context)
                                              .translate(
                                                  'create_card1_example'),
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 14,
                                            color:
                                                Colors.white.withOpacity(0.75),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),

                                // Countable
                                GestureDetector(
                                  onTap: () => setState(() {
                                    widget.templateHabit.type =
                                        HabitType.Countable;
                                  }),
                                  child: Container(
                                    width:
                                        MediaQuery.of(context).size.width / 2 -
                                            40,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: widget.templateHabit.type ==
                                              HabitType.Countable
                                          ? Theme.of(context).primaryColor
                                          : Theme.of(context).disabledColor,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.1),
                                          offset: Offset(0, 3),
                                          blurRadius: 5,
                                          spreadRadius: 3,
                                        )
                                      ],
                                    ),
                                    height: 275,
                                    padding: EdgeInsets.all(15),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        // Title
                                        Text(
                                          AppLocalizations.of(context)
                                              .translate('create_card2_title'),
                                          style: TextStyle(
                                            fontSize: 24,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        SizedBox(height: 15),

                                        // Description
                                        Text(
                                          AppLocalizations.of(context)
                                              .translate('create_card2_desc'),
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.white,
                                          ),
                                        ),
                                        SizedBox(height: 10),

                                        // Example
                                        Text(
                                          AppLocalizations.of(context)
                                              .translate(
                                                  'create_card2_example'),
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 14,
                                            color:
                                                Colors.white.withOpacity(0.75),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 10),

                          // Turn on / off Push Notification
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: 15),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  AppLocalizations.of(context)
                                      .translate('push_notification'),
                                  style: TextStyle(
                                    color: Theme.of(context).textSelectionColor,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 20,
                                  ),
                                ),
                                Switch(
                                  value: widget.templateHabit.hasReminder,
                                  onChanged: (bool val) {
                                    setState(() {
                                      widget.templateHabit.hasReminder = val;
                                    });
                                  },
                                  activeColor: Theme.of(context).primaryColor,
                                ),
                              ],
                            ),
                          ),

                          // Time picker
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: 15),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                AnimatedDefaultTextStyle(
                                  duration: Duration(milliseconds: 300),
                                  style: widget.templateHabit.hasReminder
                                      ? TextStyle(
                                          color: Theme.of(context)
                                              .textSelectionColor,
                                          fontSize: 18,
                                        )
                                      : TextStyle(
                                          color:
                                              Theme.of(context).disabledColor,
                                          fontSize: 18,
                                        ),
                                  child: Text(
                                    AppLocalizations.of(context)
                                        .translate('time'),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () async {
                                    TimeOfDay _dayTime = await showTimePicker(
                                      context: context,
                                      initialTime:
                                          widget.templateHabit.timeOfDay ??
                                              TimeOfDay.now(),
                                    );
                                    setState(() {
                                      widget.templateHabit.timeOfDay = _dayTime;
                                    });
                                  },
                                  child: Row(
                                    children: <Widget>[
                                      AnimatedDefaultTextStyle(
                                        duration: Duration(milliseconds: 300),
                                        child: Text(widget
                                                    .templateHabit.timeOfDay !=
                                                null
                                            ? '${widget.templateHabit.timeOfDay.hour}:${widget.templateHabit.timeOfDay.minute.toString().length == 1 ? '0' + widget.templateHabit.timeOfDay.minute.toString() : widget.templateHabit.timeOfDay.minute}'
                                            : '12:00'),
                                        style: widget.templateHabit.hasReminder
                                            ? TextStyle(
                                                color: Theme.of(context)
                                                    .textSelectionColor,
                                                fontSize: 16,
                                              )
                                            : TextStyle(
                                                color: Theme.of(context)
                                                    .disabledColor,
                                                fontSize: 16,
                                              ),
                                      ),
                                      SizedBox(width: 7),
                                      Icon(
                                        Icons.chevron_right,
                                        color: widget.templateHabit.hasReminder
                                            ? Theme.of(context)
                                                .textSelectionColor
                                            : Theme.of(context).disabledColor,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 20),

                          ConfirmButton(
                            onPress: () {
                              // Check is user choose habit duration
                              if (_formKey.currentState.validate()) {
                                if (widget.templateHabit.duration[0] == null &&
                                    widget.templateHabit.duration[1] == null) {
                                  _scaffoldKey.currentState.showSnackBar(
                                    SnackBar(
                                      backgroundColor: Colors.redAccent,
                                      content: Text(
                                        AppLocalizations.of(context).translate(
                                          'noDurationSelectedError',
                                        ),
                                        style: TextStyle(
                                          fontSize: 16,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  );
                                  return null;
                                } else if (widget.templateHabit.duration[0] ==
                                    null) {
                                  widget.templateHabit.duration[0] =
                                      widget.templateHabit.duration[1];
                                } else if (widget.templateHabit.duration[1] ==
                                    null) {
                                  widget.templateHabit.duration[1] =
                                      widget.templateHabit.duration[0];
                                }

                                // Save data
                                _formKey.currentState.save();

                                // Change null data in habit
                                widget.templateHabit.goalAmount = widget
                                        .templateHabit.duration[0]
                                        .difference(
                                            widget.templateHabit.duration[1])
                                        .inDays
                                        .abs() +
                                    1;

                                String userId = Provider.of<UserData>(
                                  context,
                                  listen: false,
                                ).currentUserId;
                                model.createHabit(widget.templateHabit, userId);
                                Navigator.pushNamed(context, '/');
                              }
                            },
                          ),

                          SizedBox(height: 15),
                        ],
                      ),
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
