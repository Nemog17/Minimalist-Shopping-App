import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../cubits/cart_cubit.dart';
import '../cubits/auth_cubit.dart';

class AppHeader extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showBack;

  const AppHeader({super.key, required this.title, this.showBack = false});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final cartState = context.watch<CartCubit>().state;
    final authState = context.watch<AuthCubit>().state;
    final cartCount = cartState.userCart.length;

    return AppBar(
      leading: IconButton(
        icon: Icon(showBack ? Icons.arrow_back : Icons.home),
        onPressed: () {
          if (showBack) {
            context.pop();
          } else {
            context.go('/home');
          }
        },
      ),
      title: Text(title),
      actions: [
        Stack(
          children: [
            IconButton(
              icon: const Icon(Icons.shopping_cart),
              onPressed: () => context.go('/cart'),
            ),
            if (cartCount > 0)
              Positioned(
                right: 6,
                top: 6,
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
                  child: Text(
                    '$cartCount',
                    style: const TextStyle(color: Colors.white, fontSize: 10),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
          ],
        ),
        IconButton(
          icon: const Icon(Icons.favorite),
          onPressed: () => context.go('/wishlist'),
        ),
        if (authState.isAdmin)
          IconButton(
            icon: const Icon(Icons.admin_panel_settings),
            onPressed: () => context.go('/admin'),
          ),
        if (authState.isLoggedIn)
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              context.read<AuthCubit>().logout();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Sesión cerrada')),
              );
            },
          )
        else
          IconButton(
            icon: const Icon(Icons.login),
            onPressed: () => context.go('/login'),
          ),
      ],
    );
  }
}
