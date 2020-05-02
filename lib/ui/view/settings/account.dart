import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:habits_plus/core/models/user.dart';
import 'package:habits_plus/core/services/images.dart';
import 'package:habits_plus/core/viewmodels/settings_model.dart';
import 'package:habits_plus/core/viewmodels/sync_model.dart';
import 'package:habits_plus/localization.dart';
import 'package:habits_plus/locator.dart';
import 'package:habits_plus/ui/widgets/create/confirm_button.dart';
import 'package:habits_plus/ui/widgets/error_snackbar.dart';
import 'package:habits_plus/ui/widgets/image_sourse.dart';
import 'package:habits_plus/ui/widgets/rounded_textfield.dart';
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
  SyncViewModel _syncViewModel = locator<SyncViewModel>();
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Data
  String oldName;
  String oldEmail;

  @override
  void initState() {
    super.initState();

    oldName = _model.user.name;
    oldEmail = _model.user.email;
  }

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
                return null; // Exit function
              }
            }
          }
        },
      ),
      SizedBox(height: 40),

      // General
      Container(
        margin: EdgeInsets.symmetric(horizontal: 15),
        child: Text(
          AppLocalizations.of(context).translate('general').toUpperCase(),
          style: TextStyle(
            fontSize: 18,
            color: Theme.of(context).textSelectionColor.withOpacity(0.75),
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      SizedBox(height: 5),

      // Name
      RoundedTextField(
        errorLocalizationPath: 'no_name_error',
        hint: 'name',
        onSaved: (String val) {
          User user = model.user;
          user.name = val;
          model.user = user;
        },
        prefix: Icons.person,
        text: model.user.name,
      ),
      SizedBox(height: 10),

      // Email
      Container(
        margin: EdgeInsets.symmetric(horizontal: 15),
        child: Row(
          children: <Widget>[
            // Text Field
            Expanded(
              child: RoundedTextField(
                validator: (String val) => null,
                hint: 'email',
                onSaved: (String val) {
                  User user = model.user;
                  user.email = val;
                  model.user = user;
                },
                prefix: Icons.email,
                text: model.user.email,
                needMargin: false,
              ),
            ),

            SizedBox(width: 10),

            Tooltip(
              message: model.user.isEmailConfirm
                  ? AppLocalizations.of(context).translate(
                      'email_confirm_tooltip',
                    )
                  : AppLocalizations.of(context).translate(
                      'email_doesnt_confirm_tooltip',
                    ),
              child: InkWell(
                onTap: () => print('confirm email'),
                child: Container(
                  height: 60,
                  width: 60,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadiusDirectional.circular(10),
                    color: Theme.of(context).primaryColor,
                  ),
                  child: model.user.isEmailConfirm
                      ? Icon(Icons.done, color: Colors.white)
                      : Icon(Icons.close, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
      SizedBox(height: 20),

      // General
      Container(
        margin: EdgeInsets.symmetric(horizontal: 15),
        child: Text(
          AppLocalizations.of(context).translate('sync').toUpperCase(),
          style: TextStyle(
            fontSize: 18,
            color: Theme.of(context).textSelectionColor.withOpacity(0.75),
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      Container(
        margin: EdgeInsets.only(left: 15, right: 15, bottom: 5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            // Text
            Text(
              AppLocalizations.of(context).translate('sync'),
              style: TextStyle(
                fontSize: 20,
                color: Theme.of(context).textSelectionHandleColor,
              ),
            ),

            // Switcher
            GestureDetector(
              onTap: () {},
              child: AnimatedContainer(
                duration: Duration(microseconds: 300),
                padding: EdgeInsets.all(3),
                height: 30,
                width: 55,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  color: model.isSync
                      ? Theme.of(context).primaryColor
                      : Theme.of(context).disabledColor,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    AnimatedContainer(
                      duration: Duration(milliseconds: 200),
                      margin: EdgeInsets.only(left: model.isSync ? 23 : 0),
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      GestureDetector(
        onTap: () async {
          if (await _syncViewModel.getCurrentUser() == null) {
            Navigator.pushNamed(context, 'settings/account/sync_login');
          } else {
            Navigator.pushNamed(context, 'settings/account/sync_exit');
          }
        },
        child: Container(
          margin: EdgeInsets.only(left: 15, right: 15, bottom: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              // Text
              Text(
                AppLocalizations.of(context).translate('sync'),
                style: TextStyle(
                  fontSize: 20,
                  color: Theme.of(context).textSelectionHandleColor,
                ),
              ),

              Icon(
                Icons.chevron_right,
                color: Theme.of(context).textSelectionColor.withOpacity(0.5),
              ),
            ],
          ),
        ),
      ),

      // Confirm
      ConfirmButton(
        stringPath: 'confirm',
        onPress: () async {
          if (_formKey.currentState.validate()) {
            // Save to user model
            _formKey.currentState.save();

            // If user didn't change anything -> pop()
            if (oldName == model.user.name && oldEmail == model.user.email) {
              Navigator.pop(context);
              return null;
            }

            // Save in DB
            bool dbcode = await model.updateDBUser();

            if (!dbcode) {
              _scaffoldKey.currentState.showSnackBar(
                errorSnackBar(context, 'save_error'),
              );
              return null; // Exit function
            }

            Navigator.pop(context);
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
          return GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: Scaffold(
              key: _scaffoldKey,
              backgroundColor: Theme.of(context).backgroundColor,
              appBar: SettingsPageAppBar('account'),
              body: Form(
                key: _formKey,
                child: SafeArea(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: _ui(model),
                    ),
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
