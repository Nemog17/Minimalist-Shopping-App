import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product.dart';

/// Service class for interacting with the DummyJSON API.
class DummyJsonService {
  static const String _baseUrl = 'https://dummyjson.com';

  /// Fetches a list of products from the DummyJSON API and converts them to
  /// [Product] objects used by the app.
  static Future<List<Product>> fetchProducts() async {
    final response = await http.get(Uri.parse('$_baseUrl/products'));
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      final List<dynamic> products = data['products'] ?? [];
      return products
          .map((item) => Product(
                name: item['title'] ?? 'Unknown',
                price: item['price'].toString(),
                description: item['description'] ?? '',
                imagePath: item['thumbnail'] ?? '',
                category: item['category'] ?? 'General',
                isDraft: false,
              ))
          .toList();
    } else {
      throw Exception('Failed to load products');
    }
  }
}
