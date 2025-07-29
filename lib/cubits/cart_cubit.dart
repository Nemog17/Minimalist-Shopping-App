import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/product.dart';
import '../services/fake_store_api.dart';
import '../services/dummy_json_service.dart';

class CartState {
  final List<Product> productShop;
  final List<Product> userCart;
  final List<Product> savedForLater;

  const CartState({
    this.productShop = const [],
    this.userCart = const [],
    this.savedForLater = const [],
  });

  CartState copyWith({
    List<Product>? productShop,
    List<Product>? userCart,
    List<Product>? savedForLater,
  }) {
    return CartState(
      productShop: productShop ?? this.productShop,
      userCart: userCart ?? this.userCart,
      savedForLater: savedForLater ?? this.savedForLater,
    );
  }
}

class CartCubit extends Cubit<CartState> {
  CartCubit() : super(const CartState());

  Future<void> loadProducts() async {
    final List<Product> allProducts = [];
    try {
      allProducts.addAll(await FakeStoreApi.fetchProducts());
    } catch (_) {
      // Ignore network errors from the fake store API
    }

    try {
      // Fetch all available DummyJSON products in a single call.
      allProducts.addAll(
        await DummyJsonService.fetchProducts(limit: 194),
      );
    } catch (_) {
      // Ignore network errors from the DummyJSON API
    }

    emit(state.copyWith(productShop: allProducts));
  }

  void addItemToCart(Product product) {
    final updatedCart = List<Product>.from(state.userCart)..add(product);
    emit(state.copyWith(userCart: updatedCart));
  }

  void saveItemForLater(Product product) {
    final cart = List<Product>.from(state.userCart)..remove(product);
    final saved = List<Product>.from(state.savedForLater)..add(product);
    emit(state.copyWith(userCart: cart, savedForLater: saved));
  }

  void moveToCart(Product product) {
    final saved = List<Product>.from(state.savedForLater)..remove(product);
    final cart = List<Product>.from(state.userCart)..add(product);
    emit(state.copyWith(userCart: cart, savedForLater: saved));
  }

  void clearCart() {
    emit(state.copyWith(userCart: []));
  }

  void removeItemFromCart(Product product) {
    final cart = List<Product>.from(state.userCart)..remove(product);
    emit(state.copyWith(userCart: cart));
  }

  void removeItemFromSaved(Product product) {
    final saved = List<Product>.from(state.savedForLater)..remove(product);
    emit(state.copyWith(savedForLater: saved));
  }

  void addProductToShop(Product product) {
    final list = List<Product>.from(state.productShop)..add(product);
    emit(state.copyWith(productShop: list));
  }

  void updateProduct(int index, Product product) {
    final list = List<Product>.from(state.productShop);
    if (index >= 0 && index < list.length) {
      list[index] = product;
      emit(state.copyWith(productShop: list));
    }
  }

  void removeProductAt(int index) {
    final list = List<Product>.from(state.productShop)..removeAt(index);
    emit(state.copyWith(productShop: list));
  }
}
