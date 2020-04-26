import 'package:flutter/material.dart';

class CustomSwitch extends StatefulWidget {
  @override
  _CustomSwitchState createState() => _CustomSwitchState();
  bool value;
  Function(bool val) callback;
  bool isDisable;

  CustomSwitch({
    this.value,
    this.callback,
    this.isDisable,
  });
}

class _CustomSwitchState extends State<CustomSwitch> {
  bool isOn;

  @override
  void initState() {
    super.initState();
    isOn = widget.value;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: !widget.isDisable
          ? () => setState(() {
                isOn = !isOn;
                widget.callback(isOn);
              })
          : () {},
      child: AnimatedContainer(
        duration: Duration(microseconds: 300),
        padding: EdgeInsets.all(3),
        height: 30,
        width: 55,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          color: isOn && !widget.isDisable
              ? Theme.of(context).primaryColor
              : Theme.of(context).disabledColor,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            AnimatedContainer(
              duration: Duration(milliseconds: 200),
              margin: EdgeInsets.only(left: isOn ? 23 : 0),
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
