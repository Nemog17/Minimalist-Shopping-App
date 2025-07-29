class Product {
  String name;
  String price;
  String imagePath;
  String description;
  String category;
  bool isDraft;
  int stock;

  /// Basic product model used throughout the app.
  Product({
    required this.name,
    required this.price,
    required this.description,
    required this.imagePath,
    this.stock = 0,
    this.category = 'General',
    this.isDraft = false,
  });
}
