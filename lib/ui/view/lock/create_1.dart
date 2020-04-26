import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:habits_plus/localization.dart';
import 'package:habits_plus/ui/view/lock/create_2.dart';
import 'package:habits_plus/ui/widgets/confirm_button.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class CreateLock1Screen extends StatefulWidget {
  @override
  _CreateLock1ScreenState createState() => _CreateLock1ScreenState();
}

class _CreateLock1ScreenState extends State<CreateLock1Screen>
    with SingleTickerProviderStateMixin {
  String code = '';
  List<bool> needShadow = [true, true, true, true];

  _toggle() {}

  Widget _codeElem(int i) {
    return GestureDetector(
      onTapDown: (_) => setState(() {
        needShadow[i] = false;
      }),
      onTapUp: (_) => setState(() {
        needShadow[i] = true;
      }),
      child: AnimatedContainer(
        // curve: Curves.easeInOut,
        margin: EdgeInsets.all(10),
        duration: Duration(milliseconds: 200),
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          color: Theme.of(context).brightness == Brightness.dark
              ? Colors.black
              : Colors.white,
          shape: BoxShape.circle,
          border: Border.all(
            color: code.length > i
                ? Theme.of(context).primaryColor
                : Colors.transparent,
            width: code.length > i ? 3 : 0,
          ),
          boxShadow: Theme.of(context).brightness == Brightness.dark
              ? null
              : needShadow[i]
                  ? [
                      BoxShadow(
                        blurRadius: 5,
                        color: Colors.black.withOpacity(0.05),
                        offset: Offset(1, 5),
                        spreadRadius: 3,
                      ),
                    ]
                  : [],
        ),
        child: Center(
          child: AnimatedDefaultTextStyle(
            duration: Duration(milliseconds: 300),
            style: TextStyle(
              fontSize: 18,
              color: Theme.of(context).primaryColor,
            ),
            child: Text(
              code.length - 1 >= i ? code[i] : '',
            ),
          ),
        ),
      ),
    );
  }

  Widget _numberTile(String text) {
    return text == 'empty'
        ? SizedBox.shrink()
        : Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.black
                  : Colors.white,
            ),
            child: InkWell(
              borderRadius: BorderRadius.circular(1000),
              onTap: () {
                setState(() {
                  if (text == 'del' && code.length != 0) {
                    code = code.substring(0, code.length - 1);
                  } else if (code.length < 4 && text != 'del') {
                    code += text;
                    if (code.length == 4) {
                      _toggle();
                    }
                  } else if (code.length == 4) {
                    code = text;
                  }
                });
              },
              child: Center(
                child: text == 'del'
                    ? Icon(
                        MdiIcons.backspace,
                        color: Theme.of(context).primaryColor,
                      )
                    : Text(
                        text,
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
              ),
            ),
          );
  }

  List<Widget> _ui(BuildContext context) {
    return [
      // Pincode fields
      Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            4,
            (int i) => _codeElem(i),
          ),
        ),
      ),
      SizedBox(height: 15),

      Text(
        AppLocalizations.of(context).translate('create_pincode'),
        style: TextStyle(
          color: Theme.of(context).textSelectionHandleColor,
          fontSize: 18,
        ),
      ),

      SizedBox(height: 40),

      Container(
        width: MediaQuery.of(context).size.width * 0.65,
        height: MediaQuery.of(context).size.height * 0.5,
        child: GridView.count(
          crossAxisSpacing: 15,
          mainAxisSpacing: 15,
          crossAxisCount: 3,
          children: <Widget>[
            _numberTile('1'),
            _numberTile('2'),
            _numberTile('3'),
            _numberTile('4'),
            _numberTile('5'),
            _numberTile('6'),
            _numberTile('7'),
            _numberTile('8'),
            _numberTile('9'),
            _numberTile('empty'),
            _numberTile('0'),
            _numberTile('del'),
          ],
        ),
      ),
      SizedBox(height: 10),

      // Confirm button

      AnimatedContainer(
        duration: Duration(milliseconds: 200),
        margin: EdgeInsets.symmetric(horizontal: 15),
        height: 55,
        decoration: BoxDecoration(
          color: code.length == 4
              ? Theme.of(context).primaryColor
              : Theme.of(context).disabledColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: InkWell(
          onTap: () {
            if (code.length == 4) {
              Navigator.push(
                context,
                CupertinoPageRoute(
                  builder: (_) => CreateLock2Screen(
                    code: code,
                  ),
                ),
              );
            }
          },
          child: Center(
            child: Text(
              AppLocalizations.of(context).translate('confirm'),
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
            ),
          ),
        ),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: SafeArea(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: _ui(context),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
