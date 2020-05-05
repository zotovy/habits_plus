import 'package:flutter/material.dart';
import 'package:habits_plus/core/util/constant.dart';

class IconGridView extends StatefulWidget {
  Function(int _iconIndex) onTap;

  IconGridView({
    @required this.onTap,
  });

  @override
  IconGridViewState createState() => IconGridViewState();
}

class IconGridViewState extends State<IconGridView>
    with TickerProviderStateMixin {
  int _iconIndex = 0;
  List<AnimationController> iconFadeControllerList;
  List<Animation<double>> iconFadeAnimList;
  List<Animation<double>> iconRotationAnimList;

  @override
  void dispose() {
    super.dispose();
    for (var i = 0; i < iconFadeControllerList.length; i++) {
      iconFadeControllerList[i].dispose();
    }
  }

  void _iconAnimation() async {
    for (var i = 0; i < 7; i++) {
      iconFadeControllerList[i].forward();
      await Future.delayed(Duration(milliseconds: 100));
    }
  }

  @override
  void initState() {
    super.initState();

    // Animations
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

    // Start animation
    Future.delayed(Duration(milliseconds: 1450)).then((onValue) {
      _iconAnimation();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 260,
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
              onTap: () {
                setState(() {
                  _iconIndex = i;
                });
                widget.onTap(_iconIndex);
              },
              child: RotationTransition(
                turns: iconRotationAnimList[index],
                child: FadeTransition(
                  opacity: iconFadeAnimList[index],
                  child: Container(
                    padding: EdgeInsets.all(5),
                    child: Icon(
                      habitsIcons[i],
                      color: i == _iconIndex
                          ? Theme.of(context).primaryColor
                          : Theme.of(context)
                              .textSelectionColor
                              .withOpacity(0.35),
                      size: 36,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
