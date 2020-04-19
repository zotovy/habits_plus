import 'package:flutter/material.dart';
import 'package:habits_plus/localization.dart';

Widget titleText(BuildContext context, String value) => Text(
      AppLocalizations.of(context).translate(value),
      style: TextStyle(
        fontSize: 18,
        color: Theme.of(context).textSelectionHandleColor,
        fontWeight: FontWeight.w600,
      ),
    );

Widget descText(BuildContext context, String val) => Text(
      AppLocalizations.of(context).translate(val),
      textAlign: TextAlign.center,
      style: TextStyle(
        color: Theme.of(context).textSelectionColor,
        fontSize: 16,
      ),
    );
