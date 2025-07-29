import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../components/app_header.dart';

import '../components/cart_item.dart';
import '../cubits/cart_cubit.dart';
import '../services/payment_service.dart';
import '../cubits/auth_cubit.dart';
import '../models/product.dart';
import 'login_page.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppHeader(title: 'Mi Carrito', showBack: true),
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
      floatingActionButton: BlocBuilder<CartCubit, CartState>(
        builder: (context, state) {
          final items = state.userCart;
          if (items.isEmpty) return const SizedBox.shrink();
          return FloatingActionButton.extended(
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

              if (auth.state.currentUser!.address.trim().isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Agrega una dirección en tu perfil')),
                );
                context.push('/profile');
                return;
              }

              final success = await PaymentService.processPayment(items);
              if (success) {
                context.read<AuthCubit>().addOrder(List<Product>.from(items));
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
            label: const Text('Pagar'),
          );
        },
      ),
    );
  }
}
