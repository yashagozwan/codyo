import 'package:codyo/src/model/product_model.dart';
import 'package:codyo/src/service/product_service.dart';
import 'package:codyo/src/util/finite_state.dart';
import 'package:flutter/material.dart' show ChangeNotifier;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProductListNotifier extends ChangeNotifier with FiniteState {
  final _productService = ProductService();

  Iterable<Product> products = [];
  Iterable<Product> threeNewProducts = [];

  String searchValue = '';

  void setSearchValue(String search) {
    searchValue = search;
    notifyListeners();
  }

  Future<Iterable<Product>> getProducts() async {
    setState(StateAction.loading);
    try {
      final fetchProducts = await _productService.getProducts();
      products = fetchProducts.toList().sublist(3);
      notifyListeners();
      return fetchProducts;
    } on PostgrestException {
      rethrow;
    }
  }

  Future<Iterable<Product>> getNewThreeProducts() async {
    setState(StateAction.loading);
    try {
      final products = await _productService.getNewThreeProducts();
      threeNewProducts = products;
      notifyListeners();
      setState(StateAction.idle);
      return products;
    } on PostgrestException {
      setState(StateAction.error);
      rethrow;
    }
  }

  Future<void> searchProducts(String search) async {
    setState(StateAction.loading);
    try {
      final fetchProducts = await _productService.searchProducts(search);
      products = fetchProducts;
      setState(StateAction.idle);
    } on PostgrestException {
      setState(StateAction.error);
      rethrow;
    }
  }
}

final productListViewModel =
    ChangeNotifierProvider<ProductListNotifier>((ref) => ProductListNotifier());
