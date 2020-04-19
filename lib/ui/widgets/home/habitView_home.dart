import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:habits_plus/core/enums/habitType.dart';
import 'package:habits_plus/core/models/habit.dart';
import 'package:habits_plus/core/models/userData.dart';
import 'package:habits_plus/core/util/constant.dart';
import 'package:habits_plus/core/viewmodels/home_model.dart';
import 'package:habits_plus/ui/widgets/home/countable_habit_bottomDialog.dart';
import 'package:provider/provider.dart';

import '../../../localization.dart';
import '../../../locator.dart';

class HabitViewOnHomePage extends StatefulWidget {
  @override
  _HabitViewOnHomePageState createState() => _HabitViewOnHomePageState();
}

class _HabitViewOnHomePageState extends State<HabitViewOnHomePage>
    with TickerProviderStateMixin {
  // UI
  List<bool> openedHabits = [false, false];

  // Services
  HomeViewModel _model = locator<HomeViewModel>();

  Widget _buildMoreHabits(HomeViewModel model) {
    return Container(
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: AppLocalizations.of(context).translate('habits_span_1'),
              style: TextStyle(
                color: Theme.of(context).textSelectionHandleColor,
                fontSize: 18,
              ),
            ),
            TextSpan(
              text: (model.todayHabits.length - 2).toString() +
                  AppLocalizations.of(context).translate('habits_span_2'),
              style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontSize: 18,
              ),
            ),
            TextSpan(
              text: AppLocalizations.of(context).translate('habits_span_3'),
              style: TextStyle(
                color: Theme.of(context).textSelectionHandleColor,
                fontSize: 18,
              ),
            ),
          ],
        ),
      ),
    );
  }

//========================================================================================
/*                                                                                      *
 *                                      Light mode                                      *
 *                                                                                      */
//========================================================================================

  Widget _buildLigtModeHabitBox(int index, HomeViewModel model) {
    // Need to build day row
    DateTime _firstDayOfWeek = model.currentDate.weekday != 1
        ? model.currentDate.subtract(
            Duration(days: model.currentDate.weekday - 1),
          )
        : model.currentDate;

    String progress;
    if (model.todayHabits[index].type == HabitType.Countable) {
      int done = 0;
      model.todayHabits[index].countableProgress.forEach(
        (_, elem) => done += elem[0],
      );
      progress = '$done/${model.todayHabits[index].goalAmount}';
    } else {
      progress =
          '${model.todayHabits[index].progressBin.length}/${model.todayHabits[index].goalAmount}';
    }

    return Material(
      borderRadius: BorderRadius.circular(10),
      color: Colors.transparent,
      child: InkWell(
        splashColor: Colors.white,
        onTap: () => Navigator.pushNamed(
          context,
          'habit_detail',
          arguments: model.todayHabits[index],
        ),
        child: Container(
          padding: EdgeInsets.all(10),
          height: 107,
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
              Theme.of(context).primaryColor,
              Color(0xFF8050e5),
            ]),
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 5,
                offset: Offset(1, 1),
              ),
            ],
          ),
          child: Column(
            children: <Widget>[
              // Icon, title, desc, progress & tick
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    // title & desc
                    Container(
                      child: Row(
                        children: <Widget>[
                          // Icon
                          Container(
                            padding: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              color: Colors.white24,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Icon(
                              habitsIcons[model.todayHabits[index].iconCode],
                              size: 32,
                              color: Colors.white,
                            ),
                          ),
                          // Title & desc
                          Container(
                            padding: EdgeInsets.only(left: 12.5),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                // Title
                                Hero(
                                  tag: '${model.habits[index].title}_title',
                                  child: Text(
                                    model.todayHabits[index].title.length > 25
                                        ? model.todayHabits[index].title
                                                .substring(0, 25) +
                                            '...'
                                        : model.todayHabits[index].title,
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),

                                // Padding
                                model.todayHabits[index].description != ''
                                    ? SizedBox(height: 3)
                                    : SizedBox.shrink(),

                                Container(
                                  child: Row(
                                    children: <Widget>[
                                      // Description
                                      model.todayHabits[index].description != ''
                                          ? Text(
                                              model.todayHabits[index]
                                                          .description.length >
                                                      30
                                                  ? model.todayHabits[index]
                                                          .description
                                                          .substring(0, 30) +
                                                      '...'
                                                  : model.todayHabits[index]
                                                      .description,
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.white
                                                    .withOpacity(0.75),
                                                // fontWeight: FontWeight.w600,
                                              ),
                                            )
                                          : SizedBox.shrink(),

                                      // Padding 1
                                      model.todayHabits[index].description != ''
                                          ? SizedBox(width: 5)
                                          : SizedBox.shrink(),

                                      // Circle
                                      model.todayHabits[index].description != ''
                                          ? Container(
                                              width: 5,
                                              height: 5,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: Colors.white60,
                                              ),
                                            )
                                          : SizedBox.shrink(),

                                      // Padding 2
                                      model.todayHabits[index].description != ''
                                          ? SizedBox(width: 5)
                                          : SizedBox.shrink(),

                                      // Progress
                                      Text(
                                        progress,
                                        style: TextStyle(
                                          color: Colors.white38,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 5),
                        ],
                      ),
                    ),

                    // Confirm
                    model.todayHabits[index].type == HabitType.Uncountable
                        ? InkWell(
                            onTap: () {
                              if (!model.todayHabits[index]
                                  .getDoneProperty(model.currentDate)) {
                                model.addToProgressBin(
                                    index, model.currentDate);
                              } else {
                                model.removeFromProgressBin(
                                    index, model.currentDate);
                              }
                              String userId = Provider.of<UserData>(
                                context,
                                listen: false,
                              ).currentUserId;
                              model.updateHabit(
                                  model.todayHabits[index], userId);
                            },
                            child: AnimatedContainer(
                              duration: Duration(milliseconds: 200),
                              width: 30,
                              height: 30,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(
                                  color: Colors.white,
                                  width: 2,
                                ),
                                color: model.todayHabits[index]
                                        .getDoneProperty(model.currentDate)
                                    ? Colors.white
                                    : Colors.transparent,
                              ),
                              child: Icon(
                                Icons.done,
                                color: model.todayHabits[index]
                                        .getDoneProperty(model.currentDate)
                                    ? Theme.of(context).primaryColor
                                    : Colors.transparent,
                                size: 24,
                              ),
                            ),
                          )
                        : GestureDetector(
                            child: Icon(
                              Icons.chevron_right,
                              color: Colors.white,
                            ),
                            onTap: () => showModalBottomSheet(
                              // isScrollControlled: true,
                              context: context,
                              builder: (_) => CountableHabitsBottomDialog(
                                onConfirm: (int amount, String amountType) {
                                  String userId = Provider.of<UserData>(context,
                                          listen: false)
                                      .currentUserId;
                                  model.addToCountableProgress(
                                    model.currentDate,
                                    [amount, amountType],
                                    index,
                                    userId,
                                  );
                                  return true;
                                },
                              ),
                            ),
                          ),
                  ],
                ),
              ),

              SizedBox(height: 15),
              // Day's row
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(
                    7,
                    (int i) => Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.white12,
                      ),
                      // padding: EdgeInsets.all(3),
                      child: Center(
                        child: AnimatedDefaultTextStyle(
                          duration: Duration(milliseconds: 200),
                          style: model.todayHabits[index].progressBin.contains(
                                    _firstDayOfWeek.add(
                                      Duration(days: i),
                                    ),
                                  ) ||
                                  model.todayHabits[index].countableProgress[
                                          dateFormater
                                              .parse(_firstDayOfWeek
                                                  .add(Duration(days: i))
                                                  .toString())
                                              .toString()] !=
                                      null
                              ? TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                )
                              : TextStyle(
                                  color: Colors.white30,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                          child: Text(
                            AppLocalizations.of(context).lang == 'en'
                                ? AppLocalizations.of(context)
                                    .translate(dayNames[i])[0]
                                : AppLocalizations.of(context)
                                    .translate(dayNames[i]),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

//========================================================================================
/*                                                                                      *
 *                                       Dark Mode                                      *
 *                                                                                      */
//========================================================================================

  Widget _buildDarkModeHabitBox(int index, HomeViewModel model) {
    // Need to build day row
    DateTime _firstDayOfWeek = model.currentDate.weekday != 1
        ? model.currentDate.subtract(
            Duration(days: model.currentDate.weekday - 1),
          )
        : model.currentDate;

    int last = ((MediaQuery.of(context).size.width - 152.5) ~/ 9.5).toInt();

    String progress;
    if (model.todayHabits[index].type == HabitType.Countable) {
      int done = 0;
      model.todayHabits[index].countableProgress.forEach(
        (_, elem) => done += elem[0],
      );
      progress = '$done/${model.todayHabits[index].goalAmount}';
    } else {
      progress =
          '${model.todayHabits[index].progressBin.length}/${model.todayHabits[index].goalAmount}';
    }

    return Material(
      borderRadius: BorderRadius.circular(10),
      color: Colors.transparent,
      child: InkWell(
        onTap: () => Navigator.pushNamed(
          context,
          'habit_detail',
          arguments: model.todayHabits[index],
        ),
        child: Container(
          padding: EdgeInsets.all(10),
          height: 107,
          decoration: BoxDecoration(
            // color: Theme.of(context).primaryColor,
            color: Colors.white.withOpacity(0.09),
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 5,
                offset: Offset(1, 1),
              ),
            ],
          ),
          child: Column(
            children: <Widget>[
              // Icon, title, desc, progress & tick
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    // title & desc
                    Container(
                      child: Row(
                        children: <Widget>[
                          // Icon
                          Container(
                            padding: EdgeInsets.all(5),
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Icon(
                              habitsIcons[model.todayHabits[index].iconCode],
                              size: 32,
                              color: Colors.white,
                            ),
                          ),

                          // Title & desc
                          Container(
                            padding: EdgeInsets.only(left: 12.5),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                // Title
                                Text(
                                  model.todayHabits[index].title.length > last
                                      ? model.todayHabits[index].title
                                              .substring(0, last) +
                                          '...'
                                      : model.todayHabits[index].title,
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),

                                // Padding
                                model.todayHabits[index].description != ''
                                    ? SizedBox(height: 3)
                                    : SizedBox.shrink(),

                                Container(
                                  child: Row(
                                    children: <Widget>[
                                      // Description
                                      model.todayHabits[index].description != ''
                                          ? Text(
                                              model.todayHabits[index]
                                                          .description.length >
                                                      last
                                                  ? model.todayHabits[index]
                                                          .description
                                                          .substring(0, last) +
                                                      '...'
                                                  : model.todayHabits[index]
                                                      .description,
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.white
                                                    .withOpacity(0.75),
                                                // fontWeight: FontWeight.w600,
                                              ),
                                            )
                                          : SizedBox.shrink(),

                                      // Padding 1
                                      model.todayHabits[index].description != ''
                                          ? SizedBox(width: 5)
                                          : SizedBox.shrink(),

                                      // Circle
                                      model.todayHabits[index].description != ''
                                          ? Container(
                                              width: 5,
                                              height: 5,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: Colors.white60,
                                              ),
                                            )
                                          : SizedBox.shrink(),

                                      // Padding 2
                                      model.todayHabits[index].description != ''
                                          ? SizedBox(width: 5)
                                          : SizedBox.shrink(),

                                      // Progress
                                      Text(
                                        progress,
                                        style: TextStyle(
                                          color: Colors.white38,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 5),
                        ],
                      ),
                    ),

                    // Confirm
                    model.todayHabits[index].type == HabitType.Uncountable
                        ? InkWell(
                            onTap: () {
                              if (!model.todayHabits[index]
                                  .getDoneProperty(model.currentDate)) {
                                model.addToProgressBin(
                                    index, model.currentDate);
                              } else {
                                model.removeFromProgressBin(
                                    index, model.currentDate);
                              }
                              String userId = Provider.of<UserData>(
                                context,
                                listen: false,
                              ).currentUserId;
                              model.updateHabit(
                                  model.todayHabits[index], userId);
                            },
                            child: AnimatedContainer(
                              duration: Duration(milliseconds: 200),
                              width: 30,
                              height: 30,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(
                                  color: Theme.of(context).primaryColor,
                                  width: 2,
                                ),
                                color: model.todayHabits[index]
                                        .getDoneProperty(model.currentDate)
                                    ? Theme.of(context).primaryColor
                                    : Colors.transparent,
                              ),
                              child: Icon(
                                Icons.done,
                                color: model.todayHabits[index]
                                        .getDoneProperty(model.currentDate)
                                    ? Colors.white
                                    : Colors.transparent,
                                size: 24,
                              ),
                            ),
                          )
                        : GestureDetector(
                            child: Icon(
                              Icons.chevron_right,
                              color: Colors.white,
                            ),
                            onTap: () => showModalBottomSheet(
                              // isScrollControlled: true,
                              context: context,
                              builder: (_) => CountableHabitsBottomDialog(
                                onConfirm: (int amount, String amountType) {
                                  String userId = Provider.of<UserData>(context,
                                          listen: false)
                                      .currentUserId;
                                  model.addToCountableProgress(
                                    model.currentDate,
                                    [amount, amountType],
                                    index,
                                    userId,
                                  );
                                  return true;
                                },
                              ),
                            ),
                          ),
                  ],
                ),
              ),
              SizedBox(height: 15),

              // Day's row
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(
                    7,
                    (int i) => Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: model.todayHabits[index].progressBin.contains(
                          _firstDayOfWeek.add(
                            Duration(days: i),
                          ),
                        )
                            ? Colors.white
                            : Colors.white12,
                      ),
                      child: Center(
                        child: AnimatedDefaultTextStyle(
                          duration: Duration(milliseconds: 200),
                          style: model.todayHabits[index].progressBin.contains(
                                    _firstDayOfWeek.add(
                                      Duration(days: i),
                                    ),
                                  ) ||
                                  model.todayHabits[index].countableProgress[
                                          dateFormater
                                              .parse(_firstDayOfWeek
                                                  .add(Duration(days: i))
                                                  .toString())
                                              .toString()] !=
                                      null
                              ? TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                )
                              : TextStyle(
                                  color: Colors.white60,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                          child: Text(
                            AppLocalizations.of(context).lang == 'en'
                                ? AppLocalizations.of(context)
                                    .translate(dayNames[i])[0]
                                : AppLocalizations.of(context)
                                    .translate(dayNames[i]),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<HomeViewModel>.value(
      value: _model,
      child: Consumer<HomeViewModel>(
        builder: (_, HomeViewModel model, child) {
          return model.todayHabits.length != 0
              ? Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(height: 15),
                      model.todayHabits.length > 0
                          ? Text(
                              AppLocalizations.of(context)
                                  .translate('habits_for_today')
                                  .toUpperCase(),
                              style: TextStyle(
                                fontSize: 18,
                                color: Theme.of(context)
                                    .textSelectionColor
                                    .withOpacity(0.75),
                                fontWeight: FontWeight.w600,
                              ),
                            )
                          : SizedBox.shrink(),
                      SizedBox(height: 5),
                      model.todayHabits.length >= 1
                          ? Theme.of(context).brightness == Brightness.light
                              ? _buildLigtModeHabitBox(0, model)
                              : _buildDarkModeHabitBox(0, model)
                          : SizedBox.shrink(),
                      SizedBox(height: 15),
                      model.todayHabits.length >= 2
                          ? Theme.of(context).brightness == Brightness.light
                              ? _buildLigtModeHabitBox(1, model)
                              : _buildDarkModeHabitBox(1, model)
                          : SizedBox.shrink(),
                      SizedBox(height: 15),
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            (model.todayHabits.length - 2) > 0
                                ? _buildMoreHabits(model)
                                : SizedBox.shrink(),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              : Container(
                  height: 200,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Image(
                        width: MediaQuery.of(context).size.width / 5,
                        image: AssetImage('assets/images/no_habits.png'),
                      ),
                      SizedBox(height: 15),
                      Text(
                        AppLocalizations.of(context).translate('no_habits_1'),
                        style: TextStyle(
                          color: Theme.of(context).textSelectionColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      // SizedBox(height: 7),
                      Text(
                        AppLocalizations.of(context).translate('no_habits_2'),
                        style: TextStyle(
                          color:
                              Theme.of(context).disabledColor.withOpacity(0.3),
                          fontWeight: FontWeight.w600,
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
