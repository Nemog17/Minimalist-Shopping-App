import 'package:flutter/material.dart';

import 'product.dart';
import '../services/fake_store_api.dart';
import '../services/woocommerce_service.dart';

class Cart extends ChangeNotifier{
  //list of products for sale
  List<Product> productShop = [];

  //list of items in user cart

  List<Product> userCart=[];

  //load products from APIs
  Future<void> loadProducts() async {
    final List<Product> allProducts = [];

    try {
      allProducts.addAll(await FakeStoreApi.fetchProducts());
    } catch (_) {
      // Ignore network errors from the fake store API
    }

    final wooService = WooCommerceService(
      baseUrl: 'https://example.com',
      consumerKey: 'ck_your_key',
      consumerSecret: 'cs_your_secret',
    );

    try {
      allProducts.addAll(await wooService.fetchProducts());
    } catch (_) {
      // Errors are already handled inside [fetchProducts]
    }

    productShop = allProducts;
    notifyListeners();
  }

  //getting list of products for sale
  List<Product> getProductList()
  {
    return productShop;

  }

  //get cart
  List<Product> getUserCart()
  {
    return userCart;
  }

  //add items to cart
  void addItemToCart(Product product)
  {
    userCart.add(product);
    notifyListeners();
  }

  //remove items from cart
void removeItemFromCart(Product product)
{
  userCart.remove(product);
  notifyListeners();
}
}
