import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/post_model.dart';

class PostService {
  final CollectionReference<Map<String, dynamic>> _posts =
      FirebaseFirestore.instance.collection('posts');

  Stream<List<PostModel>> watchPosts() {
    return _posts.snapshots().map((snapshot) {
      final posts = snapshot.docs.map(PostModel.fromSnapshot).toList();

      posts.sort((a, b) {
        final aValue = a.createdAt?.millisecondsSinceEpoch ?? 0;
        final bValue = b.createdAt?.millisecondsSinceEpoch ?? 0;
        return bValue.compareTo(aValue);
      });

      return posts;
    });
  }

  Future<void> createPost({
    required String title,
    required String text,
    required String authorUid,
    required String authorEmail,
    String? imageUrl,
  }) async {
    await _posts.add({
      'title': title,
      'text': text,
      'authorUid': authorUid,
      'authorEmail': authorEmail,
      'createdAt': FieldValue.serverTimestamp(),
      'imageUrl': _normalizeImageUrl(imageUrl),
    });
  }

  Future<void> updatePost({
    required String id,
    required String title,
    required String text,
    String? imageUrl,
  }) async {
    await _posts.doc(id).update({
      'title': title,
      'text': text,
      'imageUrl': _normalizeImageUrl(imageUrl),
    });
  }

  Future<void> deletePost(String id) async {
    await _posts.doc(id).delete();
  }

  String? _normalizeImageUrl(String? value) {
    final text = value?.trim() ?? '';
    return text.isEmpty ? null : text;
  }
}