import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_rd/models/cart.dart';

import '../models/product.dart';

class CartItem extends StatefulWidget {
  Product product;
  CartItem({super.key, required this.product});

  @override
  State<CartItem> createState() => _CartItemState();
}

class _CartItemState extends State<CartItem> {

  //remove item from cart
void removeItemFromCart(){
  Provider.of<Cart>(context, listen:false).removeItemFromCart(widget.product);
}

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration:BoxDecoration(color: Colors.grey[100],
      borderRadius: BorderRadius.circular(8),
      ),
      margin: const EdgeInsets.only(bottom:10),
      child: ListTile(
        leading: widget.product.imagePath.startsWith('http')
            ? Image.network(widget.product.imagePath)
            : Image.asset(widget.product.imagePath),
        title: Text(widget.product.name),
        subtitle: Text(widget.product.price),
        trailing: IconButton(icon:Icon(Icons.delete), 
        onPressed: removeItemFromCart,
        ),
      ),
    );
  }
}