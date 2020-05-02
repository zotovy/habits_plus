import 'package:flutter/material.dart';
import 'package:habits_plus/core/enums/habitType.dart';
import 'package:habits_plus/core/models/habit.dart';
import 'package:habits_plus/localization.dart';

List<Habit> templates = [];

void setupHabitTemplates(BuildContext context) {
  templates = [
    // Do sport
    Habit(
      almostDone: 0,
      countableProgress: {},
      description: '',
      duration: [null, null],
      goalAmount: 0,
      hasReminder: true,
      iconCode: 7,
      isDisable: false,
      progressBin: [],
      repeatDays: [true, false, true, false, true, false, false],
      timeOfDay: TimeOfDay(hour: 12, minute: 0),
      timeStamp: null,
      timesADay: null,
      title: AppLocalizations.of(context).translate('template_doSport'),
      type: HabitType.Uncountable,
      comments: [],
    ),

    // Eat vegetarian
    Habit(
      almostDone: 0,
      countableProgress: {},
      description: '',
      duration: [null, null],
      goalAmount: 0,
      hasReminder: true,
      iconCode: 2,
      isDisable: false,
      progressBin: [],
      repeatDays: [true, true, true, true, true, true, true],
      timeOfDay: TimeOfDay(hour: 12, minute: 0),
      timeStamp: null,
      timesADay: null,
      title: AppLocalizations.of(context).translate('template_eatVegetarian'),
      type: HabitType.Uncountable,
    ),

    // Wake up at 5 am
    Habit(
      almostDone: 0,
      countableProgress: {},
      description: '',
      duration: [null, null],
      goalAmount: 0,
      hasReminder: true,
      iconCode: 8,
      isDisable: false,
      progressBin: [],
      repeatDays: [true, true, true, true, true, true, true],
      timeOfDay: TimeOfDay(hour: 12, minute: 0),
      timeStamp: null,
      timesADay: null,
      title: AppLocalizations.of(context).translate('template_wakeUpAt5AM'),
      type: HabitType.Uncountable,
    ),

    // Don't hang out in instagram
    Habit(
      almostDone: 0,
      countableProgress: {},
      description: '',
      duration: [null, null],
      goalAmount: 0,
      hasReminder: true,
      iconCode: 10,
      isDisable: false,
      progressBin: [],
      repeatDays: [true, true, true, true, true, false, false],
      timeOfDay: TimeOfDay(hour: 12, minute: 0),
      timeStamp: null,
      timesADay: null,
      title: AppLocalizations.of(context)
          .translate('template_dontHangOutInInstagram'),
      type: HabitType.Uncountable,
    ),

    // Make post everyday
    Habit(
      almostDone: 0,
      countableProgress: {},
      description: '',
      duration: [null, null],
      goalAmount: 0,
      hasReminder: true,
      iconCode: 9,
      isDisable: false,
      progressBin: [],
      repeatDays: [true, false, false, false, false, false, false],
      timeOfDay: TimeOfDay(hour: 12, minute: 0),
      timeStamp: null,
      timesADay: null,
      title:
          AppLocalizations.of(context).translate('template_createPostEveryday'),
      type: HabitType.Uncountable,
    ),
  ];
}
