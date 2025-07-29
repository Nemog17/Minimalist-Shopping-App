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
    User(
      email: 'admin@example.com',
      username: 'admin',
      password: 'admin123',
      isAdmin: true,
      name: 'Administrador',
    ),
    User(
      email: 'user@example.com',
      username: 'user',
      password: 'user123',
      name: 'Usuario',
    ),
  ];

  bool login(String username, String password) {
    if (state.isLoggedIn) return false;
    try {
      final user = _users.firstWhere(
        (u) => u.username == username && u.password == password,
      );
      emit(AuthState(currentUser: user));
      return true;
    } catch (_) {
      return false;
    }
  }

  bool register({
    required String email,
    required String username,
    required String password,
    required String name,
    required String phone,
    required String street,
    required String province,
    required String city,
  }) {
    if (_users.any((u) => u.email == email || u.username == username)) return false;
    final user = User(
      email: email,
      username: username,
      password: password,
      name: name,
      phone: phone,
      street: street,
      province: province,
      city: city,
    );
    _users.add(user);
    emit(AuthState(currentUser: user));
    return true;
  }

  void updateProfile({
    String? name,
    String? phone,
    String? street,
    String? province,
    String? city,
  }) {
    final user = state.currentUser;
    if (user != null) {
      if (name != null) user.name = name;
      if (phone != null) user.phone = phone;
      if (street != null) user.street = street;
      if (province != null) user.province = province;
      if (city != null) user.city = city;
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
