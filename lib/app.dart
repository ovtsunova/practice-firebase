import 'package:flutter/material.dart';

import 'screens/auth_gate.dart';
import 'services/auth_service.dart';
import 'services/post_service.dart';

class PostsApp extends StatelessWidget {
  final AuthService authService;
  final PostService postService;

  const PostsApp({
    super.key,
    required this.authService,
    required this.postService,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Posts Web App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: AuthGate(
        authService: authService,
        postService: postService,
      ),
    );
  }
}