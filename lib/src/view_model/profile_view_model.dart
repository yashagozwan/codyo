import 'package:codyo/src/model/product_model.dart';
import 'package:codyo/src/model/user_model.dart';
import 'package:codyo/src/service/product_service.dart';
import 'package:codyo/src/service/shared_service.dart';
import 'package:codyo/src/service/user_service.dart';
import 'package:codyo/src/util/error_message.dart';
import 'package:codyo/src/util/finite_state.dart';
import 'package:flutter/material.dart' show ChangeNotifier;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart' show PostgrestException;

class ProfileNotifier extends ChangeNotifier with FiniteState, ErrorMessage {
  final _userService = UserService();
  final _productService = ProductService();
  final _shareService = SharedService();

  Iterable<Product> notSoldProducts = [];
  Iterable<Product> soldProducts = [];

  Future<void> getProductById() async {
    final userId = await _shareService.getUserId();
    if (userId == null) return;

    setState(StateAction.loading);
    try {
      final products = await _productService.getProductByUserId(userId);
      notSoldProducts = products;
      setState(StateAction.idle);
    } on PostgrestException {
      setState(StateAction.error);
      rethrow;
    }
  }

  Future<void> getSoldProductById() async {
    final userId = await _shareService.getUserId();
    if (userId == null) return;

    setState(StateAction.loading);
    try {
      final products = await _productService.getSoldProductByUserId(userId);
      soldProducts = products;
      setState(StateAction.idle);
    } on PostgrestException {
      setState(StateAction.error);
      rethrow;
    }
  }

  Future<User?> getUserById() async {
    final userId = await _shareService.getUserId();
    if (userId == null) return null;
    try {
      return await _userService.getUserById(userId);
    } on PostgrestException {
      rethrow;
    }
  }

  Future<bool> signOut() async {
    final removeUser = await _shareService.removeUser();
    final removeUserId = await _shareService.removeUserId();
    return removeUser && removeUserId;
  }
}

final profileViewModel =
    ChangeNotifierProvider<ProfileNotifier>((ref) => ProfileNotifier());
