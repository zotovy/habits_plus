import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';

class SyncDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          width: 300,
          height: 300,
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Theme.of(context).backgroundColor,
            borderRadius: BorderRadius.circular(40),
          ),
          child: FlareActor(
            'assets/flare/done.flr',
            animation: 'transition',
            callback: (_) {
              Navigator.pop(context);
            },
          ),
        ),
      ),
    );
  }
}
