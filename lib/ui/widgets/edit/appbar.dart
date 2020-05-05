import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:habits_plus/localization.dart';
import 'package:habits_plus/ui/widgets/edit/close_dialog.dart';

class EditAppBar {
  BuildContext context;
  bool Function() isHabitChanged;

  EditAppBar({
    this.context,
    this.isHabitChanged,
  });

  AppBar appbar() => AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        centerTitle: true,
        leading: GestureDetector(
          onTap: () {
            if (isHabitChanged()) {
              showDialog(
                context: context,
                builder: (_) => CloseDialog(
                  onYes: () => Navigator.pop(context),
                ),
              );
            } else {
              Navigator.pop(context);
            }
          },
          child: Icon(
            Icons.chevron_left,
            size: 18,
            color: Theme.of(context).textSelectionColor,
          ),
        ),
        title: Text(
          AppLocalizations.of(context).translate('edit'),
          style: TextStyle(
            fontSize: 18,
            color: Theme.of(context).textSelectionHandleColor,
          ),
        ),
        actions: <Widget>[
          GestureDetector(
            onTap: () {
              if (isHabitChanged()) {
                showDialog(
                  context: context,
                  builder: (_) => CloseDialog(
                    onYes: () => Navigator.pop(context),
                  ),
                );
              } else {
                Navigator.pop(context);
              }
            },
            child: Container(
              margin: EdgeInsets.only(right: 15),
              child: Icon(
                Icons.close,
                color: Colors.redAccent,
                size: 18,
              ),
            ),
          )
        ],
      );
}
