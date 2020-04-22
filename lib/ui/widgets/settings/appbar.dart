import 'package:flutter/material.dart';
import 'package:habits_plus/localization.dart';

class SettingsPageAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  String title;
  SettingsPageAppBar(this.title);

  @override
  Size get preferredSize => Size.fromHeight(60);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        AppLocalizations.of(context).translate(title),
        style: TextStyle(
          color: Theme.of(context).textSelectionHandleColor,
          fontSize: 18,
        ),
      ),
      centerTitle: true,
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: GestureDetector(
        onTap: () => Navigator.pop(context),
        child: Icon(
          Icons.chevron_left,
          color: Theme.of(context).textSelectionHandleColor,
          size: 28,
        ),
      ),
    );
  }
}
