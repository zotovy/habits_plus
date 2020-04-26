import 'package:flutter/material.dart';
import 'package:habits_plus/localization.dart';

SnackBar errorSnackBar(BuildContext context, String localizedString) =>
    SnackBar(
      content: Text(
        AppLocalizations.of(context).translate(localizedString),
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.white,
        ),
      ),
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.redAccent,
    );
