import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product.dart';

/// Basic payment service used to simulate a checkout call.
class PaymentService {
  static const String _endpoint = 'https://jsonplaceholder.typicode.com/posts';

  /// Sends a POST request with cart items to a dummy API.
  /// Returns `true` if the request was successful.
  static Future<bool> processPayment(List<Product> items) async {
    try {
      final response = await http.post(
        Uri.parse(_endpoint),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'items': items
              .map((p) => {
                    'name': p.name,
                    'price': p.price,
                  })
              .toList(),
        }),
      );
      return response.statusCode == 201;
    } catch (_) {
      return false;
    }
  }
}
