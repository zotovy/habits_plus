import 'package:flutter/material.dart';
import 'package:habits_plus/core/util/constant.dart';

/// Generate Row with Icon Picker on [EditPage]
class IconRowWidget extends StatefulWidget {
  int initialIconCode;
  Function(int i) callback;

  IconRowWidget({
    @required this.initialIconCode,
    @required this.callback,
  });

  @override
  _IconRowWidgetState createState() => _IconRowWidgetState();
}

class _IconRowWidgetState extends State<IconRowWidget> {
  // Widget inside icon id variable which track current icon
  int iconCode;

  // ANCHOR: initState
  @override
  void initState() {
    iconCode = widget.initialIconCode;
    super.initState();
  }

  // ANCHOR: Icon Tile
  /// Return icon element with margin
  Widget iconTile(int i) {
    return GestureDetector(
      onTap: () {
        if (i != iconCode) {
          setState(() {
            iconCode = i;
          });
          widget.callback(i);
        }
      },
      child: Container(
        margin: EdgeInsets.only(right: 10),
        width: 40,
        height: 40,
        child: Center(
            child: Icon(
          habitsIcons[i],
          color: i == iconCode
              ? Theme.of(context).primaryColor
              : Theme.of(context).textSelectionColor.withOpacity(0.5),
        )),
      ),
    );
  }

  // ANCHOR: build
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 15),
      child: Row(
        children: <Widget>[
          // Choosen Icon Preview
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              habitsIcons[iconCode],
              color: Colors.white,
            ),
          ),

          // Divider
          Container(
            width: 1,
            height: 40,
            margin: EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              color: Theme.of(context).disabledColor,
              borderRadius: BorderRadius.circular(10),
            ),
          ),

          // Icon picker
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(
                  habitsIcons.length,
                  (int i) => iconTile(i),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
