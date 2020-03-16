import 'package:flutter/material.dart';

class LoginButton extends StatelessWidget {
  Function onTap;
  String imagePath;
  Color color;

  LoginButton({
    this.color,
    this.imagePath,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 90,
      height: 47,
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
