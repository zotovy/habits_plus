import 'package:flutter/material.dart';

import '../../../localization.dart';

class CreateTextField extends StatefulWidget {
  Function onSaved;
  String errorLocalizationPath;
  String Function(String) validator;
  String initValue;
  String hintPath;
  Function(String) onChanged;

  CreateTextField({
    this.onSaved,
    this.errorLocalizationPath,
    this.validator,
    this.initValue,
    this.hintPath,
    this.onChanged,
  });

  @override
  _CreateTextFieldState createState() => _CreateTextFieldState();
}

class _CreateTextFieldState extends State<CreateTextField> {
  String _submit(String value) {
    return value == '' && widget.errorLocalizationPath != null
        ? AppLocalizations.of(context).translate(
            widget.errorLocalizationPath,
          )
        : null;
  }

  @override
  void initState() {
    super.initState();
    if (widget.validator == null) {
      widget.validator = _submit;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Color(0x11000000),
      ),
      margin: EdgeInsets.symmetric(horizontal: 15),
      child: TextFormField(
        initialValue: widget.initValue,
        style: TextStyle(
          color: Theme.of(context).textSelectionHandleColor,
        ),
        validator: widget.validator,
        onSaved: widget.onSaved,
        onChanged: widget.onChanged,
        decoration: InputDecoration(
          labelStyle: TextStyle(
            color: Colors.black38,
          ),
          hintText: AppLocalizations.of(context).translate(widget.hintPath),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Theme.of(context).textSelectionColor,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          disabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white, width: 1),
            borderRadius: BorderRadius.circular(10),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              color: Theme.of(context).primaryColor,
              width: 2.5,
            ),
          ),
        ),
      ),
    );
  }
}
