import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:habits_plus/core/util/constant.dart';
import 'package:habits_plus/localization.dart';
import 'package:habits_plus/ui/widgets/create/appbar.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

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

  List<AnimationController> iconFadeControllerList;
  List<Animation<double>> iconFadeAnimList;
  List<Animation<double>> iconRotationAnimList;

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
    for (var i = 0; i < iconFadeControllerList.length; i++) {
      iconFadeControllerList[i].dispose();
    }
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

    iconFadeControllerList = List.generate(
      7,
      (int i) => AnimationController(
        vsync: this,
        duration: Duration(milliseconds: 200),
      ),
    );

    iconFadeAnimList = List.generate(
      7,
      (int i) => Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(
          curve: Curves.easeInOut,
          parent: iconFadeControllerList[i],
        ),
      ),
    );

    iconRotationAnimList = List.generate(
      7,
      (int i) => Tween<double>(begin: -0.1, end: 0).animate(
        CurvedAnimation(
          curve: Curves.easeInOut,
          parent: iconFadeControllerList[i],
        ),
      ),
    );

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
                    _iconAnimation();
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

  void _iconAnimation() async {
    for (var i = 0; i < 7; i++) {
      iconFadeControllerList[i].forward();
      await Future.delayed(Duration(milliseconds: 100));
    }
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
                  child: Text(
                    AppLocalizations.of(context).translate('title_and_desc'),
                    style: TextStyle(
                      fontSize: 18,
                      color: Theme.of(context).textSelectionHandleColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
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
                    child: Text(
                      AppLocalizations.of(context)
                          .translate('createHabit1_desc1'),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Theme.of(context).textSelectionColor,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 20),

                // Title
                FadeTransition(
                  opacity: textfield1Anim,
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 15),
                    child: TextFormField(
                      style: TextStyle(
                        color: Colors.black87,
                      ),
                      decoration: InputDecoration(
                        labelStyle: TextStyle(
                          color: Colors.black38,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.black12, width: 2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        hintText: AppLocalizations.of(context)
                            .translate('noHabitTitle_hint'),
                      ),
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
                ),

                SizedBox(height: 10),

                // Description
                FadeTransition(
                  opacity: textfield2Anim,
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 15),
                    child: TextFormField(
                      style: TextStyle(
                        color: Colors.black87,
                      ),
                      decoration: InputDecoration(
                        labelStyle: TextStyle(
                          color: Colors.black38,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.black12, width: 2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        hintText: AppLocalizations.of(context)
                            .translate('noHabitDesc_hint'),
                      ),
                      onChanged: (String val) {
                        setState(() {
                          _description = val;
                        });
                      },
                    ),
                  ),
                ),

                SizedBox(height: 20),

                // Title 2
                FadeTransition(
                  opacity: title2Anim,
                  child: Text(
                    AppLocalizations.of(context).translate('choose_your_icon'),
                    style: TextStyle(
                      fontSize: 18,
                      color: Theme.of(context).textSelectionHandleColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),

                SizedBox(height: 10),

                // Page icon description
                FadeTransition(
                  opacity: desc2Anim,
                  child: Container(
                    child: Text(
                      AppLocalizations.of(context)
                          .translate('createHabit1_desc2'),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Theme.of(context).textSelectionColor,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),

                // Icon Grid
                Container(
                  height: 300,
                  child: GridView.count(
                    physics: NeverScrollableScrollPhysics(),
                    crossAxisCount: 5,
                    children: List.generate(
                      habitsIcons.length,
                      (int i) {
                        int index;
                        if ((i / 5).floor() == 0) {
                          index = i;
                        } else if ((i / 5).floor() == 1) {
                          index = i - 4;
                        } else if ((i / 5).floor() == 2) {
                          index = i - 8;
                        }

                        return GestureDetector(
                          onTap: () => setState(() {
                            _icon = i;
                          }),
                          child: RotationTransition(
                            turns: iconRotationAnimList[index],
                            child: FadeTransition(
                              opacity: iconFadeAnimList[index],
                              child: Container(
                                padding: EdgeInsets.all(5),
                                child: Icon(
                                  habitsIcons[i],
                                  color: i == _icon
                                      ? Theme.of(context).primaryColor
                                      : Theme.of(context).disabledColor,
                                  size: 36,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),

                // Confirm
                FadeTransition(
                  opacity: confirmAnim,
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
        )),
      ),
    );
  }
}
