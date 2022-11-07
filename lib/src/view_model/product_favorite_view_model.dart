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

  Future<void> getFavoriteProductByUserId() async {
    final userId = await _sharedService.getUserId();
    if (userId == null) return;

    try {} on PostgrestException {}
  }

  Future<void> createFavorite() async {
    final userId = await _sharedService.getUserId();
    if (userId == null) return;

    try {} on PostgrestException {}
  }

  Future<void> removeFavorite() async {
    try {} on PostgrestException {}
  }
}

final productFavoriteViewModel = ChangeNotifierProvider(
  (ref) => ProductFavoriteNotifier(),
);
