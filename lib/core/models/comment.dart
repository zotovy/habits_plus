import 'package:cloud_firestore/cloud_firestore.dart';

class Comment {
  String id;
  String authorId;
  String habitId;
  bool hasImage;
  String imageBase64String;
  String content;
  DateTime timestamp;

  Comment({
    this.id,
    this.authorId,
    this.habitId,
    this.content,
    this.hasImage,
    this.imageBase64String,
    this.timestamp,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'authorId': authorId,
      'habitId': habitId,
      'hasImage': hasImage,
      'imageBase64String': imageBase64String,
      'content': content,
      'timestamp': timestamp.toString(),
    };
  }

  Map<dynamic, dynamic> toDocument() {
    return {
      'id': id,
      'authorId': authorId,
      'habitId': habitId,
      'hasImage': hasImage,
      'imageBase64String': imageBase64String,
      'content': content,
      'timestamp': Timestamp.fromDate(timestamp),
    };
  }

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: json['id'],
      authorId: json['authorId'],
      habitId: json['habitId'],
      hasImage: json['hasImage'],
      imageBase64String: json['imageBase64String'],
      content: json['content'],
      timestamp: DateTime.parse(json['timestamp']),
    );
  }
}
