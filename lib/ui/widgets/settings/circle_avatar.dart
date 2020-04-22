import 'package:flutter/material.dart';

class AccountCircleAvatar extends StatelessWidget {
  Function() onTap;
  ClipRRect image;

  AccountCircleAvatar({
    this.onTap,
    @required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: 100,
          height: 100,
          child: Stack(
            children: <Widget>[
              // Image
              Container(
                child: image,
                decoration: BoxDecoration(
                  color: Theme.of(context).disabledColor,
                  borderRadius: BorderRadius.circular(100),
                ),
              ),

              // Edit button
              Positioned(
                bottom: 2,
                right: 2,
                child: Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.edit,
                    color: Colors.white,
                    size: 18,
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
