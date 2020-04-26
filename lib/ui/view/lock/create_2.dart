import 'package:flutter/material.dart';
import 'package:habits_plus/core/viewmodels/settings_model.dart';
import 'package:habits_plus/locator.dart';
import 'package:habits_plus/ui/widgets/confirm_button.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../../localization.dart';

class CreateLock2Screen extends StatefulWidget {
  String code;

  CreateLock2Screen({
    this.code,
  });

  @override
  _CreateLock2ScreenState createState() => _CreateLock2ScreenState();
}

class _CreateLock2ScreenState extends State<CreateLock2Screen>
    with SingleTickerProviderStateMixin {
  String confirmCode = '';
  List<bool> needShadow = [true, true, true, true];
  bool hasError = false;

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
            color: confirmCode.length > i
                ? hasError ? Colors.redAccent : Theme.of(context).primaryColor
                : Colors.transparent,
            width: confirmCode.length > i ? 3 : 0,
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
            style: hasError
                ? TextStyle(
                    fontSize: 18,
                    color: Colors.redAccent,
                  )
                : TextStyle(
                    fontSize: 18,
                    color: Theme.of(context).primaryColor,
                  ),
            child: Text(
              confirmCode.length - 1 >= i ? confirmCode[i] : '',
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
                  if (text == 'del' && confirmCode.length != 0) {
                    confirmCode =
                        confirmCode.substring(0, confirmCode.length - 1);
                    hasError = false;
                  } else if (confirmCode.length < 4 && text != 'del') {
                    confirmCode += text;
                    hasError = false;
                  } else if (confirmCode.length == 4) {
                    confirmCode = text;
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
        AppLocalizations.of(context).translate('create_pincode2'),
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
      ConfirmButton(
        text: 'confirm',
        submit: () async {
          if (confirmCode == widget.code) {
            await (locator<SettingsViewModel>().setPinCode(widget.code));
            Navigator.pushReplacementNamed(context, 'settings/security');
          } else {
            setState(() {
              hasError = true;
            });
          }
        },
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
