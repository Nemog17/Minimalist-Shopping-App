import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/shoe.dart';

/// Service class for interacting with the Fake Store API.
class FakeStoreApi {
  static const String _baseUrl = 'https://fakestoreapi.com';

  /// Fetches a list of products from the Fake Store API and converts them to
  /// [Shoe] objects used by the app.
  static Future<List<Shoe>> fetchProducts() async {
    final response = await http.get(Uri.parse('$_baseUrl/products'));
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data
          .map((item) => Shoe(
                name: item['title'] ?? 'Unknown',
                price: item['price'].toString(),
                description: item['description'] ?? '',
                imagePath: item['image'] ?? '',
              ))
          .toList();
    } else {
      throw Exception('Failed to load products');
    }
  }
}
