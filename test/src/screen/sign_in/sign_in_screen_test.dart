import 'package:codyo/src/screen/sign_in/sign_in_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Sign In Screen', () {
    testWidgets('check illustration and sign in title', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: SignInScreen(),
          ),
        ),
      );

      final signInIllustration = find.byKey(const Key('sign_in_illustration'));

      final titleSignIn = find.byKey(const Key('title_sign_in'));

      expect(signInIllustration, findsOneWidget);
      expect(titleSignIn, findsOneWidget);
    });

    testWidgets('check 2 text field email and password', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: SignInScreen(),
          ),
        ),
      );

      final textFormFieldEmail = find.byKey(const Key('text_form_field_email'));
      final textFormFieldPassword =
          find.byKey(const Key('text_form_field_password'));

      expect(textFormFieldEmail, findsOneWidget);
      expect(textFormFieldPassword, findsOneWidget);
    });

    testWidgets('check button sign in', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(home: SignInScreen()),
        ),
      );

      final buttonSignIn = find.byKey(const Key('button_sign_in'));
      expect(buttonSignIn, findsOneWidget);
    });

    testWidgets('check text button sign up', (tester) async {
      await tester.pumpWidget(const ProviderScope(
        child: MaterialApp(home: SignInScreen()),
      ));

      final textSignUp = find.byKey(const Key('text_sign_up'));
      final buttonSignUp = find.byKey(const Key('button_sign_up'));

      expect(textSignUp, findsOneWidget);
      expect(buttonSignUp, findsOneWidget);
    });
  });
}
