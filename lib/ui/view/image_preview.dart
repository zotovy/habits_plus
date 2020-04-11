import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class ImagePreviewPage extends StatelessWidget {
  String tag;
  var image;

  ImagePreviewPage({
    this.tag,
    this.image,
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
                imageProvider: image.runtimeType != String
                    ? FileImage(image)
                    : CachedNetworkImageProvider(image),
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
