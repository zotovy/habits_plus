import 'package:flutter/material.dart';

import '../../localization.dart';

class IntroPageWidget extends StatelessWidget {
  String imageLocalizationPath;
  String titleLocalizationPath;
  String subtitleLocalizationPath;

  IntroPageWidget({
    this.imageLocalizationPath,
    this.titleLocalizationPath,
    this.subtitleLocalizationPath,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 72),
        height: MediaQuery.of(context).size.height * 0.75,
        color: Theme.of(context).primaryColor,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              height: 300,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(imageLocalizationPath),
                ),
              ),
            ),
            SizedBox(height: 85),
            Text(
              AppLocalizations.of(context).translate(titleLocalizationPath),
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 10),
            Text(
              AppLocalizations.of(context).translate(subtitleLocalizationPath),
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
