import 'package:cloud_firestore/cloud_firestore.dart';

class PostModel {
  final String id;
  final String title;
  final String text;
  final String authorUid;
  final String authorEmail;
  final DateTime? createdAt;
  final String? imageUrl;

  const PostModel({
    required this.id,
    required this.title,
    required this.text,
    required this.authorUid,
    required this.authorEmail,
    required this.createdAt,
    required this.imageUrl,
  });

  factory PostModel.fromSnapshot(QueryDocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data();
    final rawCreatedAt = data['createdAt'];

    return PostModel(
      id: doc.id,
      title: (data['title'] ?? '').toString(),
      text: (data['text'] ?? '').toString(),
      authorUid: (data['authorUid'] ?? '').toString(),
      authorEmail: (data['authorEmail'] ?? '').toString(),
      createdAt: rawCreatedAt is Timestamp ? rawCreatedAt.toDate() : null,
      imageUrl: _normalizeImageUrl(data['imageUrl']),
    );
  }

  static String? _normalizeImageUrl(dynamic value) {
    final text = value?.toString().trim() ?? '';
    return text.isEmpty ? null : text;
  }
}