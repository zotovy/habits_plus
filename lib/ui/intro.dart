import 'package:flutter/material.dart';
import 'package:habits_plus/localization.dart';
import 'package:habits_plus/models/theme.dart';
import 'package:provider/provider.dart';

class IntroPage extends StatefulWidget {
  @override
  _IntroPageState createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage>
    with SingleTickerProviderStateMixin {
  // Pages
  PageController pageController;
  int currentPage = 0;

  // Animations
  Animation pageTransition;
  AnimationController pageTransitionController;

  @override
  void initState() {
    super.initState();
    pageTransitionController = AnimationController(
        duration: const Duration(milliseconds: 500), vsync: this);
    pageTransition =
        IntTween(begin: 0, end: 100).animate(pageTransitionController);
    pageController = PageController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF6C3BD0),
      body: Stack(
        children: <Widget>[
          Container(
            child: PageView(
              // pageSnapping: false,
              controller: pageController,
              onPageChanged: (int index) => setState(() => currentPage = index),
              children: <Widget>[
                Center(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 72),
                    height: MediaQuery.of(context).size.height * 0.75,
                    color: Theme.of(context).primaryColor,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          height: 300,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage('assets/images/intro-1.png'),
                            ),
                          ),
                        ),
                        SizedBox(height: 85),
                        Text(
                          AppLocalizations.of(context)
                              .translate('intro_first_title'),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          AppLocalizations.of(context)
                              .translate('intro_first_subtitle'),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Center(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 72),
                    height: MediaQuery.of(context).size.height * 0.75,
                    color: Theme.of(context).primaryColor,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          height: 300,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage('assets/images/intro-2.png'),
                            ),
                          ),
                        ),
                        SizedBox(height: 85),
                        Text(
                          AppLocalizations.of(context)
                              .translate('intro_second_title'),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          AppLocalizations.of(context)
                              .translate('intro_second_subtitle'),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Center(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 72),
                    height: MediaQuery.of(context).size.height * 0.75,
                    color: Theme.of(context).primaryColor,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          height: 300,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage('assets/images/intro-3.png'),
                            ),
                          ),
                        ),
                        SizedBox(height: 85),
                        Text(
                          AppLocalizations.of(context)
                              .translate('intro_third_title'),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          AppLocalizations.of(context)
                              .translate('intro_third_subtitle'),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Skip button
          Positioned(
            top: 30,
            right: 28,
            child: GestureDetector(
              onTap: () => Navigator.pushNamed(context, 'login_page'),
              child: Text(
                AppLocalizations.of(context).translate('intro_skip'),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.w300,
                ),
              ),
            ),
          ),

          // Circles
          Positioned(
            left: 0,
            right: 0,
            bottom: 30,
            child: AnimatedContainer(
              duration: Duration(milliseconds: 300),
              margin: currentPage == 2
                  ? EdgeInsets.only(right: 25)
                  : EdgeInsets.only(),
              padding: EdgeInsets.symmetric(horizontal: 28),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      setState(() => currentPage = 0);
                      pageController.jumpToPage(0);
                    },
                    child: AnimatedContainer(
                      duration: Duration(milliseconds: 200),
                      margin:
                          EdgeInsets.only(right: currentPage == 0 ? 10 : 15),
                      width: currentPage == 0 ? 25 : 20,
                      height: currentPage == 0 ? 25 : 20,
                      decoration: BoxDecoration(
                        boxShadow: currentPage == 0
                            ? [
                                BoxShadow(
                                  offset: Offset(0, 2),
                                  blurRadius: 5,
                                  color: Colors.black12,
                                )
                              ]
                            : null,
                        color: currentPage == 0 ? Colors.white : Colors.white24,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() => currentPage = 1);
                      pageController.jumpToPage(1);
                    },
                    child: AnimatedContainer(
                      duration: Duration(milliseconds: 200),
                      margin: EdgeInsets.only(
                          left: currentPage == 1 ? 10 : 12.5,
                          right: currentPage == 1 ? 10 : 12.5),
                      width: currentPage == 1 ? 25 : 20,
                      height: currentPage == 1 ? 25 : 20,
                      decoration: BoxDecoration(
                        boxShadow: currentPage == 1
                            ? [
                                BoxShadow(
                                  offset: Offset(0, 2),
                                  blurRadius: 5,
                                  color: Colors.black12,
                                )
                              ]
                            : null,
                        color: currentPage == 1 ? Colors.white : Colors.white24,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() => currentPage = 2);
                      pageController.jumpToPage(2);
                    },
                    child: AnimatedContainer(
                      duration: Duration(milliseconds: 200),
                      margin: EdgeInsets.only(left: currentPage == 2 ? 10 : 15),
                      width: currentPage == 2 ? 25 : 20,
                      height: currentPage == 2 ? 25 : 20,
                      decoration: BoxDecoration(
                        boxShadow: currentPage == 2
                            ? [
                                BoxShadow(
                                  offset: Offset(0, 2),
                                  blurRadius: 5,
                                  color: Colors.black12,
                                )
                              ]
                            : null,
                        color: currentPage == 2 ? Colors.white : Colors.white24,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          Positioned(
            right: MediaQuery.of(context).size.width / 2 - 125,
            bottom: 35,
            child: AnimatedContainer(
              padding: EdgeInsets.only(right: currentPage == 2 ? 20 : 45),
              duration: Duration(milliseconds: 300),
              child: AnimatedOpacity(
                duration: Duration(milliseconds: 300),
                opacity: currentPage == 2 ? 1 : 0,
                child: GestureDetector(
                  onTap: () => Navigator.pushNamed(context, 'login_page'),
                  child: currentPage == 2
                      ? Text(
                          AppLocalizations.of(context).translate('intro_next'),
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        )
                      : SizedBox.shrink(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
