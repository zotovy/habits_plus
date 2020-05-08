import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:habits_plus/core/services/images.dart';
import 'package:habits_plus/localization.dart';
import 'package:habits_plus/locator.dart';
import 'package:habits_plus/ui/icons/custom_icons.dart';
import 'package:habits_plus/ui/widgets/settings/appbar.dart';
import 'package:url_launcher/url_launcher.dart';

class AuthorPage extends StatefulWidget {
  @override
  _AuthorPageState createState() => _AuthorPageState();
}

class _AuthorPageState extends State<AuthorPage> {
  /// This Function will navigate user to [url]
  void navigateTo(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      print('error');
    }
  }

  // Social medies
  List<Color> colors = [
    Color(0xFFE1306C),
    Color(0xFF0088CC),
    Color(0xFF4267B2),
    Color(0xFF1DA1F2),
    Color(0xFF4680C2),
    Color(0xFF24292E),
    Color(0xFFD44638),
  ];

  List<String> links = [
    'https://www.instagram.com/panda.developer/',
    'https://t.me/test_habits_plus',
    'https://www.facebook.com/yaroslav.zotov.10',
    'https://twitter.com/n4Gt0wc8S3gCxLp',
    'https://vk.com/thelimee',
    'https://github.com/PandaDEVoper',
    'mailto:<the1ime@yandex.ru>'
  ];

  List<IconData> icons = [
    CustomIcons.instagram,
    CustomIcons.telegram,
    CustomIcons.facebook,
    CustomIcons.twitter,
    CustomIcons.vk,
    CustomIcons.github,
    EvaIcons.email
  ];

  List<double> iconSize = [
    0.6,
    0.5,
    0.5,
    0.47,
    0.4,
    0.52,
    0.7,
  ];

  Widget _linkTile(int i) {
    // calc size
    double size = (MediaQuery.of(context).size.width - 30) / 7 * 0.80;

    return InkWell(
      onTap: () => navigateTo(links[i]),
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: colors[i],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(
          icons[i],
          color: Colors.white,
          size: iconSize[i] * size,
        ),
      ),
    );
  }

  List<Widget> _ui(context) {
    // get all string
    String _1 = AppLocalizations.of(context).translate('another_authors_1');
    String _2 = AppLocalizations.of(context).translate('another_authors_2');
    String _3 = AppLocalizations.of(context).translate('another_authors_3');
    String yulia = AppLocalizations.of(context).translate('yulia_filippova');
    String yzotov = AppLocalizations.of(context).translate('zotov_yaroslav');

    return [
      // Circle Avatar
      Container(
        margin: EdgeInsets.only(left: 3, right: 3, top: 1, bottom: 10),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              blurRadius: 6.0,
              offset: Offset(3, 3),
              color: Theme.of(context).disabledColor,
            ),
          ],
        ),
        child: CircleAvatar(
          backgroundImage: AssetImage('assets/images/pandadeveloper.jpg'),
          radius: 75,
        ),
      ),

      // Zotov Yaroslav
      Text(
        AppLocalizations.of(context).translate('zotov_yaroslav'),
        style: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 24,
          color: Theme.of(context).textSelectionHandleColor,
        ),
      ),

      // Mobile Developer, UI/UX Designer
      Text(
        AppLocalizations.of(context).translate('author_subtitle'),
        style: TextStyle(
          fontSize: 16,
          color: Theme.of(context).primaryColor,
        ),
      ),
      SizedBox(height: 10),

      // Social Medias
      Container(
        margin: EdgeInsets.symmetric(horizontal: 15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(7, (int i) => _linkTile(i)),
        ),
      ),
      SizedBox(height: 10),

      // Another authors
      Container(
        margin: EdgeInsets.symmetric(horizontal: 15),
        child: RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            style: TextStyle(
              color: Theme.of(context).textSelectionColor.withOpacity(0.75),
              fontSize: 16,
            ),
            children: [
              TextSpan(text: _1),
              TextSpan(
                style: TextStyle(
                  color: Theme.of(context).textSelectionColor,
                  fontSize: 16,
                ),
                text: ' freepick.com. ',
                recognizer: TapGestureRecognizer()
                  ..onTap = () => navigateTo('https://www.freepik.com/'),
              ),
              TextSpan(
                text: _2 + ' ',
              ),
              TextSpan(
                style: TextStyle(
                  color: Theme.of(context).textSelectionColor,
                  fontSize: 16,
                ),
                text: yzotov + '. ',
                recognizer: TapGestureRecognizer()
                  ..onTap = () => navigateTo('https://github.com/PandaDEVoper'),
              ),
              TextSpan(text: _3 + ' '),
              TextSpan(
                style: TextStyle(
                  color: Theme.of(context).textSelectionColor,
                  fontSize: 16,
                ),
                text: yulia + '.',
                recognizer: TapGestureRecognizer()
                  ..onTap = () => navigateTo(
                        'https://www.behance.net/gallery/84387369/Habitask-Habits-and-tasks-tracker?tracking_source=search%7Chabits%20mobile%20app',
                      ),
              ),
            ],
          ),
        ),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: SettingsPageAppBar('author'),
        backgroundColor: Theme.of(context).backgroundColor,
        body: Stack(
          children: <Widget>[
            SafeArea(
              child: Container(
                width: double.infinity,
                child: SingleChildScrollView(
                  child: Column(
                    children: _ui(context),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
