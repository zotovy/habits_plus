import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:habits_plus/core/services/images.dart';
import 'package:photo_view/photo_view.dart';

import '../../locator.dart';

class ImagePreviewPage extends StatelessWidget {
  String tag;
  String imageBase64String;

  ImagePreviewPage({
    this.tag,
    this.imageBase64String,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            Hero(
              tag: tag,
              child: PhotoView(
                imageProvider:
                    locator<ImageServices>().imageProviderFromBase64String(
                  imageBase64String,
                ),
              ),
            ),

            // Back
            Positioned(
              top: 10,
              left: 15,
              child: InkWell(
                onTap: () => Navigator.pop(context),
                child: Container(
                  child: Icon(
                    Icons.arrow_back_ios,
                    color: Colors.white,
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
