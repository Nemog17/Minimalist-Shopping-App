import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/product.dart';
import '../cubits/cart_cubit.dart';

class CartItem extends StatelessWidget {
  final Product product;
  final bool isSavedItem;
  final int quantity;
  const CartItem({
    super.key,
    required this.product,
    this.isSavedItem = false,
    this.quantity = 1,
  });

  void _remove(BuildContext context) {
    if (isSavedItem) {
      context.read<CartCubit>().removeItemFromSaved(product);
    } else {
      context.read<CartCubit>().removeItemFromCart(product);
    }
  }

  void _toggleSave(BuildContext context) {
    if (isSavedItem) {
      context.read<CartCubit>().moveToCart(product);
    } else {
      context.read<CartCubit>().saveItemForLater(product);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
      ),
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
          leading: product.imagePath.startsWith('http')
              ? Image.network(
                  product.imagePath,
                  width: 60,
                  height: 60,
                  fit: BoxFit.cover,
                )
              : Image.asset(
                  product.imagePath,
                  width: 60,
                  height: 60,
                  fit: BoxFit.cover,
                ),
        title: Text(product.name),
        subtitle: Text('${product.price} - Cantidad: $quantity'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(isSavedItem ? Icons.shopping_cart : Icons.bookmark),
              onPressed: () => _toggleSave(context),
            ),
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () => _remove(context),
            ),
          ],
        ),
      ),
    );
  }
}
