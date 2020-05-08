import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:habits_plus/core/enums/viewstate.dart';
import 'package:habits_plus/core/models/theme.dart';
import 'package:habits_plus/core/services/database.dart';
import 'package:habits_plus/core/services/images.dart';
import 'package:habits_plus/core/util/constant.dart';
import 'package:habits_plus/core/viewmodels/settings_model.dart';
import 'package:habits_plus/localization.dart';
import 'package:habits_plus/locator.dart';
import 'package:habits_plus/ui/icons/custom_icons.dart';
import 'package:habits_plus/ui/view/loading.dart';
import 'package:habits_plus/ui/view/sync/exit.dart';
import 'package:habits_plus/ui/widgets/settings/menu_tile.dart';
import 'package:habits_plus/ui/widgets/settings/user_row.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  SettingsViewModel _model = locator<SettingsViewModel>();

  // General
  List<String> text = [];
  List<Color> colors = [
    Color(0xFF9563FF),
    null, // THis color will show depend on a brightness lvl
    Color(0xFFF0A330),
    Color(0xFF2A8CFE),
    Color(0xFFEF7530),
    Color(0xFF30D158),
    Color(0xFF707070),
    Color(0xFF707070),
    Color(0xFF707070),
  ];
  List<IconData> icons = [
    Icons.person,
    EvaIcons.moon,
    Icons.notifications,
    EvaIcons.lock,
    EvaIcons.music,
    Icons.language,
    CustomIcons.send,
    EvaIcons.messageCircle,
    EvaIcons.person,
  ];

  List<Widget> _ui(
    BuildContext context,
    SettingsViewModel model,
  ) {
    List<Function> callback = [
      () => Navigator.pushNamed(context, 'settings/account'),
      () => Navigator.pushNamed(context, 'settings/darkmode'),
      () => Navigator.pushNamed(context, 'settings/notifications'),
      () => Navigator.pushNamed(context, 'settings/security'),
      () {},
      () => Navigator.pushNamed(context, 'settings/languages'),
      () => Navigator.pushNamed(context, 'settings/report_bug'),
      () => Navigator.pushNamed(context, 'settings/contact_us'),
      () => Navigator.pushNamed(context, 'settings/author'),
    ];
    return [
      // User info
      SettingsUserRow(
        avatar: model.user.profileImgBase64String == null
            ? ClipRRect(
                child: Image(image: AssetImage('assets/images/white_man.png')),
                borderRadius: BorderRadius.circular(100),
              )
            : locator<ImageServices>().imageFromBase64String(
                model.user.profileImgBase64String,
                fit: BoxFit.cover,
                borderRadius: BorderRadius.circular(100),
              ),
        name: model.user.name,
        email: model.user.email,
      ),

      // Divider
      Container(
        margin: EdgeInsets.symmetric(horizontal: 15),
        child: Divider(
          thickness: 1,
          color: Theme.of(context).textSelectionColor.withOpacity(0.5),
        ),
      ),

      // General
      Container(
        child: Column(
          children: List.generate(
            6,
            (int i) => SettingsMenuTile(
              icon: icons[i],
              color: colors[i],
              text: text[i],
              callback: callback[i],
              i: i,
              isDarkMode: model.isDarkMode,
            ),
          ),
        ),
      ),

      // Divider
      Container(
        margin: EdgeInsets.symmetric(horizontal: 15),
        child: Divider(
          thickness: 1,
          color: Theme.of(context).textSelectionColor.withOpacity(0.5),
        ),
      ),

      // Secondary
      Container(
        child: Column(
          children: List.generate(
            text.length - 6,
            (int i) => SettingsMenuTile(
              icon: icons[i + 6],
              color: colors[i + 6],
              text: text[i + 6],
              callback: callback[i + 6],
              i: i + 6,
              isDarkMode: model.isDarkMode,
            ),
          ),
        ),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    // Setup provider
    text = [
      AppLocalizations.of(context).translate('account'),
      AppLocalizations.of(context).translate('darkmode'),
      AppLocalizations.of(context).translate('notifications'),
      AppLocalizations.of(context).translate('security'),
      AppLocalizations.of(context).translate('app_sound'),
      AppLocalizations.of(context).translate('language'),
      AppLocalizations.of(context).translate('report_bug'),
      AppLocalizations.of(context).translate('contact_us'),
      AppLocalizations.of(context).translate('author'),
    ];

    double screenHeight = MediaQuery.of(context).size.height;

    // Build
    return ChangeNotifierProvider.value(
      value: _model,
      child: Consumer<SettingsViewModel>(
        builder: (_, model, child) {
          return model.state == ViewState.Busy
              ? LoadingPage()
              : SafeArea(
                  child: Container(
                    height: 735,
                    decoration: BoxDecoration(
                      color: Theme.of(context).backgroundColor,
                      borderRadius: screenHeight >= 676
                          ? BorderRadius.only(
                              topLeft: Radius.circular(30),
                              topRight: Radius.circular(30),
                            )
                          : null,
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: _ui(context, model),
                      ),
                    ),
                  ),
                );
        },
      ),
    );
  }
}
