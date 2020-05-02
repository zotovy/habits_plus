import 'package:flutter/material.dart';

import '../../../localization.dart';

class ConfirmButton extends StatelessWidget {
  String stringPath;
  Function() onPress;
  bool needMargin;
  ConfirmButton({
    this.stringPath = 'confirm',
    this.onPress,
    this.needMargin = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: needMargin ? EdgeInsets.symmetric(horizontal: 15) : null,
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Material(
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: onPress,
          child: Container(
            padding: EdgeInsets.all(15),
            child: Center(
              child: Text(
                AppLocalizations.of(context).translate(stringPath),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
