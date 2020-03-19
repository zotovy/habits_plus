import 'package:flutter/material.dart';

import '../../localization.dart';

class ShellBottomBar extends StatefulWidget {
  Function onStatisticPressed;
  Function onHomePressed;
  int currentPage;

  ShellBottomBar({
    this.onStatisticPressed,
    this.onHomePressed,
    this.currentPage,
  });

  @override
  _ShellBottomBarState createState() => _ShellBottomBarState();
}

class _ShellBottomBarState extends State<ShellBottomBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 55,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          // Statistics
          IconButton(
            onPressed: widget.onStatisticPressed,
            icon: Icon(Icons.multiline_chart),
            color: widget.currentPage == 0
                ? Theme.of(context).textSelectionHandleColor
                : Theme.of(context).disabledColor.withOpacity(0.25),
          ),

          // Home page
          IconButton(
            onPressed: widget.onHomePressed,
            icon: Icon(Icons.apps),
            color: widget.currentPage == 1
                ? Theme.of(context).textSelectionHandleColor
                : Theme.of(context).disabledColor.withOpacity(0.25),
          ),

          // Add habit
          Container(
            margin: EdgeInsets.symmetric(),
            width: AppLocalizations.of(context).lang == 'ru' ? 125 : 90,
            height: 40,
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.circular(100),
            ),
            child: Material(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(100),
              child: InkWell(
                onTap: () => Navigator.pushNamed(context, 'create'),
                splashColor: Colors.white12,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      Icons.add,
                      color: Colors.white,
                      size: 20,
                    ),
                    SizedBox(width: 4),
                    Text(
                      AppLocalizations.of(context).translate('add'),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
