import 'dart:io';

import 'package:habits_plus/core/util/constant.dart';
import 'package:uuid/uuid.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

/// Used to get access to Firebase services
class StorageServices {
  static Future<File> compressImage(String photoId, File image) async {
    final tempDir = await getTemporaryDirectory();
    final path = tempDir.path;
    File compessedImage = await FlutterImageCompress.compressAndGetFile(
      image.absolute.path,
      '$path/img_$photoId.jpg',
      quality: 70,
    );
    return compessedImage;
  }

  Future<String> uploadCommentImage(File image) async {
    // Generate photoId
    String photoId = Uuid().v4();

    // Compress image
    File compressedImage = await compressImage(photoId, image);

    // Upload image
    StorageUploadTask uploadTask = storageRef
        .child('images/comments/comment_$photoId.jpg')
        .putFile(compressedImage);
    StorageTaskSnapshot taskSnap = await uploadTask.onComplete;

    return await taskSnap.ref.getDownloadURL();
  }
}
