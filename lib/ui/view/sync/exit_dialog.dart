import 'package:flutter/material.dart';
import 'package:habits_plus/core/util/constant.dart';
import 'package:habits_plus/localization.dart';

class SyncExitDialog extends StatelessWidget {
  Function() onYes;
  Function() onNo;

  SyncExitDialog({
    this.onYes,
    this.onNo,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pop(context),
      child: Scaffold(
        body: Center(
          child: Container(
            padding: EdgeInsets.all(20),
            width: 360,
            height: 170,
            decoration: BoxDecoration(
              color: lightMode.backgroundColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                // Text
                Text(
                  AppLocalizations.of(context).translate('sync_dialog'),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: lightMode.textSelectionHandleColor,
                    fontSize: 18,
                  ),
                ),
                SizedBox(height: 20),

                // Data
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      // Yes
                      GestureDetector(
                        onTap: () {
                          onYes();
                          Navigator.pop(context);
                        },
                        child: Container(
                          width: 120,
                          height: 45,
                          child: Center(
                            child: Text(
                              AppLocalizations.of(context).translate('yes'),
                              style: TextStyle(
                                color: Colors.redAccent,
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ),
                      ),

                      // No
                      GestureDetector(
                        onTap: () {
                          onNo();
                          Navigator.pop(context);
                        },
                        child: Container(
                          width: 120,
                          height: 45,
                          decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Center(
                            child: Text(
                              AppLocalizations.of(context).translate('no'),
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
