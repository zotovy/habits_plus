import 'package:flutter/material.dart';

class IntroCircleWidget extends StatefulWidget {
  Function onTap;
  bool isSelected;

  IntroCircleWidget({
    this.onTap,
    this.isSelected,
  });

  @override
  _IntroCircleWidgetState createState() => _IntroCircleWidgetState();
}

class _IntroCircleWidgetState extends State<IntroCircleWidget> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        padding: EdgeInsets.all(10),
        color: Colors.white,
        child: AnimatedContainer(
          margin: EdgeInsets.only(bottom: widget.isSelected ? 2 : 0),
          duration: Duration(milliseconds: 200),
          width: 25,
          height: 7.5,
          decoration: BoxDecoration(
            boxShadow: widget.isSelected
                ? [
                    BoxShadow(
                      offset: Offset(0, 2),
                      blurRadius: 5,
                      color: Colors.black12,
                    )
                  ]
                : null,
            color: widget.isSelected
                ? Theme.of(context).primaryColor
                : Theme.of(context).disabledColor,
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }
}
