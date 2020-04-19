import 'dart:io';

import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:habits_plus/core/viewmodels/detail_model.dart';
import 'package:habits_plus/localization.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class DetailPageBottomPage extends StatefulWidget {
  Function(String val) saveContent;
  Function(File image) saveImage;
  Function() pickImage;
  Function() onImageDelete;
  File image;
  Function onConfirm;

  DetailPageBottomPage({
    this.saveContent,
    this.saveImage,
    this.pickImage,
    this.onImageDelete,
    this.image,
    this.onConfirm,
  })  : assert(saveContent != null),
        assert(saveImage != null),
        assert(pickImage != null);

  @override
  _DetailPageBottomPageState createState() => _DetailPageBottomPageState();
}

class _DetailPageBottomPageState extends State<DetailPageBottomPage> {
  bool get barrierDismissible => false;

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  File _image;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _image = widget.image;
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
                  Container(
                    child: Row(
                      children: <Widget>[
                        // Form
                        Expanded(
                          child: TextFormField(
                            onSaved: widget.saveContent,
                            decoration: InputDecoration(
                              hintText: AppLocalizations.of(context)
                                  .translate('comment'),
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
                                ? AppLocalizations.of(context)
                                    .translate('comments_error')
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
                              onTap: () async {
                                File image = await widget.pickImage();
                                setState(() {
                                  _image = image;
                                });
                              },
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
                                            arguments: [
                                              _image,
                                              'preview_comment'
                                            ],
                                          ),
                                          child: Hero(
                                            tag: 'preview_comment',
                                            child: Container(
                                              decoration: BoxDecoration(
                                                image: DecorationImage(
                                                  image: FileImage(_image),
                                                  fit: BoxFit.cover,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(10),
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
                  ),

                  // Confirm button
                  SizedBox(height: 10),
                  Container(
                    margin: EdgeInsets.only(bottom: 10),
                    height: 55,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Theme.of(context).primaryColor,
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () async {
                          if (_formKey.currentState.validate()) {
                            setState(() {
                              isLoading = true;
                            });
                            _formKey.currentState.save();
                            await widget.saveImage(_image);
                            await widget.onConfirm();
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
                                  AppLocalizations.of(context)
                                      .translate('confirm'),
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Delete
            _image == null
                ? SizedBox.shrink()
                : Positioned(
                    right: 10,
                    top: 10,
                    child: InkWell(
                      onTap: () {
                        widget.onImageDelete();
                        setState(() {
                          _image = null;
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
                  ),
          ],
        ),
      ),
    );
  }
}
