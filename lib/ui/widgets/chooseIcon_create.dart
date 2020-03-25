import 'package:flutter/material.dart';
import 'package:habits_plus/core/util/constant.dart';

class ChooseIconOnCreatePage extends StatefulWidget {
  Function(int i) onIconPressed;
  int currentIconIndex;

  ChooseIconOnCreatePage({
    this.currentIconIndex,
    this.onIconPressed,
  });

  @override
  _ChooseIconOnCreatePageState createState() => _ChooseIconOnCreatePageState();
}

class _ChooseIconOnCreatePageState extends State<ChooseIconOnCreatePage> {
  Widget _buildItem(int index) {
    return IconButton(
      icon: Icon(
        habitsIcons[index],
        size: 36,
        color: widget.currentIconIndex == index
            ? Theme.of(context).primaryColor
            : Theme.of(context).disabledColor,
      ),
      onPressed: () {
        widget.onIconPressed(index);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: List.generate(
            habitsIcons.length,
            (int i) => Container(
              padding: EdgeInsets.symmetric(horizontal: 7, vertical: 3),
              child: _buildItem(i),
            ),
          ),
        ),
      ),
    );
  }
}
