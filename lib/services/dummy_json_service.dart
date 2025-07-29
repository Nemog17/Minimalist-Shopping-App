import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:translator/translator.dart';
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
    final response =
        await http.get(Uri.parse('$_baseUrl/products?limit=$limit'));
    if (response.statusCode == 200) {
      final translator = GoogleTranslator();
      final Map<String, dynamic> data = jsonDecode(response.body);
      final List<dynamic> products = data['products'] ?? [];
      final List<Product> list = [];
      for (final item in products) {
        final name = item['title'] ?? 'Unknown';
        final description = item['description'] ?? '';
        final translatedName = await translator.translate(name, to: 'es');
        final translatedDesc = await translator.translate(description, to: 'es');
        list.add(
          Product(
            name: translatedName.text,
            price: item['price'].toString(),
            description: translatedDesc.text,
            imagePath: item['thumbnail'] ?? '',
            stock: item['stock'] ?? 0,
            category: item['category'] ?? 'General',
            isDraft: false,
          ),
        );
      }
      return list;
    } else {
      throw Exception('Failed to load products');
    }
  }
}
