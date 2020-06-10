import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:habits_plus/core/services/community.dart';
import 'package:habits_plus/localization.dart';
import 'package:habits_plus/locator.dart';
import 'package:habits_plus/ui/icons/custom_icons.dart';
import 'package:habits_plus/ui/widgets/confirm_button.dart';
import 'package:habits_plus/ui/widgets/error_snackbar.dart';
import 'package:habits_plus/ui/widgets/rounded_textfield.dart';
import 'package:habits_plus/ui/widgets/settings/appbar.dart';
import 'package:habits_plus/ui/widgets/sync/sync_dialog.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactUsPage extends StatefulWidget {
  @override
  _ContactUsPageState createState() => _ContactUsPageState();
}

class _ContactUsPageState extends State<ContactUsPage> {
  // Imports
  CommunityServices _communityServices = locator<CommunityServices>();

  // Form
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String name;
  String email;
  String message;

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
  ];

  List<String> links = [
    'https://www.instagram.com/habitter/',
    'https://t.me/habitter',
    'https://www.facebook.com/yaroslav.zotov.10',
    'https://twitter.com/Habitterapp',
    'https://vk.com/habitter'
  ];

  List<IconData> icons = [
    CustomIcons.instagram,
    CustomIcons.telegram,
    CustomIcons.facebook,
    CustomIcons.twitter,
    CustomIcons.vk,
  ];

  // ANCHOR: comment tile
  Widget commentTile(int i) {
    // calc width & height
    double width = (MediaQuery.of(context).size.width - 30) / 5 - 10;
    double height = width / 2;

    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: colors[i],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: () {
            navigateTo(links[i]);
          },
          child: Icon(
            icons[i],
            color: Colors.white,
            size: 16,
          ),
        ),
      ),
    );
  }

  // ANCHOR: build
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: SettingsPageAppBar('contact_us'),
      body: Form(
        key: _formKey,
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                // This SizedBox need to not block "Name" label text on AppBar bg
                SizedBox(height: 2),

                // Name
                RoundedTextField(
                  errorLocalizationPath: 'no_name_error',
                  margin: EdgeInsets.symmetric(horizontal: 15),
                  onSaved: (String value) => name = value,
                  labelLocalizationPath: 'name',
                ),
                SizedBox(height: 10),

                // Email
                RoundedTextField(
                  errorLocalizationPath: 'no_email_error',
                  margin: EdgeInsets.symmetric(horizontal: 15),
                  onSaved: (String value) => email = value,
                  labelLocalizationPath: 'email',
                ),
                SizedBox(height: 10),

                // Message
                RoundedTextField(
                  errorLocalizationPath: 'no_message_error',
                  margin: EdgeInsets.symmetric(horizontal: 15),
                  onSaved: (String value) => message = value,
                  hint: 'message',
                  isMultiLine: true,
                ),
                SizedBox(height: 10),

                // Send message
                ConfirmButton(
                  submit: () async {
                    if (!_formKey.currentState.validate()) return null;
                    _formKey.currentState.save();

                    bool code = await _communityServices.sendMessage(
                      context,
                      name,
                      email,
                      message,
                    );

                    if (!code) {
                      _scaffoldKey.currentState.showSnackBar(
                        errorSnackBar(context, 'error_network'),
                      );
                    } else {
                      showDialog(
                        context: context,
                        builder: (_) => SyncDialog(),
                      );
                      Future.delayed(Duration(seconds: 2)).then((_) {
                        Navigator.pop(context);
                      });
                    }
                  },
                  text: 'send_message',
                ),
                SizedBox(height: 10),

                // Social buttons
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(5, (int i) => commentTile(i)),
                  ),
                ),
                SizedBox(height: 15),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
