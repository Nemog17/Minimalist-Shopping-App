import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/user.dart';
import '../models/product.dart';

class AuthState {
  final User? currentUser;

  const AuthState({this.currentUser});

  bool get isLoggedIn => currentUser != null;
  bool get isAdmin => currentUser?.isAdmin ?? false;
}

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(const AuthState());

  final List<User> _users = [
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

  bool register(String email, String password, String address) {
    if (_users.any((u) => u.email == email)) return false;
    final user = User(email: email, password: password, address: address);
    _users.add(user);
    emit(AuthState(currentUser: user));
    return true;
  }

  void updateAddress(String address) {
    final user = state.currentUser;
    if (user != null) {
      user.address = address;
      emit(AuthState(currentUser: user));
    }
  }

  void addOrder(List<Product> products) {
    final user = state.currentUser;
    if (user != null) {
      user.orderHistory.addAll(products);
      emit(AuthState(currentUser: user));
    }
  }

  void logout() {
    emit(const AuthState());
  }
}
