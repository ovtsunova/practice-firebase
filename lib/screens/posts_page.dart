import 'package:flutter/material.dart';

import '../models/post_model.dart';
import '../services/auth_service.dart';
import '../services/post_service.dart';
import '../widgets/post_card.dart';
import 'post_form_page.dart';

class PostsPage extends StatelessWidget {
  final AuthService authService;
  final PostService postService;

  const PostsPage({
    super.key,
    required this.authService,
    required this.postService,
  });

  Future<void> _confirmDelete(BuildContext context, PostModel post) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Удаление поста'),
        content: Text('Удалить пост "${post.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Отмена'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Удалить'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    try {
      await postService.deletePost(post.id);

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Пост удалён')),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ошибка удаления: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = authService.currentUser;
    final currentUserEmail = currentUser?.email ?? '';
    final currentUserUid = currentUser?.uid ?? '';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Посты'),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Center(
              child: Text(currentUserEmail),
            ),
          ),
          IconButton(
            tooltip: 'Выйти',
            onPressed: authService.signOut,
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => PostFormPage(postService: postService),
            ),
          );
        },
        icon: const Icon(Icons.add),
        label: const Text('Добавить пост'),
      ),
      body: StreamBuilder<List<PostModel>>(
        stream: postService.watchPosts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(
              child: Text('Ошибка загрузки постов'),
            );
          }

          final posts = snapshot.data ?? [];

          if (posts.isEmpty) {
            return const Center(
              child: Text('Пока нет ни одного поста'),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Wrap(
              spacing: 16,
              runSpacing: 16,
              children: posts.map((post) {
                final canManage = post.authorUid == currentUserUid;

                return SizedBox(
                  width: 360,
                  child: PostCard(
                    post: post,
                    canManage: canManage,
                    onEdit: canManage
                        ? () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => PostFormPage(
                                  postService: postService,
                                  post: post,
                                ),
                              ),
                            );
                          }
                        : null,
                    onDelete: canManage
                        ? () => _confirmDelete(context, post)
                        : null,
                  ),
                );
              }).toList(),
            ),
          );
        },
      ),
    );
  }
}