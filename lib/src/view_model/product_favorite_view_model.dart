import 'package:codyo/src/exception/favorite_exeption.dart';
import 'package:codyo/src/model/favorite_model.dart';
import 'package:codyo/src/model/product_model.dart';
import 'package:codyo/src/service/favorite_service.dart';
import 'package:codyo/src/service/shared_service.dart';
import 'package:codyo/src/util/error_message.dart';
import 'package:codyo/src/util/finite_state.dart';
import 'package:flutter/material.dart' show ChangeNotifier;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProductFavoriteNotifier extends ChangeNotifier
    with FiniteState, ErrorMessage {
  final _sharedService = SharedService();
  final _favoriteService = FavoriteService();
  Iterable<Product> products = [];

  int userId = 0;
  bool isSaveable = false;

  Future<void> checkFavoriteSaveable(int productId) async {
    final userId = await _sharedService.getUserId();
    if (userId == null) return;

    setState(StateAction.loading);
    try {
      final result =
          await _favoriteService.checkFavoriteSaveable(productId, userId);

      isSaveable = result;
      notifyListeners();
      setState(StateAction.idle);
    } on PostgrestException {
      setState(StateAction.error);
      rethrow;
    }
  }

  Future<void> getUserId() async {
    try {
      final fetchUserId = await _sharedService.getUserId();
      if (fetchUserId == null) return;
      userId = fetchUserId;
      notifyListeners();
    } catch (_) {}
  }

  Future<void> getFavoriteProductByUserId() async {
    final userId = await _sharedService.getUserId();
    if (userId == null) return;

    setState(StateAction.loading);
    try {
      final fetchProducts =
          await _favoriteService.getFavoriteProductsByUserId(userId);
      products = fetchProducts;
      notifyListeners();
      setState(StateAction.idle);
    } on PostgrestException {
      setState(StateAction.error);
      rethrow;
    }
  }

  Future<bool> createFavorite(int productId) async {
    final userId = await _sharedService.getUserId();
    if (userId == null) return false;

    final favorite = Favorite(
      productId: productId,
      userId: userId,
    );

    try {
      final result = await _favoriteService.createFavorite(favorite, userId);
      checkFavoriteSaveable(productId);
      return result;
    } on FavoriteException {
      setErrorMessage('Item already saved');
      return false;
    } on PostgrestException {
      rethrow;
    }
  }

  Future<void> removeFavoriteByProductIdAndByUserId(int productId) async {
    final userId = await _sharedService.getUserId();
    if (userId == null) return;

    try {
      await _favoriteService.removeFavoriteByProductIdAndByUserId(
        productId,
        userId,
      );
      checkFavoriteSaveable(productId);
      getFavoriteProductByUserId();
    } on PostgrestException {
      rethrow;
    }
  }

  Future<void> removeFavoriteByProductId(int productId) async {
    try {} on PostgrestException {
      rethrow;
    }
  }
}

final productFavoriteViewModel = ChangeNotifierProvider(
  (ref) => ProductFavoriteNotifier(),
);
