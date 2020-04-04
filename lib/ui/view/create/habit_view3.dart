import 'package:flutter/material.dart';
import 'package:habits_plus/core/enums/habitType.dart';
import 'package:habits_plus/core/util/constant.dart';
import 'package:habits_plus/localization.dart';
import 'package:habits_plus/ui/widgets/create/appbar.dart';

class CreateHabitView3 extends StatefulWidget {
  String title;
  String desc;
  int iconCode;
  List<bool> progressBin;
  List<DateTime> duration;

  CreateHabitView3({
    this.title,
    this.desc,
    this.iconCode,
    this.progressBin,
    this.duration,
  });

  @override
  _CreateHabitView3State createState() => _CreateHabitView3State();
}

class _CreateHabitView3State extends State<CreateHabitView3>
    with TickerProviderStateMixin {
  bool isDone = true;
  bool isCountable = false;

  // Animation
  AnimationController _checkboxController;
  Animation<double> _checkboxAnim;

  AnimationController _checkboxTransitionController;
  Animation<double> _checkboxTransitionAnim;

  AnimationController _descTransitionController;
  Animation<double> _descTransitionAnim;

  AnimationController _cardsTransitionFadeController;
  Animation<double> _cardsTransitionFadeAnim;

  AnimationController _confirmButtonTransitionController;
  Animation<double> _confirmButtonTransitionAnim;

  @override
  void initState() {
    super.initState();

    // Animation
    _checkboxController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
    _checkboxAnim = Tween<double>(begin: 1, end: 0).animate(CurvedAnimation(
      curve: Curves.bounceOut,
      parent: _checkboxController,
    ));

    _checkboxTransitionController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 400),
    );
    _checkboxTransitionAnim =
        Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
      curve: Curves.bounceInOut,
      parent: _checkboxTransitionController,
    ));

    _descTransitionController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
    _descTransitionAnim =
        Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
      curve: Curves.easeInOutCubic,
      parent: _descTransitionController,
    ));

    _cardsTransitionFadeController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 400),
    );
    _cardsTransitionFadeAnim =
        Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
      curve: Curves.easeInOutCubic,
      parent: _cardsTransitionFadeController,
    ));

    _confirmButtonTransitionController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 400),
    );
    _confirmButtonTransitionAnim =
        Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
      curve: Curves.easeInOutCubic,
      parent: _confirmButtonTransitionController,
    ));

    // Start animation
    Future.delayed(Duration(milliseconds: 300)).then((onValue) {
      _checkboxTransitionController.forward();
      Future.delayed(Duration(milliseconds: 200)).then((onValue) {
        _descTransitionController.forward();
        Future.delayed(Duration(milliseconds: 200)).then((onValue) {
          _cardsTransitionFadeController.forward();
          Future.delayed(Duration(milliseconds: 200)).then((onValue) {
            _confirmButtonTransitionController.forward();
          });
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        appBar: CreatePageAppBar(stage: 3),
        body: SafeArea(
          child: Container(
            width: double.infinity,
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  SizedBox(height: 25),

                  // "Habit Type"
                  Text(
                    AppLocalizations.of(context).translate('habit_type'),
                    style: TextStyle(
                      fontSize: 18,
                      color: Theme.of(context).textSelectionHandleColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 10),

                  // Habit View
                  Hero(
                    tag: 'create_HabitView',
                    child: AnimatedContainer(
                      duration: Duration(milliseconds: 300),
                      margin: EdgeInsets.symmetric(horizontal: 15),
                      padding: EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Theme.of(context).primaryColor,
                      ),
                      child: Container(
                        child: Column(
                          children: <Widget>[
                            Container(
                              // Up Row
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  // Icon, Title & desc
                                  Container(
                                    child: Row(
                                      children: <Widget>[
                                        // Icon
                                        Container(
                                          decoration: BoxDecoration(
                                            color: Colors.white24,
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          padding: EdgeInsets.all(5),
                                          child: Icon(
                                            habitsIcons[widget.iconCode],
                                            size: 32,
                                            color: Colors.white,
                                          ),
                                        ),

                                        // Title & desc
                                        Container(
                                          padding: EdgeInsets.only(left: 12.5),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: <Widget>[
                                              // Title
                                              Text(
                                                widget.title != null
                                                    ? widget.title.length > 25
                                                        ? widget.title
                                                                .substring(
                                                                    0, 25) +
                                                            '...'
                                                        : widget.title
                                                    : AppLocalizations.of(
                                                            context)
                                                        .translate(
                                                            'noHabitTitle_hint'),
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),

                                              // Padding
                                              AnimatedContainer(
                                                duration:
                                                    Duration(milliseconds: 300),
                                                height:
                                                    widget.desc != '' ? 3 : 0,
                                              ),

                                              // Description
                                              Container(
                                                  child: AnimatedContainer(
                                                duration:
                                                    Duration(milliseconds: 300),
                                                height:
                                                    widget.desc == '' ? 0 : 15,
                                                child: Text(
                                                  widget.desc.length > 30
                                                      ? widget.desc.substring(
                                                              0, 30) +
                                                          '...'
                                                      : widget.desc,
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    color: Colors.white
                                                        .withOpacity(0.75),
                                                    // fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              )),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  // Checkbox
                                  ScaleTransition(
                                    scale: _checkboxTransitionAnim,
                                    child: GestureDetector(
                                      onTap: () => setState(() {
                                        isDone = !isDone;
                                        if (_checkboxController.isCompleted) {
                                          _checkboxController.reverse();
                                        } else {
                                          _checkboxController.forward();
                                        }
                                      }),
                                      child: AnimatedContainer(
                                        duration: Duration(milliseconds: 200),
                                        width: 30,
                                        height: 30,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(6),
                                          border: !isCountable
                                              ? Border.all(
                                                  color: Colors.white,
                                                  width: 2,
                                                )
                                              : null,
                                          color: isDone && !isCountable
                                              ? Colors.white
                                              : Colors.transparent,
                                        ),
                                        child: !isCountable
                                            ? FadeTransition(
                                                opacity: _checkboxAnim,
                                                child: Icon(
                                                  Icons.done,
                                                  color: isDone
                                                      ? Theme.of(context)
                                                          .primaryColor
                                                      : Colors.transparent,
                                                  size: 24,
                                                ),
                                              )
                                            : Icon(
                                                Icons.chevron_right,
                                                color: Colors.white,
                                                size: 28,
                                              ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            SizedBox(height: 10),

                            // Days
                            Container(
                              height: 31,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                                        style: widget.progressBin[i]
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
                                          AppLocalizations.of(context).lang ==
                                                  'en'
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
                  ),
                  SizedBox(height: 20),

                  // Description
                  FadeTransition(
                    opacity: _descTransitionAnim,
                    child: Text(
                      AppLocalizations.of(context).translate('habit_type_desc'),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Theme.of(context).textSelectionColor,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),

                  // Cards
                  FadeTransition(
                    opacity: _cardsTransitionFadeAnim,
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          // Uncountable
                          GestureDetector(
                            onTap: () => setState(() {
                              isCountable = false;
                            }),
                            child: Container(
                              width: MediaQuery.of(context).size.width / 2 - 40,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: !isCountable
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
                              height: 250,
                              padding: EdgeInsets.all(15),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
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
                                        .translate('create_card1_example'),
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.white.withOpacity(0.75),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          // Countable
                          GestureDetector(
                            onTap: () => setState(() {
                              isCountable = true;
                            }),
                            child: Container(
                              width: MediaQuery.of(context).size.width / 2 - 40,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: isCountable
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
                              height: 250,
                              padding: EdgeInsets.all(15),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
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
                                        .translate('create_card2_example'),
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.white.withOpacity(0.75),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 20),

                  // Confirm
                  FadeTransition(
                    opacity: _confirmButtonTransitionAnim,
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 15),
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Material(
                        child: InkWell(
                          borderRadius: BorderRadius.circular(10),
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              'createHabit_4',
                              arguments: [
                                widget.title,
                                widget.desc,
                                widget.iconCode,
                                widget.progressBin,
                                widget.duration,
                                isCountable
                                    ? HabitType.Countable
                                    : HabitType.Uncountable,
                              ],
                            );
                          },
                          child: Container(
                            padding: EdgeInsets.all(15),
                            child: Center(
                              child: Text(
                                AppLocalizations.of(context)
                                    .translate('intro_next'),
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 15),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
