import 'package:codyo/src/constant/constant.dart';
import 'package:codyo/src/exception/favorite_exeption.dart';
import 'package:codyo/src/model/favorite_model.dart';
import 'package:codyo/src/model/product_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class FavoriteService {
  static const _favoriteTable = 'favorites';
  static const _productsTable = 'products';

  Future<Iterable<Product>> getFavoriteProductsByUserId(int userId) async {
    try {
      final List<Product> productFavorite = [];
      final favorites = await _getFavoriteByUserId(userId);

      for (Favorite favorite in favorites) {
        final product = await _getProductById(favorite.productId);
        if (product != null) {
          productFavorite.add(product);
        }
      }

      return productFavorite;
    } on PostgrestException {
      rethrow;
    }
  }

  Future<Product?> _getProductById(int id) async {
    try {
      final product =
          await supabase.from(_productsTable).select().eq('id', id).single();
      return Product.fromMap(product);
    } on PostgrestException {
      return null;
    }
  }

  Future<bool> createFavorite(Favorite favorite, int userId) async {
    try {
      final favorites = await _getFavoriteByUserId(userId);
      final findFavorites =
          favorites.where((fav) => fav.productId == favorite.productId);

      if (findFavorites.isNotEmpty) {
        throw FavoriteException(message: 'Item already saved');
      }

      await supabase.from(_favoriteTable).insert(favorite.toPostgres());
      return true;
    } on PostgrestException {
      rethrow;
    }
  }

  Future<Iterable<Favorite>> _getFavoriteByUserId(int userId) async {
    try {
      final favorites = await supabase
          .from(_favoriteTable)
          .select()
          .eq('userId', userId) as Iterable;

      return favorites.map((favorite) => Favorite.fromMap(favorite));
    } on PostgrestException {
      rethrow;
    }
  }

  Future<bool> removeProductFavorite(Favorite favorite) async {
    try {
      await supabase
          .from(_favoriteTable)
          .delete()
          .eq('id', favorite.id)
          .single();

      return true;
    } on PostgrestException {
      rethrow;
    }
  }
}
