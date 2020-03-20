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

class _HabitViewOnHomePageState extends State<HabitViewOnHomePage> {
  // UI
  List<bool> openedHabits = [false, false];

  // Services
  HomeViewModel _model = locator<HomeViewModel>();

  // Functions
  Function onDoneTickPressed(HomeViewModel model, int index, int currentItem) {
    return () {
      model.updateProgressBin(index, currentItem, 1);
      String userId = Provider.of<UserData>(
        context,
        listen: false,
      ).currentUserId;
      model.updateHabit(model.todayHabits[index], userId);
    };
  }

  Function onDoneTickLongPressed(
    HomeViewModel model,
    int index,
    int currentItem,
  ) {
    return () {
      print(model.todayHabits[index].progressBin[currentItem]);
      if (model.todayHabits[index].progressBin[currentItem] == 1) {
        model.updateProgressBin(index, currentItem, 0);
      } else if (model.todayHabits[index].progressBin[currentItem] == 0) {
        model.updateProgressBin(index, currentItem, -1);
      }
      String userId = Provider.of<UserData>(
        context,
        listen: false,
      ).currentUserId;
      model.updateHabit(model.todayHabits[index], userId);
    };
  }

  Function onNotDoneTickPressed(
    HomeViewModel model,
    int index,
  ) {
    return () {
      model.addToProgressBin(index, 1);
      String userId = Provider.of<UserData>(
        context,
        listen: false,
      ).currentUserId;
      model.updateHabit(model.todayHabits[index], userId);
      if (model.todayHabits[index].progressBin.length % 7 == 0) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            // TODO: implement dialog
            return AlertDialog(
              content: Text('Nice!'),
            );
          },
        );
      }
    };
  }

  Widget _buildOpenedProgressRow(int index, HomeViewModel model) {
    int rowIndexLimit =
        ((model.todayHabits[index].progressBin.length / 7) + 0.5).round();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
            Text(
              model.todayHabits[index].description,
              style: TextStyle(
                color: Colors.white.withOpacity(0.8),
                fontSize: 16,
              ),
            ),
            SizedBox(height: 25),
          ] +
          List.generate(
            rowIndexLimit,
            (int rowIndex) {
              return Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[] +
                      List.generate(
                        rowIndex == rowIndexLimit - 1
                            ? model.todayHabits[index].progressBin.length % 7
                            : 7,
                        (int progressIndex) {
                          // Init icon
                          int currentProgressItem =
                              rowIndex * 7 + progressIndex;
                          Icon _icon = Icon(Icons.signal_cellular_null);
                          if (model.todayHabits[index]
                                  .progressBin[currentProgressItem] ==
                              1) {
                            // Done icon
                            _icon = Icon(
                              Icons.done,
                              size: 28,
                              color: Colors.white,
                            );
                          } else if (model.todayHabits[index]
                                  .progressBin[currentProgressItem] ==
                              -1) {
                            // Not executed icon
                            _icon = Icon(
                              Icons.close,
                              size: 24,
                              color: Colors.white24,
                            );
                          } else {
                            // Not marked icon
                            _icon = _icon = Icon(
                              Icons.close,
                              size: 28,
                              color: Colors.white,
                            );
                          }

                          return Container(
                            margin: EdgeInsets.all(5),
                            child: Material(
                              color: Colors.transparent,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(100)),
                              child: InkWell(
                                borderRadius: BorderRadius.circular(100),
                                onTap: onDoneTickPressed(
                                  model,
                                  index,
                                  currentProgressItem,
                                ),
                                onLongPress: onDoneTickLongPressed(
                                  model,
                                  index,
                                  currentProgressItem,
                                ),
                                child: _icon,
                              ),
                            ),
                          );
                        },
                      ) +

                      // Not marked
                      List.generate(
                        rowIndex == rowIndexLimit - 1
                            ? 7 -
                                model.todayHabits[index].progressBin.length % 7
                            : 0,
                        (int i) {
                          return Container(
                            margin: EdgeInsets.all(5),
                            child: Material(
                              color: Colors.transparent,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(100)),
                              child: InkWell(
                                borderRadius: BorderRadius.circular(100),
                                onTap: onNotDoneTickPressed(model, index),
                                child: Icon(
                                  Icons.close,
                                  size: 24,
                                  color: Colors.white24,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                ),
              );
            },
          ) +
          <Widget>[
            SizedBox(height: 5),
            GestureDetector(
              onTap: () => print('go to setting page'),
              child: Container(
                padding: EdgeInsets.only(left: 5),
                child: Icon(
                  Icons.more_horiz,
                  size: 24,
                  color: Colors.white,
                ),
              ),
            ),
          ],
    );
  }

  Widget _buildClosedProgressRow(int index, HomeViewModel model) {
    // Used in _buildHabitBox() method if box is not opened
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: List.generate(
            model.todayHabits[index].progressBin.length % 7,
            (int i) {
              int currentItem =
                  (model.todayHabits[index].progressBin.length / 7).floor() + i;
              // Init icon
              Icon _icon = Icon(Icons.signal_cellular_null);
              if (model.todayHabits[index].progressBin[currentItem] == 1) {
                // Tick
                _icon = Icon(
                  Icons.done,
                  size: 28,
                  color: Colors.white,
                );
              } else if (model.todayHabits[index].progressBin[currentItem] ==
                  -1) {
                _icon = Icon(
                  Icons.close,
                  size: 24,
                  color: Colors.white24,
                );
              } else {
                _icon = _icon = Icon(
                  Icons.close,
                  size: 28,
                  color: Colors.white,
                );
              }

              return Container(
                margin: EdgeInsets.all(5),
                child: Material(
                  color: Colors.transparent,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100)),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(100),
                    onTap: onDoneTickPressed(model, index, currentItem),
                    onLongPress:
                        onDoneTickLongPressed(model, index, currentItem),
                    child: _icon,
                  ),
                ),
              );
            },
          ) +

          // Not marked
          List.generate(
            7 - model.todayHabits[index].progressBin.length % 7,
            (int i) {
              return Container(
                margin: EdgeInsets.all(5),
                child: Material(
                  color: Colors.transparent,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100)),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(100),
                    onTap: onNotDoneTickPressed(model, index),
                    child: Icon(
                      Icons.close,
                      size: 24,
                      color: Colors.white24,
                    ),
                  ),
                ),
              );
            },
          ),
    );
  }

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
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      width: MediaQuery.of(context).size.width - 20,
      decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              offset: Offset(0, 3),
              blurRadius: 5,
              color: Theme.of(context).primaryColor.withOpacity(0.25),
            ),
          ]),
      child: Column(
        children: <Widget>[
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  child: Row(
                    children: <Widget>[
                      Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          border: Border.all(width: 1, color: Colors.white70),
                          color: colors[model.todayHabits[index].colorCode],
                          shape: BoxShape.circle,
                        ),
                      ),
                      SizedBox(width: 10),
                      Text(
                        model.todayHabits[index].title,
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                openedHabits[index]
                    ? IconButton(
                        splashColor: Colors.white12,
                        icon: Icon(Icons.arrow_drop_up),
                        color: Colors.white,
                        onPressed: () {
                          setState(() {
                            openedHabits[index] = false;
                          });
                        },
                      )
                    : IconButton(
                        splashColor: Colors.white12,
                        icon: Icon(Icons.arrow_drop_down),
                        color: Colors.white,
                        onPressed: () {
                          setState(() {
                            openedHabits[index] = true;
                          });
                        },
                      ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(bottom: 10),
            child: openedHabits[index]
                ? _buildOpenedProgressRow(index, model)
                : _buildClosedProgressRow(index, model),
          ),
        ],
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
