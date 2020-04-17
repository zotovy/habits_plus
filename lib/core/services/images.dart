import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';

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

  Uint8List dataFromBase64String(String base64String) {
    return base64Decode(base64String);
  }

  String base64String(Uint8List data) {
    return base64Encode(data);
  }

  ImageProvider imageProviderFromBase64String(String base64String) {
    return MemoryImage(base64Decode(base64String));
  }
}
