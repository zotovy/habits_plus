import 'package:cloud_firestore/cloud_firestore.dart';

class Comment {
  String id;
  String authorId;
  String habitId;
  bool hasImage;
  String imageUrl;
  String content;
  DateTime timestamp;

  Comment({
    this.id,
    this.authorId,
    this.habitId,
    this.content,
    this.hasImage,
    this.imageUrl,
    this.timestamp,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'authorId': authorId,
      'habitId': habitId,
      'hasImage': hasImage,
      'imageUrl': imageUrl,
      'content': content,
      'timestamp': timestamp.toString(),
    };
  }

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: json['id'],
      authorId: json['authorId'],
      habitId: json['habitId'],
      hasImage: json['hasImage'],
      imageUrl: json['imageUrl'],
      content: json['content'],
      timestamp: DateTime.parse(json['timestamp']),
    );
  }
}
