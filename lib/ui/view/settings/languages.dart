import 'package:flutter/material.dart';
import 'package:habits_plus/core/enums/viewstate.dart';
import 'package:habits_plus/core/models/locale.dart';
import 'package:habits_plus/core/viewmodels/settings_model.dart';
import 'package:habits_plus/localization.dart';
import 'package:habits_plus/locator.dart';
import 'package:habits_plus/main.dart';
import 'package:habits_plus/ui/router.dart';
import 'package:habits_plus/ui/view/circles_loading.dart';
import 'package:habits_plus/ui/view/loading.dart';
import 'package:habits_plus/ui/widgets/error_snackbar.dart';
import 'package:habits_plus/ui/widgets/settings/appbar.dart';
import 'package:provider/provider.dart';

class LanguagesSettingsPage extends StatefulWidget {
  @override
  _LanguagesSettingsPageState createState() => _LanguagesSettingsPageState();
}

class _LanguagesSettingsPageState extends State<LanguagesSettingsPage> {
  SettingsViewModel _model = locator<SettingsViewModel>();
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  Widget _tile(SettingsViewModel model, int i) {
    bool isCurrentLocalization = AppLocalizations.of(context).lang ==
        AppLocalizations.of(context).supportedLanguages.keys.toList()[i];
    String code =
        AppLocalizations.of(context).supportedLanguages.keys.toList()[i];

    return InkWell(
      onTap: () {
        Future.delayed(Duration(milliseconds: 200)).then((_) async {
          bool dbcode = await model.setLocale(context, code);
          if (!dbcode) {
            _scaffoldKey.currentState.showSnackBar(
              errorSnackBar(context, 'save_error'),
            );
          }
        });
        Navigator.push(
          context,
          ScaleRoute(
            page: CirclesLoading(
              true,
              duration: Duration(seconds: 2),
            ),
          ),
        );
      },
      splashColor: Theme.of(context).disabledColor,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        margin: EdgeInsets.only(bottom: 1),
        // decoration: BoxDecoration(
        //   color: Theme.of(context).backgroundColor,
        //   boxShadow: [
        //     // BoxShadow(
        //     //   offset: Offset(0, 1),
        //     //   color: Theme.of(context).disabledColor,
        //     // ),
        //     BoxShadow(
        //       offset: Offset(0, -1),
        //       color: Theme.of(context).disabledColor,
        //     ),
        //   ],
        // ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            // Name
            Text(
              AppLocalizations.of(context)
                  .supportedLanguages
                  .values
                  .toList()[i],
              style: TextStyle(
                color: isCurrentLocalization
                    ? Theme.of(context).primaryColor
                    : Theme.of(context).textSelectionHandleColor,
                fontSize: 22,
                fontWeight:
                    isCurrentLocalization ? FontWeight.w600 : FontWeight.w400,
              ),
            ),

            // icon
            Icon(
              Icons.chevron_right,
              color: Theme.of(context).textSelectionColor,
              size: 18,
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _ui(SettingsViewModel model) {
    return [
      SizedBox(height: 10),

      // Illustration
      Container(
        height: 170,
        margin: EdgeInsets.symmetric(horizontal: 15),
        child: Center(
          child: Image(
            image: AssetImage(
              Theme.of(context).brightness == Brightness.dark
                  ? 'assets/images/darkmode.png'
                  : 'assets/images/lightmode.png',
            ),
            fit: BoxFit.contain,
          ),
        ),
      ),
      SizedBox(height: 20),

      // Title
      Container(
        margin: EdgeInsets.symmetric(horizontal: 15),
        child: Text(
          AppLocalizations.of(context).translate('language').toUpperCase(),
          style: TextStyle(
            fontSize: 18,
            color: Theme.of(context).textSelectionColor.withOpacity(0.75),
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      SizedBox(height: 5),

      // Tiles
      Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: List.generate(
            AppLocalizations.of(context).supportedLanguages.length,
            (int i) => _tile(model, i),
          ),
        ),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _model,
      child: Consumer<SettingsViewModel>(
        builder: (_, model, child) {
          return GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: Scaffold(
              key: _scaffoldKey,
              backgroundColor: Theme.of(context).backgroundColor,
              appBar: SettingsPageAppBar('language'),
              body: model.state == ViewState.Busy
                  ? LoadingPage()
                  : SafeArea(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: _ui(model),
                        ),
                      ),
                    ),
            ),
          );
        },
      ),
    );
  }
}
