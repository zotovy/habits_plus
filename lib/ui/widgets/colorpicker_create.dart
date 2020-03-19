import 'package:flutter/material.dart';
import 'package:habits_plus/core/util/constant.dart';

class ColorPickerOnCreatePage extends StatefulWidget {
  int currentColorIndex;

  ColorPickerOnCreatePage({
    this.currentColorIndex,
  });

  @override
  _ColorPickerOnCreatePageState createState() =>
      _ColorPickerOnCreatePageState();
}

class _ColorPickerOnCreatePageState extends State<ColorPickerOnCreatePage> {
  Widget _buildColorBox(int i) {
    double size =
        (MediaQuery.of(context).size.width - 28 - (colors.length * 10)) /
            colors.length;
    return GestureDetector(
      onTap: () => setState(() => widget.currentColorIndex = i),
      child: AnimatedContainer(
        width: size,
        height: size,
        duration: Duration(milliseconds: 250),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            width: widget.currentColorIndex == i ? 1.5 : 0,
            color: widget.currentColorIndex == i
                ? colors[i]
                : Theme.of(context).backgroundColor,
          ),
        ),
        child: Center(
          child: Container(
            padding: EdgeInsets.all(3),
            width: size - 7,
            height: size - 7,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: colors[i],
            ),
            child: AnimatedOpacity(
              opacity: widget.currentColorIndex == i ? 1 : 0,
              duration: Duration(milliseconds: 250),
              child: Icon(
                Icons.done,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: MediaQuery.of(context).size.width - 56,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(
          colors.length,
          (int i) => _buildColorBox(i),
        ),
      ),
    );
  }
}
