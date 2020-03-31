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

  factory Comment.fromJson(DocumentSnapshot snap) {
    return Comment(
      id: snap.documentID,
      authorId: snap['authorId'],
      habitId: snap['habitId'],
      hasImage: snap['hasImage'],
      imageUrl: snap['imageUrl'],
      content: snap['content'],
      timestamp: (snap['timestamp'] as Timestamp).toDate(),
    );
  }
}
