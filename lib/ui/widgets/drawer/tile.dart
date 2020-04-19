import 'package:flutter/material.dart';
import 'package:habits_plus/core/util/constant.dart';

class DrawerTile extends StatelessWidget {
  IconData icon;
  Function() onPressed;
  String text;

  DrawerTile({
    @required this.icon,
    @required this.onPressed,
    @required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      child: InkWell(
        onTap: () {
          drawerController.close();
          Future.delayed(Duration(milliseconds: 550)).then((val) {
            onPressed();
          });
        },
        child: Container(
          padding: EdgeInsets.all(15),
          child: Row(
            children: <Widget>[
              Icon(icon, color: Theme.of(context).primaryColor),
              SizedBox(width: 10),
              Text(
                text,
                style: TextStyle(
                  fontSize: 18,
                  color: Theme.of(context).textSelectionColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
