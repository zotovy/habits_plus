import 'package:configurable_expansion_tile/configurable_expansion_tile.dart';
import 'package:flutter/material.dart';
import 'package:habits_plus/core/models/habit.dart';
import 'package:habits_plus/core/models/userData.dart';
import 'package:habits_plus/core/util/constant.dart';
import 'package:habits_plus/core/viewmodels/home_model.dart';
import 'package:provider/provider.dart';

import '../../localization.dart';
import '../../locator.dart';

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

  Widget _buildHabitBox(int index, HomeViewModel model) {
    print(!model.todayHabits[index].getDoneProperty(model.currentDate));
    return Material(
      borderRadius: BorderRadius.circular(10),
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          if (!model.todayHabits[index].getDoneProperty(model.currentDate)) {
            model.addToProgressBin(index, model.currentDate);
          } else {
            model.removeFromProgressBin(index, model.currentDate);
          }
        },
        child: Container(
          padding: EdgeInsets.all(10),
          height: 70,
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 5,
                offset: Offset(1, 1),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              // title & desc
              Container(
                child: Row(
                  children: <Widget>[
                    // Icon
                    Container(
                      padding: EdgeInsets.all(3),
                      decoration: BoxDecoration(
                        color: Colors.white24,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        habitsIcons[model.habits[index].iconCode],
                        size: 36,
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
                          Text(
                            model.todayHabits[index].title,
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          model.todayHabits[index].description != ''
                              ? SizedBox(height: 3)
                              : SizedBox.shrink(),
                          model.todayHabits[index].description != ''
                              ? Text(
                                  model.todayHabits[index].description,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.white.withOpacity(0.75),
                                    // fontWeight: FontWeight.w600,
                                  ),
                                )
                              : SizedBox.shrink(),
                        ],
                      ),
                    ),

                    // Todo
                    // Progress
                    // Text(model.todayHabits[index].goalAmount),
                  ],
                ),
              ),

              // Confirm
              AnimatedContainer(
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
                  color: Theme.of(context).primaryColor,
                  size: 24,
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
          return Container(
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
                    ? _buildHabitBox(0, model)
                    : SizedBox.shrink(),
                SizedBox(height: 15),
                model.todayHabits.length >= 2
                    ? _buildHabitBox(1, model)
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
          );
        },
      ),
    );
  }
}
