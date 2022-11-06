import 'package:codyo/src/model/user_model.dart';
import 'package:codyo/src/service/product_service.dart';
import 'package:codyo/src/service/shared_service.dart';
import 'package:codyo/src/service/user_service.dart';
import 'package:codyo/src/util/error_message.dart';
import 'package:codyo/src/util/finite_state.dart';
import 'package:flutter/material.dart' show ChangeNotifier;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart' show PostgrestException;

class ProductDetailNotifier extends ChangeNotifier
    with FiniteState, ErrorMessage {
  final _productService = ProductService();
  final _sharedService = SharedService();
  final _userService = UserService();

  User? user;

  Future<void> getUserById(int userId) async {
    setState(StateAction.loading);
    try {
      final fetchUser = await _userService.getUserById(userId);
      print(fetchUser);
      user = fetchUser;
      notifyListeners();
      setState(StateAction.idle);
    } on PostgrestException {
      setState(StateAction.error);
      rethrow;
    }
  }
}

final productDetailViewModel = ChangeNotifierProvider<ProductDetailNotifier>(
  (ref) => ProductDetailNotifier(),
);
