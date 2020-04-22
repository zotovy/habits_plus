import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:habits_plus/core/models/theme.dart';
import 'package:habits_plus/core/util/constant.dart';
import 'package:habits_plus/localization.dart';
import 'package:habits_plus/ui/router.dart';
import 'package:habits_plus/ui/view/circles_loading.dart';
import 'package:habits_plus/ui/widgets/settings/appbar.dart';
import 'package:provider/provider.dart';

class DarkModeSettingsPage extends StatefulWidget {
  @override
  _DarkModeSettingsPageState createState() => _DarkModeSettingsPageState();
}

class _DarkModeSettingsPageState extends State<DarkModeSettingsPage>
    with SingleTickerProviderStateMixin {
  bool isDark = false;
  bool isTransitionHappend = false;
  String animation = '';
  AnimationController _slideController;
  Animation<RelativeRect> _slideAnimation;

  @override
  void initState() {
    super.initState();

    ThemeModel theme = Provider.of<ThemeModel>(context, listen: false);

    isDark = theme.isDarkMode;

    if (isDark) {
      animation = 'darkTransition';
    } else {
      animation = 'lightTransition';
    }

    _slideController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );

    Future.delayed(Duration(milliseconds: 1250)).then((_) {
      setState(() {
        isTransitionHappend = true;
      });
    });
  }

  List<Widget> _ui() {
    ThemeModel theme = Provider.of<ThemeModel>(context);

    return [
      // Illustration
      Container(
        height: 350,
        child: FlareActor(
          'assets/flare/darkmode.flr',
          fit: BoxFit.cover,
          animation: animation,
        ),
      ),
      SizedBox(height: 30),

      // Switcher
      Container(
        margin: EdgeInsets.symmetric(horizontal: 40),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            // Light mode
            GestureDetector(
              onTap: () {
                setState(() {
                  isDark = false;
                  animation = 'toLight';
                  if (theme.isDarkMode) {
                    _slideController.forward();
                  } else {
                    _slideController.reverse();
                  }
                });
              },
              child: AnimatedDefaultTextStyle(
                curve: Curves.easeInOut,
                duration: Duration(milliseconds: 250),
                style: isDark
                    ? TextStyle(
                        fontSize: 24,
                        color: Theme.of(context).disabledColor,
                      )
                    : TextStyle(
                        fontSize: 24,
                        color: Colors.white,
                      ),
                child: Text(
                  AppLocalizations.of(context).translate('lightMode'),
                ),
              ),
            ),

            // Dark Mode
            GestureDetector(
              onTap: () {
                setState(() {
                  isDark = true;
                  animation = 'toDark';
                  if (theme.isDarkMode) {
                    _slideController.reverse();
                  } else {
                    _slideController.forward();
                  }
                });
              },
              child: AnimatedDefaultTextStyle(
                curve: Curves.easeInOut,
                duration: Duration(milliseconds: 250),
                style: isDark
                    ? TextStyle(
                        fontSize: 24,
                        color: Colors.white,
                      )
                    : TextStyle(
                        fontSize: 24,
                        color: Theme.of(context).disabledColor,
                      ),
                child: Text(
                  AppLocalizations.of(context).translate('darkMode'),
                ),
              ),
            ),
          ],
        ),
      ),
      SizedBox(height: 40),

      // Confirm
      Container(
        margin: EdgeInsets.symmetric(horizontal: 15),
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: () {
            if (isDark != theme.isDarkMode) {
              if (isDark) {
                setState(() {
                  animation = 'darkStatic';
                });
              } else {
                setState(() {
                  animation = 'lightStatic';
                });
              }

              Future.delayed(Duration(milliseconds: 300)).then((onValue) {
                theme.reverseMode();
                _slideController.reverse();
              });
              Navigator.push(
                context,
                ScaleRoute(
                  page: CirclesLoading(
                    true,
                    duration: Duration(seconds: 2),
                  ),
                ),
              );
            } else {
              Navigator.pop(context);
            }
          },
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Theme.of(context).brightness == Brightness.light
                  ? Theme.of(context).primaryColor
                  : Theme.of(context).disabledColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            padding: EdgeInsets.all(10),
            child: Center(
              child: Text(
                AppLocalizations.of(context).translate('confirm'),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
          ),
        ),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    ThemeModel theme = Provider.of<ThemeModel>(context);

    _slideAnimation = RelativeRectTween(
      begin: theme.isDarkMode
          ? RelativeRect.fromLTRB(
              MediaQuery.of(context).size.width - 180,
              370,
              20,
              MediaQuery.of(context).size.height - 500,
            )
          : RelativeRect.fromLTRB(
              20,
              370,
              MediaQuery.of(context).size.width - 180,
              MediaQuery.of(context).size.height - 500,
            ),
      end: theme.isDarkMode
          ? RelativeRect.fromLTRB(
              20,
              370,
              MediaQuery.of(context).size.width - 180,
              MediaQuery.of(context).size.height - 500,
            )
          : RelativeRect.fromLTRB(
              MediaQuery.of(context).size.width - 180,
              370,
              20,
              MediaQuery.of(context).size.height - 500,
            ),
    ).animate(
      CurvedAnimation(
        curve: Curves.easeInOut,
        parent: _slideController,
      ),
    );

    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: SettingsPageAppBar('darkmode'),
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            PositionedTransition(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Theme.of(context).brightness == Brightness.light
                      ? Theme.of(context).primaryColor
                      : Theme.of(context).disabledColor.withOpacity(0.1),
                ),
              ),
              rect: _slideAnimation,
            ),
            Container(
              child: Column(
                children: _ui(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
