import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';

import '../../localization.dart';

class IntroPageWidget extends StatelessWidget {
  String flarePath;
  String titleLocalizationPath;
  String subtitleLocalizationPath;

  IntroPageWidget({
    this.flarePath,
    this.titleLocalizationPath,
    this.subtitleLocalizationPath,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: MediaQuery.of(context).size.height * 0.75,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: Container(
                child: FlareActor(
                  flarePath,
                  alignment: Alignment.center,
                  animation: "Untitled",
                  fit: BoxFit.contain,
                ),
              ),
            ),
            // SizedBox(height: 85),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: Text(
                AppLocalizations.of(context).translate(titleLocalizationPath),
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontSize: 26,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            SizedBox(height: 5),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: Text(
                AppLocalizations.of(context)
                    .translate(subtitleLocalizationPath),
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Theme.of(context).textSelectionColor,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
