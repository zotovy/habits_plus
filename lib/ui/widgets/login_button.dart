import 'package:flutter/material.dart';

class LoginButton extends StatelessWidget {
  Function onTap;
  String imagePath;
  Color color;
  double width;
  double height;

  LoginButton({
    this.color,
    this.imagePath,
    this.onTap,
    this.height,
    this.width,
  }) {
    if (width == null) width = 90;
    if (height == null) height = 47;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            offset: Offset(0, 0),
            blurRadius: 5,
            color: color.withOpacity(0.1),
          ),
        ],
      ),
      child: Material(
        borderRadius: BorderRadius.circular(20),
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          splashColor: Colors.white24,
          onTap: onTap,
          child: Container(
            padding: EdgeInsets.all(10),
            child: Image(
              image: AssetImage(imagePath),
            ),
          ),
        ),
      ),
    );
  }
}
