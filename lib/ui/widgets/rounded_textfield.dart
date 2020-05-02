import 'package:flutter/material.dart';

import 'package:habits_plus/localization.dart';

class RoundedTextField extends StatefulWidget {
  Function onSaved;
  String errorLocalizationPath;
  String labelLocalizationPath;
  Function validator;
  bool hasObscure = false;
  IconData prefix;
  String text;
  String hint;
  bool needMargin;
  EdgeInsets margin;

  RoundedTextField({
    this.onSaved,
    this.errorLocalizationPath,
    this.labelLocalizationPath,
    this.hasObscure,
    this.validator,
    this.prefix,
    this.text,
    this.hint,
    this.needMargin = true,
    this.margin = const EdgeInsets.symmetric(horizontal: 15),
  }) {
    if (hasObscure == null) hasObscure = false;
  }

  @override
  _RoundedTextFieldState createState() => _RoundedTextFieldState();
}

class _RoundedTextFieldState extends State<RoundedTextField> {
  String _submit(String value) {
    return value.trim() == '' && widget.errorLocalizationPath != null
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
      margin: widget.needMargin ? widget.margin : null,
      child: TextFormField(
        style: TextStyle(
          color: Theme.of(context).textSelectionColor,
        ),
        obscureText: widget.hasObscure,
        validator: widget.validator,
        onSaved: widget.onSaved,
        initialValue: widget.text,
        decoration: InputDecoration(
          prefixIcon: widget.prefix != null
              ? Icon(
                  widget.prefix,
                  color: Theme.of(context).textSelectionColor.withOpacity(0.25),
                )
              : null,
          hintText: AppLocalizations.of(context).translate(widget.hint),
          labelStyle: TextStyle(
            color: Colors.black38,
          ),
          labelText: AppLocalizations.of(context).translate(
            widget.labelLocalizationPath,
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
                color: Theme.of(context).textSelectionColor.withOpacity(0.25),
                width: 1),
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
