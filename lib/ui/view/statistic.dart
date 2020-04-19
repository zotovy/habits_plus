import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:habits_plus/core/enums/viewstate.dart';
import 'package:habits_plus/core/util/constant.dart';
import 'package:habits_plus/core/viewmodels/statistic_model.dart';
import 'package:habits_plus/localization.dart';
import 'package:habits_plus/locator.dart';
import 'package:habits_plus/ui/view/drawer.dart';
import 'package:habits_plus/ui/view/loading.dart';
import 'package:habits_plus/ui/widgets/statistic/all_habits_stat.dart';
import 'package:habits_plus/ui/widgets/statistic/daily_perfomance.dart';
import 'package:habits_plus/ui/widgets/statistic/moth_stat.dart';
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

  List<Widget> _mainView(StatisticViewModel model) {
    return [
      SizedBox(height: 10),

      // "All Habits"
      titleText(context, 'all_habits'),
      SizedBox(height: 10),

      // All Habits row statistic
      AllHabitStatWidget(model.allHabitStatData),
      SizedBox(height: 20),

      // "This Week"
      titleText(context, 'this_week'),
      SizedBox(height: 10),

      WeekStatWidget(model.weekHabit),
      SizedBox(height: 20),

      // "This Month"
      titleText(context, 'this_month'),
      SizedBox(height: 20),

      MonthStatWidget(model.monthHabits),
      SizedBox(height: 20),

      // "Daily perfomance"
      titleText(context, 'daily_perfomance'),
      SizedBox(height: 20),

      DailyPerfomanceWidget(model.dailyProgress),
      model.topHabits.length == 0 ? SizedBox.shrink() : SizedBox(height: 20),

      // "Top habits"
      model.topHabits.length == 0
          ? SizedBox.shrink()
          : titleText(context, 'top_habits'),
      TopHabitsWidget(model.topHabits),
      SizedBox(height: 15),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _model,
      child: Consumer<StatisticViewModel>(
        builder: (_, model, child) {
          return model.state == ViewState.Busy
              ? LoadingPage()
              : GestureDetector(
                  // onTap: () => Focus.of(context).unfocus(),
                  child: Scaffold(
                    backgroundColor: Theme.of(context).backgroundColor,
                    appBar: AppBar(
                      leading: IconButton(
                        color: Theme.of(context).textSelectionHandleColor,
                        icon: Icon(EvaIcons.menu),
                        onPressed: () => drawerController.toggle(),
                      ),
                      backgroundColor: Colors.transparent,
                      elevation: 0,
                      centerTitle: true,
                      title: Text(
                        AppLocalizations.of(context).translate('statistic'),
                        style: TextStyle(
                          color: Theme.of(context).textSelectionHandleColor,
                          fontSize: 18,
                        ),
                      ),
                    ),
                    body: SafeArea(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: _mainView(model),
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
