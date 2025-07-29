import 'product.dart';

class User {
  final String email;
  final String password;
  final bool isAdmin;
  String address;
  final List<Product> orderHistory;

  User({
    required this.email,
    required this.password,
    this.isAdmin = false,
    this.address = '',
    List<Product>? orderHistory,
  }) : orderHistory = orderHistory ?? [];
}
