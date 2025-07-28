import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product.dart';

/// A minimal WooCommerce REST API client for fetching products.
class WooCommerceService {
  final String baseUrl;
  final String consumerKey;
  final String consumerSecret;

  const WooCommerceService({
    required this.baseUrl,
    required this.consumerKey,
    required this.consumerSecret,
  });

  /// Fetches products from the WooCommerce store and converts them to [Product]
  /// objects used by the app.
  Future<List<Product>> fetchProducts() async {
    final uri = Uri.parse(
      '$baseUrl/wp-json/wc/v3/products?consumer_key=$consumerKey&consumer_secret=$consumerSecret',
    );
    try {
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data
            .map((item) => Product(
                  name: item['name'] ?? 'Unknown',
                  price: item['price'] ?? '0',
                  description: item['description'] ?? '',
                  imagePath: item['images'] != null && item['images'].isNotEmpty
                      ? item['images'][0]['src']
                      : '',
                ))
            .toList();
      } else {
        // Unexpected status code - return an empty list
        return [];
      }
    } catch (e) {
      // Any network or decoding errors are ignored
      return [];
    }
  }
}
