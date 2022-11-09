import 'package:codyo/src/screen/splash/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Splash Screen', () {
    testWidgets('check logo app', (widgetTester) async {
      await widgetTester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: SplashScreen(),
          ),
        ),
      );

      await widgetTester.pump(const Duration(milliseconds: 3000));
      final splashLogoApp = find.byKey(const Key('splash_logo_app'));
      expect(splashLogoApp, findsOneWidget);
    });

    testWidgets('check title', (widgetTester) async {
      await widgetTester.pumpWidget(const ProviderScope(
        child: MaterialApp(
          home: SplashScreen(),
        ),
      ));

      await widgetTester.pump(const Duration(milliseconds: 3000));
      final splashTitle = find.byKey(const Key('splash_title'));
      expect(splashTitle, findsOneWidget);
    });

    testWidgets('check hash tag', (widgetTester) async {
      await widgetTester.pumpWidget(const ProviderScope(
        child: MaterialApp(
          home: SplashScreen(),
        ),
      ));

      await widgetTester.pump(const Duration(milliseconds: 3000));
      final splashHashTag = find.byKey(const Key('splash_hash_tag'));
      expect(splashHashTag, findsOneWidget);
    });
  });
}
