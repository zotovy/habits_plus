import 'package:flutter/material.dart';

import '../../localization.dart';

class LoginTextField extends StatefulWidget {
  Function onSaved;
  String errorLocalizationPath;
  String labelLocalizationPath;

  LoginTextField({
    this.onSaved,
    this.errorLocalizationPath,
    this.labelLocalizationPath,
  });

  @override
  _LoginTextFieldState createState() => _LoginTextFieldState();
}

class _LoginTextFieldState extends State<LoginTextField> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Color(0x11000000),
      ),
      margin: EdgeInsets.symmetric(horizontal: 28),
      child: TextFormField(
        validator: (value) => value == ''
            ? AppLocalizations.of(context).translate(
                widget.errorLocalizationPath,
              )
            : null,
        onSaved: widget.onSaved,
        decoration: InputDecoration(
          labelText: AppLocalizations.of(context).translate(
            widget.labelLocalizationPath,
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black12, width: 1),
            borderRadius: BorderRadius.circular(10),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }
}
