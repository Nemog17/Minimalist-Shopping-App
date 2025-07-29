import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubits/cart_cubit.dart';
import '../models/product.dart';
import '../components/app_drawer.dart';

class ProductDetailPage extends StatefulWidget {
  final Product product;
  const ProductDetailPage({super.key, required this.product});

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  int _quantity = 1;

  @override
  Widget build(BuildContext context) {
    final product = widget.product;
    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(title: Text(product.name)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: product.imagePath.startsWith('http')
                          ? Image.network(
                              product.imagePath,
                              width: 180,
                              height: 180,
                              fit: BoxFit.cover,
                            )
                          : Image.asset(
                              product.imagePath,
                              width: 180,
                              height: 180,
                              fit: BoxFit.cover,
                            ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(product.description),
                          const SizedBox(height: 10),
                          Text('RD\$ ${product.price}',
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 20)),
                          const SizedBox(height: 10),
                          Text('Stock: ${product.stock}'),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              IconButton(
                                onPressed: _quantity > 1
                                    ? () => setState(() => _quantity--)
                                    : null,
                                icon: const Icon(Icons.remove),
                              ),
                              Text('$_quantity'),
                              IconButton(
                                onPressed: _quantity < product.stock
                                    ? () => setState(() => _quantity++)
                                    : null,
                                icon: const Icon(Icons.add),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          ElevatedButton(
                            onPressed: product.stock > 0
                                ? () {
                                    context.read<CartCubit>().addItemToCart(
                                          product,
                                          quantity: _quantity,
                                        );
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Añadido al carrito'),
                                      ),
                                    );
                                    setState(() => _quantity = 1);
                                  }
                                : null,
                            child: const Text('Agregar al carrito'),
                          ),
                          TextButton(
                            onPressed: () {
                              context.read<CartCubit>().addItemToWishlist(product);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Añadido a wishlist')),
                              );
                            },
                            child: const Text('Agregar a wishlist'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
