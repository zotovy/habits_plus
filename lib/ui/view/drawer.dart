import 'package:cached_network_image/cached_network_image.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:habits_plus/core/models/user.dart';
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

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _model,
      child: Consumer(
        builder: (_, DrawerViewModel model, child) {
          return Container(
            color: Theme.of(context).primaryColor,
            width: double.infinity,
            height: double.infinity,
            child: Stack(
              children: <Widget>[
                // Avatar & title
                Positioned(
                  top: 15,
                  left: 15,
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
                        onPressed: () => print('go to settigns'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildAvatarRow(User user) {
    return Container(
      child: Row(
        children: <Widget>[
          // Avatar
          CircleAvatar(
            maxRadius: 25,
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: user.profileImg == ''
                      ? AssetImage('assets/images/white_man.png')
                      : CachedNetworkImageProvider(user.profileImg),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          SizedBox(width: 10),

          // Name
          Text(
            user.name,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 18,
            ),
          )
        ],
      ),
    );
  }
}
