import 'package:flutter/material.dart';
import 'package:habits_plus/localization.dart';

class DeleteDialog extends StatelessWidget {
  final Function() onYes;

  DeleteDialog({
    this.onYes,
  });

  // ANCHOR: build choose row
  Widget _buildChooseRow(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          // No
          Container(
            height: 60,
            width: AppLocalizations.of(context).lang == 'ru' ? 145 : 127.5,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
              ),
              border: Border.all(color: Theme.of(context).disabledColor),
              color: Theme.of(context).backgroundColor,
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                ),
                onTap: () => Navigator.pop(context),
                child: Center(
                  child: Text(
                    AppLocalizations.of(context).translate('no'),
                    style: TextStyle(
                      color: Theme.of(context).textSelectionColor,
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Yes
          Container(
            height: 60,
            width: AppLocalizations.of(context).lang == 'ru' ? 145 : 127.5,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(20),
              ),
              border: Border.all(color: Theme.of(context).disabledColor),
              color: Theme.of(context).backgroundColor,
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  onYes();
                  Navigator.pop(context);
                },
                borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(20),
                ),
                child: Center(
                  child: Text(
                    AppLocalizations.of(context).translate('yes'),
                    style: TextStyle(
                      color: Theme.of(context).textSelectionColor,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pop(context),
      child: Scaffold(
        body: Center(
          child: GestureDetector(
            onTap: () {},
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).backgroundColor,
                borderRadius: BorderRadius.circular(20),
              ),
              width: AppLocalizations.of(context).lang == 'ru' ? 290 : 255,
              height: 158,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  // Title
                  Container(
                    margin: EdgeInsets.only(top: 20, left: 20, right: 20),
                    child: Text(
                      AppLocalizations.of(context).translate(
                        'delete_comment_title',
                      ),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        color: Theme.of(context).textSelectionHandleColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  SizedBox(height: 5),

                  // Title
                  Text(
                    AppLocalizations.of(context).translate(
                      'delete_comment_subtitle',
                    ),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: Theme.of(context).textSelectionColor,
                    ),
                  ),
                  SizedBox(height: 15),

                  _buildChooseRow(context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
