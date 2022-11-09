import 'package:codyo/src/model/product_model.dart';
import 'package:codyo/src/screen/product_list/product_list_screen.dart';
import 'package:codyo/src/view_model/product_list_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

class FakeProductListNotifier extends ProductListNotifier {
  @override
  Future<Iterable<Product>> getProducts() async {
    List<Product> products = [];
    return products;
  }

  @override
  Future<Iterable<Product>> getNewThreeProducts() async {
    List<Product> products = [];
    return products;
  }
}

void main() {
  group('Product List Screen', () {
    testWidgets('check logo', (widgetTester) async {
      await widgetTester.pumpWidget(
        ProviderScope(
          overrides: [
            productListViewModel.overrideWith((ref) {
              return FakeProductListNotifier();
            }),
          ],
          child: const MaterialApp(
            home: ProductListScreen(),
          ),
        ),
      );

      await widgetTester.pump(Duration.zero);
      final logoApp = find.byKey(const Key('logo_app'));
      expect(logoApp, findsOneWidget);
    });

    testWidgets('check search text field', (widgetTester) async {
      await widgetTester.pumpWidget(
        ProviderScope(
          overrides: [
            productListViewModel.overrideWith((ref) {
              return FakeProductListNotifier();
            }),
          ],
          child: const MaterialApp(
            home: ProductListScreen(),
          ),
        ),
      );

      await widgetTester.pump(Duration.zero);
      final textFieldSearch =
          find.byKey(const Key('product_list_text_field_search'));
      expect(textFieldSearch, findsOneWidget);
    });

    testWidgets('check product empty', (widgetTester) async {
      await widgetTester.pumpWidget(
        ProviderScope(
          overrides: [
            productListViewModel.overrideWith((ref) {
              return FakeProductListNotifier();
            }),
          ],
          child: const MaterialApp(
            home: ProductListScreen(),
          ),
        ),
      );

      await widgetTester.pump(const Duration(milliseconds: 3000));
      final productTitle = find.byKey(const Key('product_list_product_empty'));
      expect(productTitle, findsOneWidget);
    });
  });
}
