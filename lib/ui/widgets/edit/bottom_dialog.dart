import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:habits_plus/core/services/images.dart';
import 'package:habits_plus/localization.dart';
import 'package:habits_plus/locator.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class EditCommentDialog extends StatefulWidget {
  Function(String content, String base64Image) onConfirm;
  String initialImage;
  String initialComment;

  EditCommentDialog({
    @required this.onConfirm,
    @required this.initialImage,
    @required this.initialComment,
  });

  @override
  _EditCommentDialogState createState() => _EditCommentDialogState();
}

class _EditCommentDialogState extends State<EditCommentDialog> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  Image _image;
  bool isLoading = false;

  String base64Image;
  String content = '';

  @override
  void initState() {
    super.initState();
    _image = widget.initialImage == null || widget.initialImage == ''
        ? null
        : locator<ImageServices>().rawImageFromBase64Strign(
            widget.initialImage,
            fit: BoxFit.cover,
          );
    base64Image = widget.initialImage;
  }

  /// Pick image & set it to [_image] variable
  void pickImage() async {
    // Pick
    File image = await ImagePicker.pickImage(
      source: ImageSource.gallery,
    );

    if (image != null) {
      // Crop
      image = await ImageCropper.cropImage(
        sourcePath: image.path,
        aspectRatioPresets: [
          CropAspectRatioPreset.square,
          CropAspectRatioPreset.ratio3x2,
          CropAspectRatioPreset.original,
          CropAspectRatioPreset.ratio4x3,
          CropAspectRatioPreset.ratio16x9
        ],
        androidUiSettings: AndroidUiSettings(
          toolbarTitle: 'Cropper',
          toolbarColor: Colors.deepOrange,
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: false,
        ),
        iosUiSettings: IOSUiSettings(
          minimumAspectRatio: 1.0,
        ),
      );

      // compress image
      image = await locator<ImageServices>().compressImage(image);
    }

    setState(() {
      // set image
      _image = Image(
        image: FileImage(image),
        fit: BoxFit.cover,
      );
      // set base64String
      base64Image = image == null
          ? null
          : locator<ImageServices>().base64String(
              image.readAsBytesSync(),
            );
    });
  }

  // ANCHOR: Delete image button
  Widget _buildDeleteImageButton() {
    return _image == null
        ? SizedBox.shrink()
        : Positioned(
            right: 10,
            top: 10,
            child: InkWell(
              onTap: () {
                setState(() {
                  _image = null;
                  base64Image = null;
                });
              },
              child: Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.redAccent,
                ),
                child: Icon(
                  Icons.close,
                  color: Colors.white,
                  size: 18,
                ),
              ),
            ),
          );
  }

  // ANCHOR: Confirm button
  Widget _buildConfirmButton() {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      height: 55,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Theme.of(context).primaryColor,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            if (_formKey.currentState.validate()) {
              setState(() {
                isLoading = true;
              });
              _formKey.currentState.save();
              widget.onConfirm(
                content,
                base64Image,
              );
              _image = null;
              setState(() {
                isLoading = false;
              });
              Navigator.pop(context);
            }
          },
          child: Center(
            child: isLoading
                ? Text(
                    '...',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  )
                : Text(
                    AppLocalizations.of(context).translate('confirm'),
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
          ),
        ),
      ),
    );
  }

  // ANCHOR: Up row
  Widget _buildUpRow() {
    return Container(
      child: Row(
        children: <Widget>[
          // Form
          Expanded(
            child: TextFormField(
              onSaved: (String val) {
                content = val;
              },
              initialValue: widget.initialComment,
              decoration: InputDecoration(
                hintText: AppLocalizations.of(context).translate('comment'),
                prefixIcon: Icon(
                  MdiIcons.comment,
                  color: Theme.of(context).primaryColor,
                ),
                border: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Theme.of(context).textSelectionColor,
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              validator: (String value) => value.trim() == ''
                  ? AppLocalizations.of(context).translate('comments_error')
                  : null,
            ),
          ),

          SizedBox(width: 10),

          // Image preview
          AnimatedContainer(
            height: 55,
            width: 55,
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.circular(10),
            ),
            duration: Duration(milliseconds: 500),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: pickImage,
                child: _image == null
                    ? Transform.rotate(
                        angle: 0.5,
                        child: Icon(
                          MdiIcons.paperclip,
                          size: 24,
                          color: Colors.white,
                        ),
                      )
                    : Stack(
                        children: <Widget>[
                          // Image
                          InkWell(
                            onTap: () => Navigator.pushNamed(
                              context,
                              'image_preview',
                              arguments: [base64Image, 'preview_comment'],
                            ),
                            child: Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                    offset: Offset(0, 1),
                                    color: Theme.of(context).brightness ==
                                            Brightness.light
                                        ? Colors.transparent
                                        : Colors.white10,
                                    blurRadius: 5,
                                  ),
                                ],
                              ),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Theme.of(context).disabledColor,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: locator<ImageServices>()
                                    .imageFromBase64String(
                                  base64Image == null
                                      ? widget.initialImage
                                      : base64Image,
                                  fit: BoxFit.cover,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Stack(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom + 5,
                top: 15,
                left: 15,
                right: 15,
              ),
              decoration: BoxDecoration(
                color: Theme.of(context).backgroundColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Column(
                children: <Widget>[
                  // Up Row
                  _buildUpRow(),
                  SizedBox(height: 10),

                  // Confirm button
                  _buildConfirmButton(),
                ],
              ),
            ),
            // Delete image
            _buildDeleteImageButton(),
          ],
        ),
      ),
    );
  }
}
