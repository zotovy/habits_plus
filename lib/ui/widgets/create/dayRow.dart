import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:habits_plus/core/util/constant.dart';

import '../../../localization.dart';

class DayPickerRow extends StatefulWidget {
  Function(List<bool> progressBin) onPressed;

  DayPickerRow({
    @required this.onPressed,
  });

  @override
  _DayPickerRowState createState() => _DayPickerRowState();
}

class _DayPickerRowState extends State<DayPickerRow>
    with TickerProviderStateMixin {
  List<bool> progressBin = [false, false, false, false, false, false, false];

  // Animation
  List<AnimationController> dayRowController;
  List<Animation<double>> dayRowAnim;

  @override
  void initState() {
    super.initState();

    // Animatiooo
    dayRowController = List.generate(
      7,
      (int i) => AnimationController(
        vsync: this,
        duration: Duration(milliseconds: 200),
      ),
    );
    dayRowAnim = List.generate(
      7,
      (int i) => Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
        curve: Curves.easeInOutCubic,
        parent: dayRowController[i],
      )),
    );

    // Start animation
    Future.delayed(Duration(milliseconds: 800)).then((onValue) {
      _dayRowAnim();
    });
  }

  void _dayRowAnim() async {
    for (var i = 0; i < dayRowController.length; i++) {
      await Future.delayed(Duration(milliseconds: 50));
      dayRowController[i].forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          SizedBox(height: 10),
          FadeTransition(
            opacity: dayRowAnim[6],
            child: Align(
              alignment: Alignment.centerRight,
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    var eq = ListEquality().equals;
                    if (eq(
                      progressBin,
                      [true, true, true, true, true, true, true],
                    )) {
                      progressBin = [
                        false,
                        false,
                        false,
                        false,
                        false,
                        false,
                        false,
                      ];
                    } else {
                      progressBin = [
                        true,
                        true,
                        true,
                        true,
                        true,
                        true,
                        true,
                      ];
                    }
                  });
                  widget.onPressed(progressBin);
                },
                child: Container(
                  margin: EdgeInsets.only(right: 15),
                  child: Text(
                    AppLocalizations.of(context)
                        .translate('createHabit_everyday'),
                    style: TextStyle(
                      color: ListEquality().equals(
                        progressBin,
                        [true, true, true, true, true, true, true],
                      )
                          ? Theme.of(context).primaryColor
                          : Theme.of(context).textSelectionColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 3),
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(
                7,
                (int i) => FadeTransition(
                  opacity: dayRowAnim[i],
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        print(progressBin[i]);
                        progressBin[i] = !progressBin[i];
                        print('${progressBin[i]}\n');
                      });
                      widget.onPressed(progressBin);
                    },
                    child: AnimatedContainer(
                      duration: Duration(milliseconds: 200),
                      width: 37,
                      height: 37,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: progressBin[i]
                            ? Theme.of(context).primaryColor
                            : Theme.of(context)
                                .textSelectionColor
                                .withOpacity(0.5),
                      ),
                      child: Center(
                        child: Text(
                          AppLocalizations.of(context).lang == 'en'
                              ? AppLocalizations.of(context)
                                  .translate(dayNames[i])[0]
                              : AppLocalizations.of(context)
                                  .translate(dayNames[i]),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
