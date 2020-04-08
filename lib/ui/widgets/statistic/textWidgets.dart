import 'package:flutter/material.dart';
import 'package:habits_plus/localization.dart';

Widget titleText(BuildContext context, String stringPath) => Container(
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: Text(
        AppLocalizations.of(context).translate(stringPath).toUpperCase(),
        style: TextStyle(
          fontSize: 18,
          color: Theme.of(context).textSelectionColor.withOpacity(0.75),
          fontWeight: FontWeight.w600,
        ),
      ),
    );
