import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:habits_plus/core/enums/viewstate.dart';
import 'package:habits_plus/core/util/constant.dart';
import 'package:habits_plus/core/viewmodels/statistic_model.dart';
import 'package:habits_plus/localization.dart';
import 'package:habits_plus/locator.dart';
import 'package:habits_plus/ui/view/drawer.dart';
import 'package:habits_plus/ui/view/loading.dart';
import 'package:habits_plus/ui/widgets/statistic/chooseViewType.dart';
import 'package:habits_plus/ui/widgets/statistic/month_chart.dart';
import 'package:habits_plus/ui/widgets/statistic/month_stat.dart';
import 'package:habits_plus/ui/widgets/statistic/textWidgets.dart';
import 'package:habits_plus/ui/widgets/statistic/top_habits.dart';
import 'package:habits_plus/ui/widgets/statistic/week_stat.dart';
import 'package:provider/provider.dart';

class StatisticPage extends StatefulWidget {
  @override
  _StatisticPageState createState() => _StatisticPageState();
}

class _StatisticPageState extends State<StatisticPage> {
  StatisticViewModel _model = locator<StatisticViewModel>();
  bool isOpen = false;
  int currentStatTypeIndex = 0;
  PageController _pageController = PageController();

  Widget _allView(StatisticViewModel model) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Theme.of(context).backgroundColor,
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // // Choose view type
            // ChooseStatViewTypeWidget(
            //   habits: model.monthHabit,
            //   callback: (int i) {
            //     setState(() {
            //       currentStatTypeIndex = i;
            //     });
            //     _pageController.animateToPage(
            //       i,
            //       duration: Duration(milliseconds: 200),
            //       curve: Curves.easeInOut,
            //     );
            //   },
            // ),

            // // Divider
            // Padding(
            //   padding: EdgeInsets.symmetric(horizontal: 15),
            //   child: Divider(
            //     color: Theme.of(context).textSelectionColor,
            //   ),
            // ),

            // Title "THIS WEEK"
            SizedBox(height: 10),
            titleText(context, 'this_week'),
            SizedBox(height: 10),

            // Week stat
            WeekStatWidget(
              stats: model.weekStats,
            ),
            SizedBox(height: 30),

            // Title "THIS MONTH"
            titleText(context, 'this_month'),
            SizedBox(height: 5),

            // Month stat
            MonthStatWidget(
              stats: model.monthStats,
            ),
            SizedBox(height: 10),

            /// Charts
            MonthChartStats(
              monthStat: model.monthStats,
            ),
            SizedBox(height: 20),

            // Text "TOP HABITS"
            model.topHabits.length == 0
                ? SizedBox.shrink()
                : titleText(context, 'top_habits'),
            model.topHabits.length == 0
                ? SizedBox.shrink()
                : SizedBox(height: 10),

            // Top Habits Widget
            model.topHabits.length == 0
                ? SizedBox.shrink()
                : TopHabitsWidget(
                    habits: model.topHabits,
                  ),
          ],
        ),
      ),
    );
  }

  Widget _buildSingleHabitView(StatisticViewModel model, int i) {
    return model.monthHabit[i].isDisable
        ? Container(
            child: ChooseStatViewTypeWidget(
              habits: model.monthHabit,
              callback: (int i) {
                setState(() {
                  currentStatTypeIndex = i;
                });
              },
            ),
          )
        : Container(
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  // Choose view type
                  ChooseStatViewTypeWidget(
                    habits: model.monthHabit,
                    callback: (int i) {
                      setState(() {
                        currentStatTypeIndex = i;
                      });
                    },
                  ),

                  // Divider
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    child: Divider(
                      color: Theme.of(context).textSelectionColor,
                    ),
                  ),

                  // Title "THIS WEEK"
                  SizedBox(height: 10),
                  titleText(context, 'this_week'),
                  SizedBox(height: 10),

                  // Row Week Stats
                  SingleWeekStatWidget(
                    stats: model.setupSingleHabitMonthStats(i),
                  ),
                ],
              ),
            ),
          );
  }

  Widget _mainScreen(StatisticViewModel model) {
    return GestureDetector(
      onTap: () {
        if (isOpen) {
          drawerController.close();
          isOpen = false;
        } else {
          FocusScope.of(context).unfocus();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).backgroundColor,
          elevation: 0,
          leading: IconButton(
            icon: Icon(
              Icons.menu,
              color: Theme.of(context).textSelectionColor,
            ),
            onPressed: () {
              drawerController.toggle();
              isOpen = !isOpen;
            },
          ),
          centerTitle: true,
          title: Text(
            AppLocalizations.of(context).translate('statistic'),
            style: TextStyle(
              color: Theme.of(context).textSelectionHandleColor,
            ),
          ),
        ),
        body: SafeArea(
          child: PageView(
            scrollDirection: Axis.vertical,
            controller: _pageController,
            // physics: NeverScrollableScrollPhysics(),
            children: <Widget>[
                  _allView(model),
                ] +
                List.generate(
                  model.monthHabit.length,
                  (int i) => _buildSingleHabitView(model, i),
                ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _model,
      child: Consumer(
        builder: (_, StatisticViewModel model, child) {
          return model.state == ViewState.Busy
              ? LoadingPage()
              : ZoomDrawer(
                  controller: drawerController,
                  showShadow: true,
                  borderRadius: 24.0,
                  angle: 0,
                  menuScreen: CustomDrawer(),
                  mainScreen: _mainScreen(model),
                );
        },
      ),
    );
  }
}
