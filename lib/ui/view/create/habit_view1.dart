import 'package:flutter/material.dart';
import 'package:habits_plus/core/util/constant.dart';
import 'package:habits_plus/localization.dart';
import 'package:habits_plus/ui/view/create/iconGrid.dart';
import 'package:habits_plus/ui/widgets/create/appbar.dart';
import 'package:habits_plus/ui/widgets/create/confirm_button.dart';
import 'package:habits_plus/ui/widgets/create/createTextField.dart';
import 'package:habits_plus/ui/widgets/create/texts.dart';

class CreateHabitView1 extends StatefulWidget {
  @override
  _CreateHabitView1State createState() => _CreateHabitView1State();
}

class _CreateHabitView1State extends State<CreateHabitView1>
    with TickerProviderStateMixin {
  int _icon = 0;
  String _title;
  String _description;

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Animation
  AnimationController title1Controller;
  Animation<double> title1Anim;

  AnimationController habitViewBoxController;
  Animation<double> habitViewBoxAnim;

  AnimationController habitViewIconController;
  Animation<double> habitViewIconAnimFade;
  bool hasHabitViewAPositionAnim = false;

  AnimationController habitViewTitleController;
  Animation<double> habitViewTitleAnim;

  AnimationController desc1Controller;
  Animation<double> desc1Anim;

  AnimationController textfield1Controller;
  Animation<double> textfield1Anim;

  AnimationController textfield2Controller;
  Animation<double> textfield2Anim;

  AnimationController title2Controller;
  Animation<double> title2Anim;

  AnimationController desc2Controller;
  Animation<double> desc2Anim;

  AnimationController confirmController;
  Animation<double> confirmAnim;

  @override
  void dispose() {
    super.dispose();
    title1Controller.dispose();
    habitViewBoxController.dispose();
    habitViewIconController.dispose();
    habitViewTitleController.dispose();
    desc1Controller.dispose();
    textfield1Controller.dispose();
    textfield2Controller.dispose();
    desc2Controller.dispose();
    confirmController.dispose();
  }

  @override
  void initState() {
    super.initState();

    // Animations
    title1Controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 400),
    );
    title1Anim = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
      curve: Curves.easeInOut,
      parent: title1Controller,
    ));

    habitViewBoxController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 700),
    );
    habitViewBoxAnim = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
      curve: Curves.easeInOutCubic,
      parent: habitViewBoxController,
    ));

    habitViewIconController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
    habitViewIconAnimFade =
        Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
      curve: Curves.easeInOutCubic,
      parent: habitViewIconController,
    ));

    habitViewTitleController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 200),
    );
    habitViewTitleAnim =
        Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
      curve: Curves.easeInOut,
      parent: habitViewTitleController,
    ));

    desc1Controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
    desc1Anim = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
      curve: Curves.easeInOut,
      parent: title1Controller,
    ));

    textfield1Controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
    textfield1Anim = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
      curve: Curves.easeInOut,
      parent: textfield1Controller,
    ));

    textfield2Controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
    textfield2Anim = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
      curve: Curves.easeInOut,
      parent: textfield2Controller,
    ));

    title2Controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 200),
    );
    title2Anim = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
      curve: Curves.easeInOut,
      parent: title2Controller,
    ));

    desc2Controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 200),
    );
    desc2Anim = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
      curve: Curves.easeInOut,
      parent: desc2Controller,
    ));

    confirmController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 200),
    );
    confirmAnim = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
      curve: Curves.easeInOut,
      parent: desc2Controller,
    ));

    // Start Animation
    Future.delayed(Duration(milliseconds: 300)).then((onValue) {
      title1Controller.forward();
      Future.delayed(Duration(milliseconds: 100)).then((onValue) {
        habitViewBoxController.forward();
        Future.delayed(Duration(milliseconds: 400)).then((onValue) {
          habitViewIconController.forward();
          setState(() {
            hasHabitViewAPositionAnim = true;
          });
          Future.delayed(Duration(milliseconds: 200)).then((onValue) {
            habitViewTitleController.forward();
          });
          desc1Controller.forward();
          Future.delayed(Duration(milliseconds: 100)).then((onValue) {
            textfield1Controller.forward();
            Future.delayed(Duration(milliseconds: 50)).then((onValue) {
              textfield2Controller.forward();
              Future.delayed(Duration(milliseconds: 100)).then((onValue) {
                title2Controller.forward();
                Future.delayed(Duration(milliseconds: 100)).then((onValue) {
                  desc2Controller.forward();
                  Future.delayed(Duration(milliseconds: 100)).then((onValue) {
                    Future.delayed(
                      Duration(milliseconds: 200),
                    ).then((onValue) {
                      confirmController.forward();
                    });
                  });
                });
              });
            });
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
        appBar: CreatePageAppBar(
          stage: 1,
        ),
        body: SafeArea(
            child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(height: 25),

                // Title
                FadeTransition(
                  opacity: title1Anim,
                  child: titleText(context, 'title_and_desc'),
                ),

                SizedBox(height: 10),

                // Habit preview
                Hero(
                  tag: 'create_HabitView',
                  flightShuttleBuilder: (
                    BuildContext flightContext,
                    Animation<double> animation,
                    HeroFlightDirection flightDirection,
                    BuildContext fromHeroContext,
                    BuildContext toHeroContext,
                  ) {
                    return Scaffold(
                      body: AnimatedContainer(
                        duration: Duration(milliseconds: 300),
                        margin: EdgeInsets.symmetric(horizontal: 15),
                        padding: EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Theme.of(context).primaryColor,
                        ),
                        child: Container(
                          padding:
                              EdgeInsets.only(bottom: 41 * animation.value),
                          child: SingleChildScrollView(
                            physics: NeverScrollableScrollPhysics(),
                            child: Column(
                              children: <Widget>[
                                Container(
                                  // Up Row
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
                                          habitsIcons[_icon],
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
                                              _title != null
                                                  ? _title.length > 25
                                                      ? _title.substring(
                                                              0, 25) +
                                                          '...'
                                                      : _title
                                                  : AppLocalizations.of(context)
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
                                                  _description != '' ? 3 : 0,
                                            ),

                                            // Description
                                            Container(
                                                child: AnimatedContainer(
                                              duration:
                                                  Duration(milliseconds: 300),
                                              height:
                                                  _description == null ? 0 : 15,
                                              child: Text(
                                                _description == null
                                                    ? ''
                                                    : _description.length > 30
                                                        ? _description
                                                                .substring(
                                                                    0, 30) +
                                                            '...'
                                                        : _description,
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
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                  child: SizeTransition(
                    sizeFactor: habitViewBoxAnim,
                    axis: Axis.vertical,
                    child: AnimatedContainer(
                      height: 75,
                      duration: Duration(milliseconds: 300),
                      margin: EdgeInsets.symmetric(horizontal: 15),
                      padding: EdgeInsets.only(
                        top: 15,
                        bottom: 15,
                        left: hasHabitViewAPositionAnim ? 15 : 0,
                        right: 15,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Theme.of(context).primaryColor,
                      ),
                      child: Row(
                        children: <Widget>[
                          // Icon
                          FadeTransition(
                            opacity: habitViewIconAnimFade,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white24,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              padding: EdgeInsets.all(5),
                              child: Icon(
                                habitsIcons[_icon],
                                size: 32,
                                color: Colors.white,
                              ),
                            ),
                          ),

                          // Title & desc
                          FadeTransition(
                            opacity: habitViewTitleAnim,
                            child: Container(
                              padding: EdgeInsets.only(left: 12.5),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  // Title
                                  Text(
                                    _title != null
                                        ? _title.length > 25
                                            ? _title.substring(0, 25) + '...'
                                            : _title
                                        : AppLocalizations.of(context)
                                            .translate('noHabitTitle_hint'),
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),

                                  // Padding
                                  AnimatedContainer(
                                    duration: Duration(milliseconds: 300),
                                    height: _description != '' ? 3 : 0,
                                  ),

                                  Container(
                                    child: Row(
                                      children: <Widget>[
                                        // Description
                                        _description != null
                                            ? AnimatedContainer(
                                                duration:
                                                    Duration(milliseconds: 300),
                                                height:
                                                    _description == '' ? 0 : 15,
                                                child: Text(
                                                  _description.length > 30
                                                      ? _description.substring(
                                                              0, 30) +
                                                          '...'
                                                      : _description,
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    color: Colors.white
                                                        .withOpacity(0.75),
                                                    // fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              )
                                            : Text(
                                                AppLocalizations.of(context)
                                                    .translate(
                                                        'noHabitDesc_hint'),
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.white
                                                      .withOpacity(0.75),
                                                  // fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                      ],
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
                ),
                SizedBox(height: 20),

                // Page title & desc description
                FadeTransition(
                  opacity: desc1Controller,
                  child: Container(
                    child: descText(context, 'createHabit1_desc1'),
                  ),
                ),

                SizedBox(height: 20),

                // Title
                FadeTransition(
                  opacity: textfield1Anim,
                  child: CreateTextField(
                    errorLocalizationPath: 'createHabit_title_error',
                    hintPath: 'noHabitTitle_hint',
                    onChanged: (String val) {
                      setState(() {
                        if (val.trim() != '') {
                          _title = val;
                        } else {
                          _title = null;
                        }
                      });
                    },
                    validator: (String val) => val.trim() == ''
                        ? AppLocalizations.of(context)
                            .translate('createHabit_title_error')
                        : null,
                  ),
                ),

                SizedBox(height: 10),

                // Description
                FadeTransition(
                  opacity: textfield2Anim,
                  child: CreateTextField(
                    hintPath: 'noHabitDesc_hint',
                    onChanged: (String val) {
                      setState(() {
                        _description = val;
                      });
                    },
                  ),
                ),

                SizedBox(height: 20),

                // Title 2
                FadeTransition(
                  opacity: title2Anim,
                  child: titleText(context, 'choose_your_icon'),
                ),

                SizedBox(height: 10),

                // Page icon description
                FadeTransition(
                  opacity: desc2Anim,
                  child: Container(
                    child: descText(context, 'createHabit1_desc2'),
                  ),
                ),

                // Icon Grid
                IconGridView(
                  onTap: (int _iconIndex) {
                    setState(() {
                      _icon = _iconIndex;
                    });
                  },
                ),

                // Confirm
                FadeTransition(
                    opacity: confirmAnim,
                    child: ConfirmButton(
                      onPress: () {
                        if (_formKey.currentState.validate()) {
                          Navigator.pushNamed(
                            context,
                            'createHabit_2',
                            arguments: [
                              _title,
                              _description == null ? '' : _description,
                              _icon
                            ],
                          );
                        }
                      },
                      stringPath: 'confirm',
                    )),

                SizedBox(height: 15),
              ],
            ),
          ),
        )),
      ),
    );
  }
}
