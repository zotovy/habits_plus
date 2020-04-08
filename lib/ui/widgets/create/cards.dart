import 'package:flutter/material.dart';
import 'package:habits_plus/localization.dart';

class HabitTypeCard extends StatefulWidget {
  Function(bool value) setCountable;

  HabitTypeCard({
    @required this.setCountable,
  });

  @override
  _HabitTypeCardState createState() => _HabitTypeCardState();
}

class _HabitTypeCardState extends State<HabitTypeCard> {
  bool isCountable = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          // Uncountable
          GestureDetector(
            onTap: () {
              setState(() {
                isCountable = false;
              });
              widget.setCountable(false);
            },
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
                    AppLocalizations.of(context).translate('create_card1_desc'),
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
            onTap: () {
              setState(() {
                isCountable = true;
              });
              widget.setCountable(true);
            },
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
                    AppLocalizations.of(context).translate('create_card2_desc'),
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
    );
  }
}
