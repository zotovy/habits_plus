import 'package:flutter/material.dart';
import 'package:habits_plus/core/services/community.dart';
import 'package:habits_plus/localization.dart';
import 'package:habits_plus/locator.dart';
import 'package:habits_plus/ui/widgets/confirm_button.dart';
import 'package:habits_plus/ui/widgets/error_snackbar.dart';
import 'package:habits_plus/ui/widgets/rounded_textfield.dart';
import 'package:habits_plus/ui/widgets/settings/appbar.dart';
import 'package:habits_plus/ui/widgets/sync/sync_dialog.dart';
import 'package:habits_plus/ui/widgets/texts.dart';

class ReportBugPage extends StatefulWidget {
  @override
  _ReportBugPageState createState() => _ReportBugPageState();
}

class _ReportBugPageState extends State<ReportBugPage> {
  // Imports
  CommunityServices _communityServices = locator<CommunityServices>();
  TextWidgets _textWidgets;

  // Form
  String _name;
  String _problem;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // ANCHOR: initState
  @override
  void initState() {
    super.initState();
    _textWidgets = TextWidgets(context);
  }

  List<Widget> _ui(context) {
    return [
      // Text
      Container(
        margin: EdgeInsets.symmetric(horizontal: 15),
        child: Text(
          AppLocalizations.of(context).translate('report_bug_text'),
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Theme.of(context).textSelectionColor,
            fontSize: 18,
          ),
        ),
      ),
      SizedBox(height: 20),

      // Name
      RoundedTextField(
        labelLocalizationPath: 'start_name',
        margin: EdgeInsets.symmetric(horizontal: 15),
        onSaved: (String value) => _name = value,
        errorLocalizationPath: 'no_name_error',
      ),
      SizedBox(height: 10),

      // Description
      RoundedTextField(
        hint: 'desc',
        margin: EdgeInsets.symmetric(horizontal: 15),
        onSaved: (String value) => _problem = value,
        errorLocalizationPath: 'no_desc_error',
        isMultiLine: true,
      ),
      SizedBox(height: 10),

      // Button
      ConfirmButton(
        text: 'report_bug',
        submit: () async {
          if (_formKey.currentState.validate()) {
            _formKey.currentState.save();
            bool code = await _communityServices.reportBug(
              context,
              _name,
              _problem,
            );

            if (!code) {
              _scaffoldKey.currentState.showSnackBar(
                errorSnackBar(context, 'save_error'),
              );
            } else {
              showDialog(
                context: context,
                builder: (_) => SyncDialog(),
              );
              Future.delayed(Duration(milliseconds: 2300)).then((_) {
                Navigator.pop(context);
              });
            }
          }
        },
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Form(
        key: _formKey,
        child: Scaffold(
          key: _scaffoldKey,
          backgroundColor: Theme.of(context).backgroundColor,
          appBar: SettingsPageAppBar('report_bug'),
          body: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: _ui(context),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
