import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Stream<User?> authStateChanges() => _auth.authStateChanges();

  User? get currentUser => _auth.currentUser;

  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<void> register({
    required String email,
    required String password,
  }) async {
    await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<void> signOut() => _auth.signOut();

  String humanizeError(Object error) {
    if (error is! FirebaseAuthException) {
      return 'Произошла неизвестная ошибка.';
    }

    switch (error.code) {
      case 'invalid-email':
        return 'Некорректный email.';
      case 'user-not-found':
      case 'wrong-password':
      case 'invalid-credential':
      case 'invalid-login-credentials':
        return 'Неверный email или пароль.';
      case 'email-already-in-use':
        return 'Пользователь с таким email уже существует.';
      case 'weak-password':
        return 'Слишком простой пароль.';
      case 'user-disabled':
        return 'Пользователь отключён.';
      case 'too-many-requests':
        return 'Слишком много попыток. Попробуйте позже.';
      default:
        return error.message ?? 'Ошибка авторизации.';
    }
  }
}