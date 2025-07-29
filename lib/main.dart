import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'utils/go_router_refresh_stream.dart';

import 'cubits/cart_cubit.dart';
import 'cubits/auth_cubit.dart';
import 'models/product.dart';
import 'pages/intro_page.dart';
import 'pages/home_page.dart';
import 'pages/login_page.dart';
import 'pages/admin_page.dart';
import 'pages/cart_page.dart';
import 'pages/product_detail_page.dart';
import 'pages/wishlist_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => CartCubit()),
        BlocProvider(create: (_) => AuthCubit()),
      ],
      child: BlocBuilder<AuthCubit, AuthState>(
        builder: (context, authState) {
          final authCubit = context.read<AuthCubit>();
          final router = GoRouter(
            initialLocation: '/',
            refreshListenable: GoRouterRefreshStream(authCubit.stream),
            routes: [
              GoRoute(
                path: '/login',
                builder: (context, state) => const LoginPage(),
              ),
              GoRoute(
                path: '/',
                builder: (context, state) => const IntroPage(),
              ),
              GoRoute(
                path: '/home',
                builder: (context, state) => const HomePage(),
              ),
              GoRoute(
                path: '/cart',
                builder: (context, state) => const CartPage(),
              ),
              GoRoute(
                path: '/product',
                builder: (context, state) => ProductDetailPage(
                  product: state.extra as Product,
                ),
              ),
              GoRoute(
                path: '/wishlist',
                builder: (context, state) => const WishlistPage(),
              ),
              GoRoute(
                path: '/admin',
                builder: (context, state) => const AdminPage(),
              ),
            ],
            redirect: (context, state) {
              final isAdmin = authState.isAdmin;
              final loc = state.matchedLocation;
              if (loc == '/login' && authState.isLoggedIn) return '/home';
              if (loc == '/admin' && !isAdmin) return '/home';
              return null;
            },
          );
          return MaterialApp.router(
            debugShowCheckedModeBanner: false,
            routerConfig: router,
          );
        },
      ),
    );
  }
}
