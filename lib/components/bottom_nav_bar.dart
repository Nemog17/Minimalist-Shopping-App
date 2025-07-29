import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubits/cart_cubit.dart';

class MyBottomNavBar extends StatelessWidget {
  void Function(int)? onTabChange;
   MyBottomNavBar({super.key, required this.onTabChange});

  @override
  Widget build(BuildContext context) {
    final cartCount = context.watch<CartCubit>().state.userCart.length;
    String cartText;
    if (cartCount == 1) {
      cartText = 'Cart (1 item)';
    } else if (cartCount == 2) {
      cartText = 'Cart (2 items)';
    } else if (cartCount > 0) {
      cartText = 'Cart ($cartCount items)';
    } else {
      cartText = 'Cart';
    }

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      child: GNav(
        color: Colors.grey[400],
        activeColor: Colors.grey[700],
        tabActiveBorder: Border.all(color: Colors.white),
        tabBackgroundColor: Colors.grey.shade100,
        onTabChange: (value) => onTabChange!(value),
        tabs: [
          const GButton(
            icon: Icons.home,
            text: 'Shop',
          ),
          GButton(
            icon: Icons.shopping_bag_rounded,
            text: cartText,
          )
        ],
      ),
    );
  }
}