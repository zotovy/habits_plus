import 'package:flutter/material.dart';
import 'package:habits_plus/localization.dart';

class CreatePageAppBar extends StatelessWidget implements PreferredSizeWidget {
  int stage;

  @override
  Size get preferredSize => Size.fromHeight(50);

  CreatePageAppBar({
    @required this.stage,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: Container(
        padding: EdgeInsets.all(5),
        child: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Icon(
            Icons.chevron_left,
            color: Theme.of(context).textSelectionColor,
          ),
        ),
      ),
      title: RichText(
        text: TextSpan(children: [
          TextSpan(
            text: AppLocalizations.of(context)
                    .translate('createHabit_appbar_title') +
                ' · ',
            style: TextStyle(
              color: Theme.of(context).textSelectionHandleColor,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          TextSpan(
            text: '$stage/4',
            style: TextStyle(
              color: Theme.of(context).textSelectionHandleColor,
              fontSize: 18,
            ),
          ),
        ]),
      ),
      actions: <Widget>[
        Container(
          padding: EdgeInsets.only(right: 15),
          child: GestureDetector(
            onTap: () => Navigator.pushReplacementNamed(context, '/'),
            child: Icon(
              Icons.close,
              size: 18,
              color: Theme.of(context).textSelectionColor,
            ),
          ),
        )
      ],
    );
  }
}
