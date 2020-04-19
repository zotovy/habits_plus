import 'dart:io';
import 'dart:math';

import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:habits_plus/core/viewmodels/detail_model.dart';
import 'package:habits_plus/localization.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class CountableHabitsBottomDialog extends StatefulWidget {
  Function(int amount, String amoungType) onConfirm;

  CountableHabitsBottomDialog({
    @required this.onConfirm,
  });

  @override
  _CountableHabitsBottomDialogState createState() =>
      _CountableHabitsBottomDialogState();
}

class _CountableHabitsBottomDialogState
    extends State<CountableHabitsBottomDialog> {
  bool get barrierDismissible => false;

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String randomHint;
  int amount;
  String amountThing;

  @override
  void initState() {
    super.initState();
    randomHint = Random().nextInt(30).toString();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom + 5,
            top: 15,
            left: 15,
            right: 15,
          ),
          decoration: BoxDecoration(
            color: Theme.of(context).backgroundColor,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Column(
            children: <Widget>[
              // Up Row
              Container(
                child: Row(
                  children: <Widget>[
                    // amount
                    Container(
                      width: 100,
                      child: TextFormField(
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          hintText: randomHint,
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Theme.of(context).textSelectionColor,
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        validator: (String value) {
                          if (value.trim() != '') {
                            try {
                              int.parse(value);
                              return null;
                            } catch (e) {
                              return AppLocalizations.of(context)
                                  .translate('habit_countable_error');
                            }
                          } else {
                            return AppLocalizations.of(context)
                                .translate('habit_countable_error');
                          }
                        },
                        onSaved: (String val) => amount = int.parse(val),
                      ),
                    ),

                    SizedBox(width: 10),

                    // amount of WHAT
                    Expanded(
                      child: TextFormField(
                        decoration: InputDecoration(
                          hintText: AppLocalizations.of(context)
                              .translate('habit_countable_example'),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Theme.of(context).textSelectionColor,
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onSaved: (String val) => amountThing = val.trim(),
                      ),
                    ),
                  ],
                ),
              ),

              // Confirm button
              SizedBox(height: 10),
              Container(
                margin: EdgeInsets.only(bottom: 10),
                height: 55,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Theme.of(context).primaryColor,
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () async {
                      if (_formKey.currentState.validate()) {
                        _formKey.currentState.save();
                        widget.onConfirm(amount, amountThing);
                        Navigator.pop(context);
                      }
                    },
                    child: Center(
                      child: Text(
                        AppLocalizations.of(context).translate('confirm'),
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
