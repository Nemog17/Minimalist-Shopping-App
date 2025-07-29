import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product.dart';

/// Service class for interacting with the Fake Store API.
class FakeStoreApi {
  static const String _baseUrl = 'https://fakestoreapi.com';

  /// Fetches a list of products from the Fake Store API and converts them to
  /// [Product] objects used by the app.
  static Future<List<Product>> fetchProducts() async {
    final response = await http.get(Uri.parse('$_baseUrl/products'));
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      final List<Product> products = [];
      for (final item in data) {
        products.add(
          Product(
            name: item['title'] ?? 'Unknown',
            price: item['price'].toString(),
            description: item['description'] ?? '',
            imagePath: item['image'] ?? '',
            stock: 10,
            category: item['category'] ?? 'General',
            isDraft: false,
          ),
        );
      }
      return products;
    } else {
      throw Exception('Failed to load products');
    }
  }
}
