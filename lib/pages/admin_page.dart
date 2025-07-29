import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/product.dart';
import '../cubits/cart_cubit.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({super.key});

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  final TextEditingController _name = TextEditingController();
  final TextEditingController _price = TextEditingController();
  final TextEditingController _description = TextEditingController();
  final TextEditingController _image = TextEditingController();
  bool _draft = false;

  void _addProduct() {
    final cubit = context.read<CartCubit>();
    final product = Product(
      name: _name.text,
      price: _price.text,
      description: _description.text,
      imagePath: _image.text,
      isDraft: _draft,
    );
    cubit.addProductToShop(product);
    _name.clear();
    _price.clear();
    _description.clear();
    _image.clear();
    _draft = false;
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<CartCubit>();
    final cart = context.watch<CartCubit>().state;
    return Scaffold(
      appBar: AppBar(title: const Text('Admin Panel')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: _name,
                decoration: const InputDecoration(labelText: 'Name'),
              ),
              TextField(
                controller: _price,
                decoration: const InputDecoration(labelText: 'Price'),
              ),
              TextField(
                controller: _description,
                decoration: const InputDecoration(labelText: 'Description'),
              ),
              TextField(
                controller: _image,
                decoration: const InputDecoration(labelText: 'Image URL'),
              ),
              SwitchListTile(
                title: const Text('Draft'),
                value: _draft,
                onChanged: (value) => setState(() => _draft = value),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: _addProduct,
                child: const Text('Add Product'),
              ),
              const SizedBox(height: 20),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: cart.productShop.length,
                itemBuilder: (context, index) {
                  final product = cart.productShop[index];
                  return ListTile(
                    title: Text(product.name),
                    subtitle: Text(product.price),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Switch(
                          value: product.isDraft,
                          onChanged: (val) {
                            setState(() {
                              product.isDraft = val;
                            });
                            cubit.updateProduct(index, product);
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () {
                            cubit.removeProductAt(index);
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
