import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

import '../components/cart_item.dart';
import '../models/cart.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mi Carrito'),
        leading: IconButton(
          icon: const Icon(Icons.home),
          onPressed: () => context.pop(),
        ),
      ),
      body: Consumer<Cart>(
        builder: (context, cart, child) {
          final items = cart.getUserCart();
          final saved = cart.getSavedForLater();
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: ListView(
              children: [
                const SizedBox(height: 20),
                Text(
                  'Artículos',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                  ),
                ),
                const SizedBox(height: 15),
                ...items.map((p) => CartItem(product: p)).toList(),
                const SizedBox(height: 20),
                if (saved.isNotEmpty) ...[
                  Text(
                    'Guardados para más tarde',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                    ),
                  ),
                  const SizedBox(height: 15),
                  ...saved
                      .map((p) => CartItem(product: p, isSavedItem: true))
                      .toList(),
                ],
              ],
            ),
          );
        },
      ),
    );
  }
}
