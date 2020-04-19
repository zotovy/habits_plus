import 'package:flutter/material.dart';
import 'package:habits_plus/core/util/constant.dart';
import 'package:habits_plus/localization.dart';

class DurationOnCreatePage extends StatefulWidget {
  Function onItemPressed;
  Function(DateTime fromDate, DateTime toDate) submitCustom;
  String initCurrentIndexValue;

  DurationOnCreatePage({
    this.initCurrentIndexValue,
    this.onItemPressed,
    this.submitCustom,
  });

  @override
  _DurationOnCreatePageState createState() => _DurationOnCreatePageState();
}

class _DurationOnCreatePageState extends State<DurationOnCreatePage> {
  _buildBottomDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) => ModalBottomSheet(
        submit: widget.submitCustom,
        updateParent: (String val) {
          setState(() {
            currentIndex = val;
          });
        },
      ),
    );
  }

  String currentIndex;
  List<String> _items;

  @override
  void initState() {
    super.initState();
    currentIndex = widget.initCurrentIndexValue;
  }

  @override
  Widget build(BuildContext context) {
    _items = <String>[
      AppLocalizations.of(context).translate('week'),
      AppLocalizations.of(context).translate('month'),
      AppLocalizations.of(context).translate('21_day'),
      AppLocalizations.of(context).translate('66_day'),
      AppLocalizations.of(context).translate('3_month'),
      AppLocalizations.of(context).translate('year'),
      AppLocalizations.of(context).translate('always'),
    ];
    print(currentIndex);
    return Container(
      child: Column(
        children: <Widget>[
          // Duration & Custom
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  AppLocalizations.of(context).translate('duration_create'),
                  style: TextStyle(
                    fontSize: 18,
                    color: Theme.of(context).textSelectionHandleColor,
                  ),
                ),
                GestureDetector(
                  onTap: () => _buildBottomDialog(context),
                  child: Text(
                    AppLocalizations.of(context).translate('custom'),
                    style: TextStyle(
                      fontSize: 18,
                      color: currentIndex == 'custom'
                          ? Theme.of(context).primaryColor
                          : Theme.of(context).disabledColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 10),

          // Items
          Container(
            width: double.infinity,
            height: 100,
            child: Wrap(
              alignment: WrapAlignment.start,
              children: _items
                  .map(
                    (String val) => Container(
                      margin: EdgeInsets.only(bottom: 5, right: 5),
                      child: InkWell(
                        onTap: () {
                          widget.onItemPressed(val);
                          setState(() {
                            currentIndex = val;
                          });
                        },
                        child: AnimatedContainer(
                          duration: Duration(milliseconds: 300),
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: currentIndex == val
                                ? Theme.of(context).primaryColor
                                : Theme.of(context).disabledColor,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            val,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class ModalBottomSheet extends StatefulWidget {
  Function(DateTime fromDate, DateTime toDate) submit;
  Function updateParent;

  ModalBottomSheet({
    this.submit,
    this.updateParent,
  });

  @override
  _ModalBottomSheetState createState() => _ModalBottomSheetState();
}

class _ModalBottomSheetState extends State<ModalBottomSheet> {
  DateTime fromDate = dateFormater.parse(DateTime.now().toString());
  DateTime toDate = dateFormater.parse(DateTime.now()
      .add(
        Duration(days: 30),
      )
      .toString());

  @override
  Widget build(BuildContext context) {
    // Variables
    String fromStringDate =
        '${fromDate.day.toString().length == 2 ? fromDate.day : '0' + fromDate.day.toString()}.${fromDate.month.toString().length == 2 ? fromDate.month : '0' + fromDate.month.toString()}.${fromDate.year}';
    String toStringDate =
        '${toDate.day.toString().length == 2 ? toDate.day : '0' + toDate.day.toString()}.${toDate.month.toString().length == 2 ? toDate.month : '0' + toDate.month.toString()}.${toDate.year}';

    return Container(
      padding: EdgeInsets.all(15),
      height: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        color: Theme.of(context).backgroundColor,
      ),
      child: Column(
        children: <Widget>[
          // Title
          Container(
            child: Text(
              AppLocalizations.of(context).translate('customDate_title'),
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).textSelectionHandleColor,
              ),
            ),
          ),

          // Date picker
          Container(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                // From
                Material(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                  child: InkWell(
                    onTap: () async {
                      DateTime _date = await showDatePicker(
                        context: context,
                        initialDate: fromDate,
                        firstDate: fromDate.subtract(Duration(days: 365)),
                        lastDate: fromDate.add(
                          Duration(days: 365),
                        ),
                      );
                      if (_date != null) {
                        setState(() {
                          fromDate = _date;
                        });
                      }
                    },
                    child: Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          // Text 'From'
                          Text(
                            AppLocalizations.of(context).translate('from'),
                          ),
                          Container(
                            padding: EdgeInsets.all(7),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: Theme.of(context)
                                    .primaryColor
                                    .withOpacity(0.75),
                                width: 2,
                              ),
                            ),
                            child: Row(
                              children: <Widget>[
                                Icon(
                                  Icons.today,
                                  color: Theme.of(context).textSelectionColor,
                                  size: 22,
                                ),
                                SizedBox(width: 10),
                                Text(
                                  fromStringDate,
                                  style: TextStyle(
                                    color: Theme.of(context)
                                        .textSelectionHandleColor,
                                    fontSize: 20,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // To
                Material(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                  child: InkWell(
                    onTap: () async {
                      DateTime _date = await showDatePicker(
                        context: context,
                        initialDate: toDate,
                        firstDate: toDate.subtract(Duration(days: 365)),
                        lastDate: toDate.add(
                          Duration(days: 365),
                        ),
                      );
                      print(_date);
                      if (_date != null) {
                        setState(() {
                          toDate = _date;
                        });
                      }
                    },
                    child: Container(
                      margin: EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          // Text 'From'
                          Text(
                            AppLocalizations.of(context).translate('to'),
                          ),
                          Container(
                            padding: EdgeInsets.all(7),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: Theme.of(context)
                                    .primaryColor
                                    .withOpacity(0.75),
                                width: 2,
                              ),
                            ),
                            child: Row(
                              children: <Widget>[
                                Icon(
                                  Icons.today,
                                  color: Theme.of(context).textSelectionColor,
                                  size: 22,
                                ),
                                SizedBox(width: 10),
                                Text(
                                  toStringDate,
                                  style: TextStyle(
                                    color: Theme.of(context)
                                        .textSelectionHandleColor,
                                    fontSize: 20,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Confirm
          SizedBox(height: 10),
          InkWell(
            onTap: () {
              widget.submit(fromDate, toDate);
              widget.updateParent('custom');
              Navigator.pop(context);
            },
            child: Container(
              height: 50,
              width: 200,
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Text(
                  AppLocalizations.of(context).translate('confirm'),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
