import 'package:flutter/material.dart';

import 'package:habits_plus/localization.dart';

class ConfirmButton extends StatelessWidget {
  Function() submit;
  String text;
  double margin;

  ConfirmButton({
    this.submit,
    this.text,
    this.margin = 15,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: margin),
      height: 55,
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Material(
          child: InkWell(
            borderRadius: BorderRadius.circular(10),
            splashColor: Colors.white10,
            onTap: submit,
            child: Center(
              child: Text(
                AppLocalizations.of(context).translate(text),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
            ),
          ),
          color: Colors.transparent,
        ),
      ),
    );
  }
}
