import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

import 'models/cart.dart';
import 'providers/auth_provider.dart';
import 'pages/intro_page.dart';
import 'pages/home_page.dart';
import 'pages/login_page.dart';
import 'pages/admin_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => Cart()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
      ],
      child: Consumer<AuthProvider>(
        builder: (context, auth, _) {
          final router = GoRouter(
            initialLocation: '/',
            refreshListenable: auth,
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
                path: '/admin',
                builder: (context, state) => const AdminPage(),
              ),
            ],
            redirect: (context, state) {
              final isAdmin = auth.isAdmin;
              final loc = state.matchedLocation;
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
