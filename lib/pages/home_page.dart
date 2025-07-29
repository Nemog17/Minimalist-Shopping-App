import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubits/cart_cubit.dart';
import '../models/product.dart';
import 'login_page.dart';
import '../cubits/auth_cubit.dart';
import 'package:go_router/go_router.dart';
import '../components/app_header.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _loading = true;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  final List<String> _categories = ['Todos'];
  String _selectedCategory = 'Todos';

  final Map<String, String> _categoryTranslations = const {
    'smartphones': 'Teléfonos inteligentes',
    'laptops': 'Portátiles',
    'fragrances': 'Fragancias',
    'skincare': 'Cuidado de la piel',
    'groceries': 'Comestibles',
    'home-decoration': 'Decoración del hogar',
    'furniture': 'Muebles',
    'tops': 'Tops',
    'womens-dresses': 'Vestidos de mujer',
    'womens-shoes': 'Zapatos de mujer',
    'mens-shirts': 'Camisas de hombre',
    'mens-shoes': 'Zapatos de hombre',
    'mens-watches': 'Relojes de hombre',
    'womens-watches': 'Relojes de mujer',
    'sunglasses': 'Gafas de sol',
    'bags': 'Bolsos',
    'jewellery': 'Joyería',
    'perfumes': 'Perfumes',
    'lighting': 'Iluminación',
    'motorcycle': 'Motocicletas',
    'automotive': 'Automotriz',
    'electronics': 'Electrónica',
    'jewelery': 'Joyería',
    "men's clothing": 'Ropa de hombre',
    "women's clothing": 'Ropa de mujer',
  };

  String _translateCategory(String category) {
    return _categoryTranslations[category] ?? category;
  }

  @override
  void initState() {
    super.initState();
    context.read<CartCubit>().loadProducts().then((_) {
      final products = context.read<CartCubit>().state.productShop;
      final uniqueCats = products.map((p) => _translateCategory(p.category)).toSet();
      setState(() {
        _categories.addAll(uniqueCats);
        _loading = false;
      });
    });
  }

  void _addToCart(Product product) {
    if (product.stock > 0) {
      context.read<CartCubit>().addItemToCart(product);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Producto agregado')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Sin stock')),
      );
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cartState = context.watch<CartCubit>().state;
    final allProducts = cartState.productShop;
    final products = allProducts.where((p) {
      final matchesSearch =
          p.name.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesCategory = _selectedCategory == 'Todos' ||
          _translateCategory(p.category) == _selectedCategory;
      final isPublished = !p.isDraft;
      return matchesSearch && matchesCategory && isPublished;
    }).toList();
    final cartCount = cartState.userCart.length;
    final authState = context.watch<AuthCubit>().state;

    return Scaffold(
      appBar: const AppHeader(title: 'ShoppingRD'),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Buscar...',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onChanged: (value) => setState(() => _searchQuery = value),
                  ),
                ),
                SizedBox(
                  height: 48,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _categories.length,
                    itemBuilder: (context, index) {
                      final cat = _categories[index];
                      final selected = cat == _selectedCategory;
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 6.0),
                        child: ChoiceChip(
                          label: Text(cat),
                          selected: selected,
                          onSelected: (_) => setState(() {
                            _selectedCategory = cat;
                          }),
                        ),
                      );
                    },
                  ),
                ),
                Expanded(
                  child: GridView.builder(
                    padding: const EdgeInsets.all(12),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      // Display smaller tiles so six items fit per row
                      crossAxisCount: 6,
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                      childAspectRatio: 0.65,
                    ),
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      final product = products[index];
                      return GestureDetector(
                        onTap: () => context.push('/product', extra: product),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Expanded(
                              child: ClipRRect(
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(12),
                                  topRight: Radius.circular(12),
                                ),
                                child: product.imagePath.startsWith('http')
                                    ? Image.network(product.imagePath, fit: BoxFit.cover)
                                    : Image.asset(product.imagePath, fit: BoxFit.cover),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                product.name,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Text(
                                'RD\$ ${product.price}',
                                style: TextStyle(color: Colors.grey[600]),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8.0),
                              child: ElevatedButton(
                                onPressed: () => _addToCart(product),
                                child: const Text('Agregar al carrito'),
                              ),
                            ),
                            const SizedBox(height: 8),
                          ],
                        ),
                      ),
                    );
                  },
                  ),
                ),
              ],
            ),
    );
  }
}

