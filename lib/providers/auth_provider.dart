import 'package:flutter/material.dart';
import '../models/user.dart';

class AuthProvider extends ChangeNotifier {
  User? _currentUser;

  final List<User> _users = const [
    User(email: 'admin@example.com', password: 'admin123', isAdmin: true),
    User(email: 'user@example.com', password: 'user123'),
  ];

  User? get currentUser => _currentUser;
  bool get isLoggedIn => _currentUser != null;
  bool get isAdmin => _currentUser?.isAdmin ?? false;

  bool login(String email, String password) {
    if (isLoggedIn) return false;
    try {
      final user = _users.firstWhere(
        (u) => u.email == email && u.password == password,
      );
      _currentUser = user;
      notifyListeners();
      return true;
    } catch (_) {
      return false;
    }
  }

  void logout() {
    _currentUser = null;
    notifyListeners();
  }
}
