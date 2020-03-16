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
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        margin: EdgeInsets.only(right: widget.isSelected ? 10 : 15),
        width: widget.isSelected ? 25 : 20,
        height: widget.isSelected ? 25 : 20,
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
          color: widget.isSelected ? Colors.white : Colors.white24,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}
