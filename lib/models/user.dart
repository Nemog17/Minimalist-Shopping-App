import 'product.dart';

class User {
  final String email;
  final String username;
  final String password;
  final bool isAdmin;
  String name;
  String phone;
  String street;
  String province;
  String city;
  String country;
  final List<Product> orderHistory;

  User({
    required this.email,
    required this.username,
    required this.password,
    this.isAdmin = false,
    this.name = '',
    this.phone = '',
    this.street = '',
    this.province = '',
    this.city = '',
    this.country = 'República Dominicana',
    List<Product>? orderHistory,
  }) : orderHistory = orderHistory ?? [];
}
