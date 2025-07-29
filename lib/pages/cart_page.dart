import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../components/cart_item.dart';
import '../cubits/cart_cubit.dart';
import '../services/payment_service.dart';

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
      body: BlocBuilder<CartCubit, CartState>(
        builder: (context, state) {
          final items = state.userCart;
          final saved = state.savedForLater;
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
      bottomNavigationBar: BlocBuilder<CartCubit, CartState>(
        builder: (context, state) {
          final items = state.userCart;
          if (items.isEmpty) return const SizedBox.shrink();
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () async {
                final success = await PaymentService.processPayment(items);
                if (success) {
                  context.read<CartCubit>().completePurchase();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Pago completado')),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Error al procesar pago')),
                  );
                }
              },
              child: const Text('Pagar'),
            ),
          );
        },
      ),
    );
  }
}
