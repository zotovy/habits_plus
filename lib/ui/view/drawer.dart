import 'package:cached_network_image/cached_network_image.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:habits_plus/core/enums/viewstate.dart';
import 'package:habits_plus/core/models/user.dart';
import 'package:habits_plus/core/services/images.dart';
import 'package:habits_plus/core/viewmodels/drawer_model.dart';
import 'package:habits_plus/ui/widgets/drawer/tile.dart';
import 'package:provider/provider.dart';

import '../../locator.dart';

class CustomDrawer extends StatefulWidget {
  @override
  _CustomDrawerState createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  DrawerViewModel _model = locator<DrawerViewModel>();

  Color bgColor;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bgColor = Theme.of(context).brightness == Brightness.light
        ? Theme.of(context)
            .backgroundColor
            .withBlue(Theme.of(context).backgroundColor.blue - 20)
            .withRed(Theme.of(context).backgroundColor.red - 20)
            .withGreen(Theme.of(context).backgroundColor.green - 20)
        : Theme.of(context)
            .backgroundColor
            .withBlue(Theme.of(context).backgroundColor.blue + 10)
            .withRed(Theme.of(context).backgroundColor.red + 10)
            .withGreen(Theme.of(context).backgroundColor.green + 10);
    return ChangeNotifierProvider.value(
      value: _model,
      child: Consumer(
        builder: (_, DrawerViewModel model, child) {
          return model.state == ViewState.Busy
              ? Container()
              : Scaffold(
                  body: SafeArea(
                    child: Container(
                      color: bgColor,
                      width: double.infinity,
                      height: double.infinity,
                      child: Stack(
                        children: <Widget>[
                          // Avatar & title
                          Positioned(
                            top: 16,
                            left: 0,
                            child: _buildAvatarRow(model.user),
                          ),

                          Container(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                DrawerTile(
                                  icon: EvaIcons.settings,
                                  text: 'Settings',
                                  onPressed: () => Navigator.pushNamed(
                                    context,
                                    'settings',
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
        },
      ),
    );
  }

  Widget _buildAvatarRow(User user) {
    return Container(
      padding: EdgeInsets.only(top: 15, left: 15, bottom: 15, right: 60),
      decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.30),
          borderRadius: BorderRadius.only(
            bottomRight: Radius.circular(100),
          )),
      child: Row(
        children: <Widget>[
          // Avatar
          CircleAvatar(
            maxRadius: 25,
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).disabledColor,
                shape: BoxShape.circle,
              ),
              child: user.profileImgBase64String == null
                  ? Image(image: AssetImage('assets/images/white_man.png'))
                  : locator<ImageServices>().imageFromBase64String(
                      user.profileImgBase64String,
                      borderRadius: BorderRadius.circular(100),
                    ),
            ),
          ),
          SizedBox(width: 10),

          // Name
          Text(
            user.name == null ? 'User' : user.name,
            style: TextStyle(
              color: Theme.of(context).textSelectionHandleColor,
              fontWeight: FontWeight.w600,
              fontSize: 18,
            ),
          )
        ],
      ),
    );
  }
}
