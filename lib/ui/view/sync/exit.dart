import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:habits_plus/core/enums/viewstate.dart';
import 'package:habits_plus/core/services/images.dart';
import 'package:habits_plus/core/util/constant.dart';
import 'package:habits_plus/core/viewmodels/sync_model.dart';
import 'package:habits_plus/localization.dart';
import 'package:habits_plus/locator.dart';
import 'package:habits_plus/ui/view/sync/exit_dialog.dart';
import 'package:habits_plus/ui/widgets/progress_bar.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';

class SyncExitScreen extends StatefulWidget {
  @override
  _SyncExitScreenState createState() => _SyncExitScreenState();
}

class _SyncExitScreenState extends State<SyncExitScreen> {
  SyncViewModel _model = locator<SyncViewModel>();
  ImageServices _imageServices = locator<ImageServices>();

  List<Widget> _ui(BuildContext context, SyncViewModel model) {
    return [
      // avatar
      Container(
        width: 200,
        height: 200,
        child: model.user.profileImgBase64String == null
            ? Image(
                image: AssetImage('assets/images/white_man.png'),
              )
            : _imageServices.imageFromBase64String(
                model.user.profileImgBase64String,
                fit: BoxFit.cover,
                borderRadius: BorderRadius.circular(1000),
              ),
      ),
      SizedBox(height: 10),

      // Name
      Text(
        model.user.name == null ? 'User' : model.user.name,
        style: TextStyle(
          color: lightMode.textSelectionHandleColor,
          fontSize: 24,
          fontWeight: FontWeight.w600,
        ),
      ),

      // Email
      model.user.email == null
          ? SizedBox.shrink()
          : Text(
              model.user.email,
              style: TextStyle(
                color: lightMode.textSelectionColor,
                fontSize: 18,
              ),
            ),
      SizedBox(height: 5),

      // Divider
      Container(
        margin: EdgeInsets.symmetric(horizontal: 30),
        child: Divider(
          color: lightMode.textSelectionColor.withOpacity(0.5),
          thickness: 1,
        ),
      ),

      SizedBox(height: 5),
      Container(
        margin: EdgeInsets.symmetric(horizontal: 30),
        child: Text(
          AppLocalizations.of(context).translate('sync_exit_1'),
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 18,
            color: lightMode.textSelectionHandleColor,
          ),
        ),
      ),

      Container(
        margin: EdgeInsets.symmetric(horizontal: 30),
        child: RichText(
          textAlign: TextAlign.center,
          text: TextSpan(children: [
            TextSpan(
              text: AppLocalizations.of(context).translate('sync_exit_2'),
              style: TextStyle(
                fontSize: 18,
                color: lightMode.textSelectionColor,
              ),
            ),
            TextSpan(
              text: model.user.email,
              style: TextStyle(
                fontSize: 18,
                color: lightMode.textSelectionHandleColor,
                fontWeight: FontWeight.w600,
              ),
            )
          ]),
        ),
      ),
      SizedBox(height: 20),

      // logout
      Container(
        height: 60,
        margin: EdgeInsets.symmetric(horizontal: 15),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.redAccent,
        ),
        child: Material(
          child: InkWell(
            borderRadius: BorderRadius.circular(10),
            splashColor: Colors.white10,
            onTap: () async {
              await model.signOut();
              Navigator.pop(context);
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                // Icon
                Icon(
                  EvaIcons.logOut,
                  color: Colors.white,
                ),
                SizedBox(width: 5),

                // Text
                Text(
                  AppLocalizations.of(context).translate('logout'),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _model,
      child: Consumer<SyncViewModel>(builder: (_, model, child) {
        return Theme(
          data: lightMode,
          child: GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: Scaffold(
              appBar: model.state == ViewState.Busy ? ProgressBar() : null,
              backgroundColor: lightMode.backgroundColor,
              body: Scaffold(
                appBar: AppBar(
                  elevation: 0,
                  backgroundColor: Colors.transparent,
                  leading: GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Icon(
                      Icons.chevron_left,
                      color: lightMode.textSelectionHandleColor,
                    ),
                  ),
                ),
                body: SafeArea(
                  child: Container(
                    margin: EdgeInsets.only(bottom: 56),
                    width: double.infinity,
                    height: double.infinity,
                    child: Center(
                      child: SingleChildScrollView(
                        child: Column(
                          children: _ui(_, model),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}
