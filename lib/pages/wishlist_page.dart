import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../components/app_header.dart';

import '../cubits/cart_cubit.dart';
import '../components/cart_item.dart';

class WishlistPage extends StatelessWidget {
  const WishlistPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppHeader(title: 'Lista de deseo', showBack: true),
      body: BlocBuilder<CartCubit, CartState>(
        builder: (context, state) {
          final items = state.wishlist;
          if (items.isEmpty) {
            return const Center(child: Text('No hay productos'));
          }
          return ListView(
            padding: const EdgeInsets.all(16),
            children: items
                .map((p) => CartItem(product: p))
                .toList(),
          );
        },
      ),
    );
  }
}
