import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:habits_plus/core/services/images.dart';
import 'package:habits_plus/core/viewmodels/settings_model.dart';
import 'package:habits_plus/locator.dart';
import 'package:habits_plus/ui/widgets/error_snackbar.dart';
import 'package:habits_plus/ui/widgets/image_sourse.dart';
import 'package:habits_plus/ui/widgets/settings/appbar.dart';
import 'package:habits_plus/ui/widgets/settings/circle_avatar.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class AccountSettingsPage extends StatefulWidget {
  @override
  _AccountSettingsPageState createState() => _AccountSettingsPageState();
}

class _AccountSettingsPageState extends State<AccountSettingsPage> {
  SettingsViewModel _model = locator<SettingsViewModel>();
  ImageServices _imageServices = locator<ImageServices>();
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  List<Widget> _ui(SettingsViewModel model) {
    return [
      // Profile image
      AccountCircleAvatar(
        image: model.user.profileImgBase64String == null
            ? ClipRRect(
                child: Image(
                  image: AssetImage('assets/images/white_man.png'),
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.circular(100),
              )
            : _imageServices.imageFromBase64String(
                model.user.profileImgBase64String,
                fit: BoxFit.cover,
                borderRadius: BorderRadius.circular(100),
              ),
        onTap: () async {
          // Get sourse
          ImageSource source;
          await showCupertinoDialog(
            context: context,
            builder: (context) => ImageSourcePicker(
              onTap: (ImageSource _source) {
                source = _source;
              },
            ),
          );

          if (source != null) {
            // Pick image
            File image = await ImagePicker.pickImage(source: source);
            if (image != null) {
              File cropedimage = await ImageCropper.cropImage(
                sourcePath: image.path,
                aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
                aspectRatioPresets: [CropAspectRatioPreset.square],
              );

              bool success = await model.setProfileImage(cropedimage);

              if (!success) {
                _scaffoldKey.currentState.showSnackBar(
                  errorSnackBar(context, 'cant_save_profile_image_error'),
                );
              }
            }
          }
        },
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _model,
      child: Consumer<SettingsViewModel>(
        builder: (_, model, child) {
          return Scaffold(
            key: _scaffoldKey,
            backgroundColor: Theme.of(context).backgroundColor,
            appBar: SettingsPageAppBar('account'),
            body: SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  children: _ui(model),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
