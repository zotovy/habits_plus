import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';

class CirclesLoading extends StatelessWidget {
  bool needPop;
  Duration duration;

  CirclesLoading(
    this.needPop, {
    this.duration,
  });

  @override
  Widget build(BuildContext context) {
    if (needPop) {
      Future.delayed(duration).then((_) {
        Navigator.pop(context);
      });
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Container(
          width: 100,
          height: 500,
          child: FlareActor(
            'assets/flare/circleLoading.flr',
            animation: 'Untitled',
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}
