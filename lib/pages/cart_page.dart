import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../components/cart_item.dart';
import '../cubits/cart_cubit.dart';
import '../services/payment_service.dart';
import '../cubits/auth_cubit.dart';
import '../models/product.dart';
import 'login_page.dart';
import '../components/app_drawer.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(),
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
          final counts = <Product, int>{};
          for (final p in items) {
            counts[p] = (counts[p] ?? 0) + 1;
          }
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
                ...counts.entries.map((e) => CartItem(product: e.key, quantity: e.value)).toList(),
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
                final auth = context.read<AuthCubit>();
                if (!auth.state.isLoggedIn) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Inicia sesión para comprar')),
                  );
                  await Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const LoginPage()),
                  );
                  return;
                }

                final address = await showDialog<String>(
                  context: context,
                  builder: (context) {
                    final controller = TextEditingController();
                    return AlertDialog(
                      title: const Text('Dirección de envío'),
                      content: TextField(
                        controller: controller,
                        decoration: const InputDecoration(
                          hintText: 'Ingresa tu dirección',
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Cancelar'),
                        ),
                        ElevatedButton(
                          onPressed: () =>
                              Navigator.pop(context, controller.text),
                          child: const Text('Continuar'),
                        ),
                      ],
                    );
                  },
                );

                if (address == null || address.trim().isEmpty) return;

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
