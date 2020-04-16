import 'dart:async';

import 'package:flare_flutter/asset_provider.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flare_flutter/flare_cache_builder.dart';
import 'package:flutter/material.dart';
import 'package:habits_plus/localization.dart';
import 'package:habits_plus/ui/view/loading.dart';
import 'package:habits_plus/ui/widgets/intro_circle.dart';
import 'package:habits_plus/ui/widgets/intro_page.dart';

class IntroPage extends StatefulWidget {
  @override
  _IntroPageState createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Future.delayed(
        Duration(milliseconds: 1),
        () => _IntroPage(),
      ),
      builder: (BuildContext context, snapshot) {
        if (snapshot.hasData) {
          return snapshot.data;
        }
        return LoadingPage();
      },
    );
  }
}

class _IntroPage extends StatefulWidget {
  @override
  __IntroPageState createState() => __IntroPageState();
}

class __IntroPageState extends State<_IntroPage>
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
      backgroundColor: Colors.white,
      body: Stack(
        children: <Widget>[
          Container(
            child: PageView(
              controller: pageController,
              onPageChanged: (int index) => setState(() => currentPage = index),
              children: <Widget>[
                IntroPageWidget(
                  flarePath: 'assets/flare/intro_1.flr',
                  titleLocalizationPath: 'intro_first_title',
                  subtitleLocalizationPath: 'intro_first_subtitle',
                ),
                IntroPageWidget(
                  flarePath: 'assets/flare/intro_2.flr',
                  titleLocalizationPath: 'intro_second_title',
                  subtitleLocalizationPath: 'intro_second_subtitle',
                ),
                IntroPageWidget(
                  flarePath: 'assets/flare/intro_3.flr',
                  titleLocalizationPath: 'intro_third_title',
                  subtitleLocalizationPath: 'intro_third_subtitle',
                ),
              ],
            ),
          ),

          // Skip button
          Positioned(
            top: 30,
            right: 28,
            child: GestureDetector(
              onTap: () => Navigator.pushNamed(context, 'start'),
              child: Text(
                AppLocalizations.of(context).translate('intro_skip'),
                style: TextStyle(
                  color: Theme.of(context).textSelectionHandleColor,
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
                crossAxisAlignment: CrossAxisAlignment.end,
                children: List.generate(
                  3,
                  (int i) => IntroCircleWidget(
                    onTap: () {
                      setState(() => currentPage = i);
                      pageController.jumpToPage(i);
                    },
                    isSelected: currentPage == i,
                  ),
                ),
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
                  onTap: () => Navigator.pushNamed(context, 'start'),
                  child: currentPage == 2
                      ? Text(
                          AppLocalizations.of(context).translate('intro_next'),
                          style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontSize: 16,
                          ),
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
