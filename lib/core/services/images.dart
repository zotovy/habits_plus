import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';

class ImageServices {
  ClipRRect imageFromBase64String(String base64String,
      {BoxFit fit, BorderRadius borderRadius}) {
    return ClipRRect(
      borderRadius: borderRadius,
      child: Image.memory(
        base64Decode(base64String),
        fit: fit == null ? BoxFit.contain : fit,
      ),
    );
  }

  Image rawImageFromBase64Strign(String base64String, {BoxFit fit}) {
    return Image.memory(
      base64Decode(base64String),
      fit: fit == null ? BoxFit.contain : fit,
    );
  }

  Uint8List dataFromBase64String(String base64String) {
    return base64Decode(base64String);
  }

  String base64String(Uint8List data) {
    return base64Encode(data);
  }

  ImageProvider imageProviderFromBase64String(String base64String) {
    return MemoryImage(base64Decode(base64String));
  }

  Future<File> compressImage(File image) async {
    final tempDir = await getTemporaryDirectory();
    final path = tempDir.path;
    File compessedImage = await FlutterImageCompress.compressAndGetFile(
      image.absolute.path,
      '$path/img.jpg',
      quality: 70,
    );
    return compessedImage;
  }
}
