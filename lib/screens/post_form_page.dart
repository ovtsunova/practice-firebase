import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../models/post_model.dart';
import '../services/post_service.dart';

class PostFormPage extends StatefulWidget {
  final PostService postService;
  final PostModel? post;

  const PostFormPage({
    super.key,
    required this.postService,
    this.post,
  });

  @override
  State<PostFormPage> createState() => _PostFormPageState();
}

class _PostFormPageState extends State<PostFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _textController = TextEditingController();
  final _imageUrlController = TextEditingController();

  bool _isLoading = false;

  bool get _isEdit => widget.post != null;

  @override
  void initState() {
    super.initState();

    final post = widget.post;
    if (post != null) {
      _titleController.text = post.title;
      _textController.text = post.text;
      _imageUrlController.text = post.imageUrl ?? '';
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _textController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      _showMessage('Пользователь не авторизован.');
      return;
    }

    setState(() => _isLoading = true);

    try {
      final title = _titleController.text.trim();
      final text = _textController.text.trim();
      final imageUrl = _imageUrlController.text.trim();

      if (_isEdit) {
        await widget.postService.updatePost(
          id: widget.post!.id,
          title: title,
          text: text,
          imageUrl: imageUrl,
        );
      } else {
        await widget.postService.createPost(
          title: title,
          text: text,
          authorUid: currentUser.uid,
          authorEmail: currentUser.email ?? '',
          imageUrl: imageUrl,
        );
      }

      if (!mounted) return;
      Navigator.of(context).pop();
    } catch (_) {
      _showMessage('Не удалось сохранить пост.');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _showMessage(String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(text)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authorEmail =
        widget.post?.authorEmail ?? FirebaseAuth.instance.currentUser?.email ?? '';

    return Scaffold(
      appBar: AppBar(
        title: Text(_isEdit ? 'Изменение поста' : 'Добавление поста'),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 720),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _isEdit ? 'Редактирование поста' : 'Новый пост',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: _titleController,
                        decoration: const InputDecoration(
                          labelText: 'Заголовок *',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if ((value ?? '').trim().isEmpty) {
                            return 'Введите заголовок';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _textController,
                        maxLines: 8,
                        decoration: const InputDecoration(
                          labelText: 'Текст *',
                          border: OutlineInputBorder(),
                          alignLabelWithHint: true,
                        ),
                        validator: (value) {
                          if ((value ?? '').trim().isEmpty) {
                            return 'Введите текст';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        initialValue: authorEmail,
                        readOnly: true,
                        decoration: const InputDecoration(
                          labelText: 'Почта автора',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _imageUrlController,
                        decoration: const InputDecoration(
                          labelText: 'Ссылка на изображение (необязательно)',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text(
                          'Дата и время выставляются автоматически в момент создания поста.',
                        ),
                      ),
                      const SizedBox(height: 24),
                      Row(
                        children: [
                          FilledButton.icon(
                            onPressed: _isLoading ? null : _save,
                            icon: const Icon(Icons.save),
                            label: Text(_isEdit ? 'Сохранить' : 'Добавить'),
                          ),
                          const SizedBox(width: 12),
                          OutlinedButton(
                            onPressed: _isLoading
                                ? null
                                : () => Navigator.of(context).pop(),
                            child: const Text('Отмена'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}