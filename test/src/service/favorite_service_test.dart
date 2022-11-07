import 'package:codyo/src/constant/constant.dart';
import 'package:codyo/src/exception/favorite_exeption.dart';
import 'package:codyo/src/model/favorite_model.dart';
import 'package:codyo/src/service/favorite_service.dart';
import 'package:codyo/src/service/product_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() {
  group('Favorite Service', () {
    late final FavoriteService favoriteService;

    setUpAll(() async {
      await dotenv.load(fileName: 'asset/.env');
      await Supabase.initialize(
        url: dotenv.env['URL'].toString(),
        anonKey: dotenv.env['API_KEY'].toString(),
      );

      favoriteService = FavoriteService();
    });

    test('Create Favorite', () async {
      try {
        const userId = 11;
        const productId = 3;
        final favorite = Favorite(userId: userId, productId: productId);
        final result = await favoriteService.createFavorite(favorite, userId);
        expect(result, true);
      } on FavoriteException catch (e) {
        expect(e.message, 'Item already saved');
      } on PostgrestException catch (e) {
        debugPrint(e.message);
      }
    });

    test('Get Favorite Product', () async {
      try {
        const userId = 11;
        final productsFavorite =
            await favoriteService.getFavoriteProductsByUserId(userId);
        expect(productsFavorite, isNotEmpty);
      } on PostgrestException catch (error) {
        debugPrint(error.message);
      }
    });

    test('Check Favorite Saveable', () async {
      const userId = 11;
      const productId = 11;
      final result =
          await favoriteService.checkFavoriteSaveable(productId, userId);
      debugPrint(result.toString());
    });

    test('Remove Favorite', () async {
      try {
        final favorite = Favorite(id: 1, productId: 12, userId: 11);
        final result =
            await favoriteService.removeProductFavoriteById(favorite.id);
        expect(result, true);
      } on PostgrestException catch (e) {
        expect(
          e.message,
          'JSON object requested, multiple (or no) rows returned',
        );
      }
    });
  });
}
