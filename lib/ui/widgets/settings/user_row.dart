import 'package:flutter/material.dart';

class SettingsUserRow extends StatelessWidget {
  ClipRRect avatar;
  String name;
  String email;

  SettingsUserRow({
    this.avatar,
    this.name,
    this.email,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SizedBox(height: 15),

          // Avatar
          CircleAvatar(
            backgroundColor: Theme.of(context).disabledColor,
            radius: 50,
            child: avatar,
          ),
          SizedBox(height: 10),

          // Name
          Text(
            name,
            style: TextStyle(
              color: Theme.of(context).textSelectionHandleColor,
              fontWeight: FontWeight.w600,
              fontSize: 24,
            ),
          ),

          // Email
          email == null
              ? SizedBox.shrink()
              : Text(
                  email,
                  style: TextStyle(
                    color: Theme.of(context).disabledColor,
                    fontSize: 16,
                  ),
                ),
        ],
      ),
    );
  }
}
