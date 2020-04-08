import 'package:flutter/material.dart';
import 'package:habits_plus/core/util/constant.dart';

class IconChooseRow extends StatefulWidget {
  Function(int index) onChosen;
  int initIconCodeValue;

  IconChooseRow({
    @required this.onChosen,
    @required this.initIconCodeValue,
  });

  @override
  _IconChooseRowState createState() => _IconChooseRowState();
}

class _IconChooseRowState extends State<IconChooseRow>
    with TickerProviderStateMixin {
  int currentIconIndex;
  ScrollController _scrollController;

  @override
  void initState() {
    super.initState();

    currentIconIndex = widget.initIconCodeValue;
    _scrollController = ScrollController(
      initialScrollOffset: 15.0 + widget.initIconCodeValue * 40,
      keepScrollOffset: true,
    );
  }

  Widget iconTile(int i) => GestureDetector(
        onTap: () {
          setState(() {
            currentIconIndex = i;
          });
          widget.onChosen(i);
        },
        child: Container(
          padding: EdgeInsets.only(right: i + 1 == habitsIcons.length ? 0 : 25),
          child: Icon(
            habitsIcons[i],
            color: i == currentIconIndex
                ? Theme.of(context).primaryColor
                : Theme.of(context).disabledColor,
            size: 42,
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 15),
      child: SingleChildScrollView(
        controller: _scrollController,
        scrollDirection: Axis.horizontal,
        child: Row(
          children: List<Widget>.generate(
            habitsIcons.length,
            (int i) => iconTile(i),
          ),
        ),
      ),
    );
  }
}
