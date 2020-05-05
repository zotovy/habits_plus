import 'package:flutter/material.dart';
import 'package:habits_plus/localization.dart';

class TextWidgets {
  BuildContext context;

  TextWidgets(this.context);

  Widget title(String path) => Container(
        margin: EdgeInsets.symmetric(horizontal: 15),
        child: Text(
          AppLocalizations.of(context).translate(path).toUpperCase(),
          style: TextStyle(
            fontSize: 18,
            color: Theme.of(context).textSelectionColor.withOpacity(0.75),
            fontWeight: FontWeight.w600,
          ),
        ),
      );
}
