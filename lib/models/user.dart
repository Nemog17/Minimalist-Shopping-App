class User {
  final String email;
  final String password;
  final bool isAdmin;

  const User({required this.email, required this.password, this.isAdmin = false});
}
