import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:posts_web_app/models/post_model.dart';
import 'package:posts_web_app/widgets/post_card.dart';

void main() {
  testWidgets('PostCard отображается', (WidgetTester tester) async {
    final post = PostModel(
      id: '1',
      title: 'Тестовый пост',
      text: 'Текст поста',
      authorUid: 'user_1',
      authorEmail: 'test@gmail.com',
      createdAt: DateTime(2026, 4, 9, 0, 15),
      imageUrl: null,
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SizedBox(
            width: 360,
            child: PostCard(
              post: post,
              canManage: true,
            ),
          ),
        ),
      ),
    );

    expect(find.text('Тестовый пост'), findsOneWidget);
    expect(find.text('test@gmail.com'), findsOneWidget);
  });
}