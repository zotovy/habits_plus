import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:habits_plus/core/models/theme.dart';
import 'package:provider/provider.dart';

class SettingsMenuTile extends StatefulWidget {
  IconData icon;
  Color color;
  String text;
  Function callback;
  int i;
  bool isDarkMode;

  SettingsMenuTile({
    @required this.icon,
    @required this.color,
    @required this.text,
    @required this.callback,
    @required this.i,
    @required this.isDarkMode,
  });

  @override
  _SettingsMenuTileState createState() => _SettingsMenuTileState();
}

class _SettingsMenuTileState extends State<SettingsMenuTile> {
  bool isOn;

  @override
  void initState() {
    super.initState();
    isOn = widget.i == 1 ? widget.isDarkMode : false;
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: InkWell(
        onTap: () {
          widget.callback();
        },
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 15, vertical: 7),
          child: Row(
            children: <Widget>[
              // Icon
              Container(
                width: 45,
                height: 45,
                decoration: BoxDecoration(
                  color: widget.i == 1
                      ? Theme.of(context).textSelectionHandleColor
                      : widget.color,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Icon(
                    widget.icon,
                    color: widget.i == 1
                        ? Theme.of(context).backgroundColor
                        : Colors.white,
                    size: widget.i == 7 ? 28 : 24,
                  ),
                ),
              ),
              SizedBox(width: 10),

              // Text
              Text(
                widget.text,
                style: TextStyle(
                  color: Theme.of(context).textSelectionHandleColor,
                  fontSize: 18,
                ),
              ),

              // CallBack Icon
              Expanded(
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Icon(
                    Icons.chevron_right,
                    color:
                        Theme.of(context).textSelectionColor.withOpacity(0.65),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
