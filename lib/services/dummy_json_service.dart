import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart' show rootBundle;
import '../models/product.dart';

/// Service class for interacting with the DummyJSON API.
class DummyJsonService {
  static const String _baseUrl = 'https://dummyjson.com';

  /// Fetches a list of products from the DummyJSON API and converts them to
  /// [Product] objects used by the app.
  ///
  /// The [limit] parameter can be used to request a specific number of
  /// products in a single call. By default it fetches all 194 available
  /// demo products.
  static Future<List<Product>> fetchProducts({int limit = 194}) async {
    try {
      final response =
          await http.get(Uri.parse('$_baseUrl/products?limit=$limit'));
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        final List<dynamic> products = data['products'] ?? [];
        final List<Product> list = [];
        for (final item in products) {
          list.add(
            Product(
              name: item['title'] ?? 'Unknown',
              price: item['price'].toString(),
              description: item['description'] ?? '',
              imagePath: item['thumbnail'] ?? '',
              stock: item['stock'] ?? 0,
              category: item['category'] ?? 'General',
              isDraft: false,
            ),
          );
        }
        return list;
      }
    } catch (_) {
      // Ignore network errors and fall back to local data
    }

    // Load fallback data from bundled JSON file
    final jsonStr = await rootBundle.loadString('assets/dummy_products.json');
    final Map<String, dynamic> data = jsonDecode(jsonStr);
      final List<dynamic> products = data['products'] ?? [];
      final List<Product> list = [];
      for (final item in products) {
        list.add(
          Product(
            name: item['title'] ?? 'Unknown',
            price: item['price'].toString(),
            description: item['description'] ?? '',
            imagePath: item['thumbnail'] ?? '',
            stock: item['stock'] ?? 0,
            category: item['category'] ?? 'General',
            isDraft: false,
          ),
        );
      }
    return list;
  }
}
