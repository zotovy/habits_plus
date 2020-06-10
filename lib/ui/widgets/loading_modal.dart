import 'package:flutter/material.dart';

class LoadingModal extends StatelessWidget {
  const LoadingModal({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).backgroundColor,
                borderRadius: BorderRadius.circular(10),
              ),
              padding: EdgeInsets.all(20),
              child: CircularProgressIndicator(),
            ),
          ],
        ),
      ),
    );
  }
}
