import 'package:flutter/material.dart';
import 'package:shopping_rd/models/product.dart';

class ProductTile extends StatelessWidget {
  final Product product;
  final void Function()? onTap;
  ProductTile({super.key, required this.product, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 12),
      width: 100,
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 70,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: product.imagePath.startsWith('http')
                  ? Image.network(product.imagePath)
                  : Image.asset(product.imagePath),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              product.name,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
          Text('RD\$ ${product.price}',
              style: TextStyle(color: Colors.grey[600])),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: onTap,
            style: ElevatedButton.styleFrom(minimumSize: const Size(100, 30)),
            child: const Text('Agregar al carrito'),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}