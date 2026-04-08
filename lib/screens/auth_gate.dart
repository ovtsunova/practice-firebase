import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../services/auth_service.dart';
import '../services/post_service.dart';
import 'login_page.dart';
import 'posts_page.dart';

class AuthGate extends StatelessWidget {
  final AuthService authService;
  final PostService postService;

  const AuthGate({
    super.key,
    required this.authService,
    required this.postService,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: authService.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasData) {
          return PostsPage(
            authService: authService,
            postService: postService,
          );
        }

        return LoginPage(authService: authService);
      },
    );
  }
}