import 'package:codyo/src/service/product_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() {
  group('Product Service', () {
    late final ProductService productService;

    setUpAll(() async {
      await dotenv.load(fileName: 'asset/.env');
      await Supabase.initialize(
        url: dotenv.env['URL'].toString(),
        anonKey: dotenv.env['API_KEY'].toString(),
      );

      productService = ProductService();
    });

    test('Get all products', () async {
      try {
        final products = await productService.getProducts();
        expect(products, isNotEmpty);
      } on PostgrestException catch (e) {
        debugPrint(e.message);
      }
    });
  });
}
