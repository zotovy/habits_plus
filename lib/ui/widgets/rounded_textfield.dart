import 'package:flutter/material.dart';

import 'package:habits_plus/localization.dart';

class RoundedTextField extends StatefulWidget {
  Function onSaved;
  String errorLocalizationPath;
  String labelLocalizationPath;
  String Function(String) validator;
  bool hasObscure = false;
  IconData prefix;
  String text;
  String hint;
  bool needMargin;
  EdgeInsets margin;
  Function(String val) onChanged;
  bool isMultiLine;

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
    this.onChanged,
    this.isMultiLine = false,
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
        onChanged: widget.onChanged,
        style: TextStyle(
          color: Theme.of(context).textSelectionColor,
        ),
        keyboardType: widget.isMultiLine ? TextInputType.multiline : null,
        maxLines: widget.isMultiLine ? 10 : 1,
        obscureText: widget.hasObscure,
        validator: widget.validator ?? _submit,
        onSaved: widget.onSaved,
        initialValue: widget.text,
        decoration: InputDecoration(
          prefixIcon: widget.prefix != null
              ? Icon(
                  widget.prefix,
                  color: Theme.of(context).textSelectionColor.withOpacity(0.25),
                )
              : null,
          hintText: widget.hint == "password"
              ? "*******"
              : AppLocalizations.of(context).translate(widget.hint),
          labelStyle: TextStyle(
            color: Theme.of(context).textSelectionColor,
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
