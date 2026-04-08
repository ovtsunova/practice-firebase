import 'package:flutter/material.dart';

import '../models/post_model.dart';
import '../utils/date_time_formatter.dart';

class PostCard extends StatelessWidget {
  final PostModel post;
  final bool canManage;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const PostCard({
    super.key,
    required this.post,
    required this.canManage,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final hasImage = (post.imageUrl ?? '').isNotEmpty;

    return Card(
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              post.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Chip(
              label: Text(
                post.authorEmail,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Дата: ${formatDateTime(post.createdAt)}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 10),
            if (hasImage) ...[
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: AspectRatio(
                  aspectRatio: 1,
                  child: Image.network(
                    post.imageUrl!,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      alignment: Alignment.center,
                      color: Colors.black12,
                      child: const Text('Не удалось загрузить изображение'),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
            ],
            Text(
              post.text,
              maxLines: hasImage ? 6 : 10,
              overflow: TextOverflow.ellipsis,
            ),
            if (canManage) ...[
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: onEdit,
                      icon: const Icon(Icons.edit),
                      label: const Text('Изменить'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: FilledButton.tonalIcon(
                      onPressed: onDelete,
                      icon: const Icon(Icons.delete),
                      label: const Text('Удалить'),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}