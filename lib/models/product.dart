class Product {
  final String name;
  final String price;
  final String imagePath;
  final String description;
  final String category;

  /// Basic product model used throughout the app.
  Product({
    required this.name,
    required this.price,
    required this.description,
    required this.imagePath,
    this.category = 'General',
  });
}
