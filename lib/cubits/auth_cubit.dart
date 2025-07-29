import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/user.dart';

class AuthState {
  final User? currentUser;

  const AuthState({this.currentUser});

  bool get isLoggedIn => currentUser != null;
  bool get isAdmin => currentUser?.isAdmin ?? false;
}

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(const AuthState());

  final List<User> _users = const [
    User(email: 'admin@example.com', password: 'admin123', isAdmin: true),
    User(email: 'user@example.com', password: 'user123'),
  ];

  bool login(String email, String password) {
    if (state.isLoggedIn) return false;
    try {
      final user = _users.firstWhere(
        (u) => u.email == email && u.password == password,
      );
      emit(AuthState(currentUser: user));
      return true;
    } catch (_) {
      return false;
    }
  }

  void logout() {
    emit(const AuthState());
  }
}
