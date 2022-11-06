import 'package:codyo/src/model/product_model.dart';
import 'package:codyo/src/service/product_service.dart';
import 'package:codyo/src/service/shared_service.dart';
import 'package:codyo/src/util/error_message.dart';
import 'package:codyo/src/util/finite_state.dart';
import 'package:flutter/material.dart' show ChangeNotifier;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProductMeNotifier extends ChangeNotifier with FiniteState, ErrorMessage {
  final _productService = ProductService();
  final _sharedService = SharedService();

  Iterable<Product> products = [];

  Future<void> getProductsByUserId() async {
    final userId = await _sharedService.getUserId();
    if (userId == null) return;

    setState(StateAction.loading);
    try {
      final fetchProducts = await _productService.getProductByUserId(userId);
      products = fetchProducts;
      notifyListeners();
      setState(StateAction.idle);
    } on PostgrestException {
      setState(StateAction.error);
      rethrow;
    }
  }
}

final productMeViewModel =
    ChangeNotifierProvider<ProductMeNotifier>((ref) => ProductMeNotifier());
