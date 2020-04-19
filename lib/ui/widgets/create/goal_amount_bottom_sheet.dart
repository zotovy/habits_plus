import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../localization.dart';

class GoalAmountBottomSheet extends StatefulWidget {
  final Function(int _goalAmount) onSave;

  GoalAmountBottomSheet({
    @required this.onSave,
  });

  @override
  _GoalAmountBottomSheetState createState() => _GoalAmountBottomSheetState();
}

class _GoalAmountBottomSheetState extends State<GoalAmountBottomSheet> {
  bool get barrierDismissible => false;

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + 15,
        left: 15,
        right: 15,
        top: 15,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).backgroundColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15),
          topRight: Radius.circular(15),
        ),
      ),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              TextFormField(
                onSaved: (String val) => widget.onSave(
                  double.parse(val).toInt(),
                ),
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  WhitelistingTextInputFormatter.digitsOnly
                ],
                decoration: InputDecoration(
                  hintText:
                      AppLocalizations.of(context).translate('goal_amount'),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Theme.of(context).textSelectionColor,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                validator: (String value) => value == ''
                    ? AppLocalizations.of(context).translate('goal_amount_err')
                    : null,
              ),
              SizedBox(height: 10),
              Container(
                height: 55,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Theme.of(context).primaryColor,
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      if (_formKey.currentState.validate()) {
                        print('validea');
                        _formKey.currentState.save();
                        Navigator.pop(context);
                      }
                    },
                    child: Center(
                      child: isLoading
                          ? Text(
                              '...',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            )
                          : Text(
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
