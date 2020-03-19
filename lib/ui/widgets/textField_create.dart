import 'package:flutter/material.dart';
import 'package:habits_plus/localization.dart';

class TextFieldOnCreatePage extends StatefulWidget {
  Function onSaved;
  String labelText;
  Function validator;

  TextFieldOnCreatePage({
    this.onSaved,
    this.labelText,
    this.validator,
  });

  @override
  TextFieldOnCreatePageState createState() => TextFieldOnCreatePageState();
}

class TextFieldOnCreatePageState extends State<TextFieldOnCreatePage> {
  @override
  void initState() {
    super.initState();
    widget.validator == null
        ? widget.validator = (String value) => null
        : widget.validator;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: TextStyle(
        fontSize: 18,
      ),
      decoration: InputDecoration(
        labelText: AppLocalizations.of(context).translate(widget.labelText),
        labelStyle: TextStyle(
          fontSize: 18,
        ),
      ),
      validator: widget.validator,
      onSaved: widget.onSaved,
    );
  }
}
