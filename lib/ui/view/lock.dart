import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../localization.dart';

class LockScreen extends StatefulWidget {
  String need;
  Function(bool value) callback;
  bool text;

  LockScreen(this.need, {this.callback, this.text});
  @override
  _LockScreenState createState() => _LockScreenState();
}

class _LockScreenState extends State<LockScreen>
    with SingleTickerProviderStateMixin {
  String code = '';
  bool show = false;
  bool hasError = false;
  bool isSuccess = false;
  List<bool> needShadow = [true, true, true, true];

  AnimationController errorControlled;
  Animation<Offset> errorAnim;

  @override
  void initState() {
    super.initState();

    errorControlled = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 150),
    );

    errorAnim = Tween<Offset>(
      begin: Offset(0, 0),
      end: Offset(-0.05, 0.05),
    ).animate(
      CurvedAnimation(curve: Curves.easeInOut, parent: errorControlled),
    );
  }

  _toggle() {
    if (code != widget.need) {
      setState(() {
        hasError = true;
      });
      errorControlled.forward();
      Future.delayed(Duration(milliseconds: 150)).then((_) {
        errorControlled.reverse();
      });
      if (widget.callback != null) {
        widget.callback(false);
      }
    } else {
      setState(() {
        isSuccess = true;
      });
      if (widget.callback == null) {
        Future.delayed(Duration(milliseconds: 500)).then((_) {
          Navigator.pushReplacementNamed(context, 'mainShell');
        });
      } else {
        widget.callback(true);
      }
    }
  }

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
          color: !show
              ? code.length > i
                  ? hasError
                      ? Colors.redAccent
                      : isSuccess
                          ? Colors.greenAccent
                          : Theme.of(context).primaryColor
                  : Theme.of(context).brightness == Brightness.dark
                      ? Colors.black
                      : Colors.white
              : Theme.of(context).brightness == Brightness.dark
                  ? Colors.black
                  : Colors.white,
          shape: BoxShape.circle,
          border: show
              ? hasError
                  ? Border.all(
                      color: code.length > i
                          ? Colors.redAccent
                          : Colors.transparent,
                      width: code.length > i ? 3 : 0,
                    )
                  : isSuccess
                      ? Border.all(
                          color: Colors.greenAccent,
                          width: code.length > i ? 3 : 0,
                        )
                      : Border.all(
                          color: code.length > i
                              ? Theme.of(context).primaryColor
                              : Colors.transparent,
                          width: code.length > i ? 3 : 0,
                        )
              : null,
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
          child: !show
              ? SizedBox.fromSize()
              : AnimatedDefaultTextStyle(
                  duration: Duration(milliseconds: 300),
                  style: hasError
                      ? TextStyle(fontSize: 18, color: Colors.redAccent)
                      : isSuccess
                          ? TextStyle(
                              fontSize: 18,
                              color: Colors.greenAccent,
                            )
                          : TextStyle(
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
                  if (!isSuccess) {
                    if (text == 'del' && code.length != 0) {
                      code = code.substring(0, code.length - 1);
                      hasError = false;
                    } else if (code.length < 4 && text != 'del') {
                      code += text;
                      hasError = false;
                      if (code.length == 4) {
                        _toggle();
                      }
                    } else if (code.length == 4) {
                      code = text;
                      hasError = false;
                    }
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
      SlideTransition(
        position: errorAnim,
        child: Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              4,
              (int i) => _codeElem(i),
            ),
          ),
        ),
      ),
      SizedBox(height: 15),

      // Hide / Show
      widget.text == null
          ? GestureDetector(
              onTap: () {
                setState(() {
                  show = !show;
                });
              },
              child: Icon(
                show ? MdiIcons.eye : MdiIcons.eyeOff,
                size: 32,
                color: show
                    ? Theme.of(context).primaryColor
                    : Theme.of(context).disabledColor,
              ),
            )
          : Text(
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
