import 'package:calendar_strip/calendar_strip.dart';
import 'package:flutter/material.dart';
import 'package:habits_plus/core/enums/viewstate.dart';
import 'package:habits_plus/core/models/userData.dart';
import 'package:habits_plus/core/viewmodels/home_model.dart';
import 'package:habits_plus/ui/view/loading.dart';
import 'package:habits_plus/ui/widgets/home/habitView_home.dart';
import 'package:habits_plus/ui/widgets/home/taskView_home.dart';
import 'package:habits_plus/ui/widgets/motivations_cards/sync.dart';
import 'package:provider/provider.dart';

import '../../localization.dart';
import '../../locator.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with
        SingleTickerProviderStateMixin,
        AutomaticKeepAliveClientMixin<HomePage> {
  // View model
  HomeViewModel _model = locator<HomeViewModel>();

  // Animation
  Animation<double> _transitionAnimation;
  AnimationController _transitionController;
  double _transitionOpacity = 0;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    String userId = Provider.of<UserData>(
      context,
      listen: false,
    ).currentUserId;

    _transitionController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    )..addListener(() {
        setState(() {
          _transitionOpacity = _transitionAnimation.value;
        });
      });
    _transitionAnimation =
        Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
      curve: Curves.easeInOut,
      parent: _transitionController,
    ));
    _transitionController.forward();
  }

  @override
  void dispose() {
    _transitionController.dispose();
    super.dispose();
  }

  dateTileBuilder(
    date,
    selectedDate,
    rowIndex,
    dayName,
    isDateMarked,
    isDateOutOfRange,
  ) {
    bool isSelectedDate = date.compareTo(selectedDate) == 0;

    // Day style
    TextStyle normalStyle = TextStyle(
      fontSize: 17,
      fontWeight: FontWeight.w800,
      color: Theme.of(context).textSelectionColor,
    );
    TextStyle selectedStyle = TextStyle(
      fontSize: 17,
      color: Colors.white,
    );

    // Translate day
    dayName = AppLocalizations.of(context).translate(dayName);

    // Name of Day Style
    TextStyle dayNameStyle = TextStyle(
      fontSize: 12,
      color: Theme.of(context).textSelectionColor,
    );
    TextStyle daySelectedStyle = TextStyle(
      fontSize: 12,
      color: Colors.white.withOpacity(0.75),
    );

    // Build column
    List<Widget> _children = [
      Text(
        dayName,
        style: isSelectedDate ? daySelectedStyle : dayNameStyle,
      ),
      Text(
        date.day.toString(),
        style: !isSelectedDate ? normalStyle : selectedStyle,
      ),
      SizedBox(height: 5),
      isDateMarked
          ? AnimatedContainer(
              duration: Duration(milliseconds: 250),
              width: 5,
              height: 5,
              decoration: BoxDecoration(
                color: isSelectedDate
                    ? Colors.white
                    : Theme.of(context).backgroundColor,
                shape: BoxShape.circle,
              ),
            )
          : SizedBox(height: 5),
    ];

    // Build day box
    return AnimatedContainer(
      margin: EdgeInsets.symmetric(horizontal: 3),
      duration: Duration(milliseconds: 250),
      alignment: Alignment.center,
      padding: EdgeInsets.only(top: 8, left: 5, right: 5, bottom: 5),
      decoration: BoxDecoration(
        color: !isSelectedDate
            ? Colors.transparent
            : Theme.of(context).primaryColor,
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: Column(
        children: _children,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<HomeViewModel>.value(
      value: _model,
      child: Consumer<HomeViewModel>(
        builder: (_, HomeViewModel model, child) {
          return RefreshIndicator(
            onRefresh: () async => _model.fetch(),
            child: SafeArea(
              child: model.state == ViewState.Busy
                  ? LoadingPage()
                  : SingleChildScrollView(
                      child: Column(
                        children: <Widget>[
                          // Calendar
                          CalendarStrip(
                            startDate:
                                DateTime.now().subtract(Duration(days: 210)),
                            endDate: DateTime.now().add(Duration(days: 210)),
                            selectedDate: DateTime.now(),
                            markedDates: model.markedDates,
                            onDateSelected: (DateTime date) =>
                                model.setTodayWithReload(date),
                            dateTileBuilder: dateTileBuilder,
                            monthNameWidget: (String name) {
                              List _splitName = name.split(' ');
                              String monthName = _splitName.length == 5
                                  ? AppLocalizations.of(context)
                                          .translate(_splitName[0]) +
                                      ' / ' +
                                      AppLocalizations.of(context)
                                          .translate(_splitName[3])
                                  : AppLocalizations.of(context)
                                      .translate(_splitName[0]);
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  '$monthName ${_splitName.last}',
                                  style: TextStyle(
                                    color: Theme.of(context)
                                        .textSelectionHandleColor,
                                  ),
                                ),
                              );
                            },
                            iconColor:
                                Theme.of(context).textSelectionHandleColor,
                          ),

                          Opacity(
                            opacity: _transitionOpacity,
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16.0),
                              child: HabitViewOnHomePage(),
                            ),
                          ),
                          Opacity(
                            opacity: _transitionOpacity,
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16.0),
                              child: TaskViewOnHomePage(),
                            ),
                          ),
                        ],
                      ),
                    ),
            ),
          );
        },
      ),
    );
  }
}
