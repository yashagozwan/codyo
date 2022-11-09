import 'package:codyo/src/screen/sign_up/sign_up_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Sign Up Screen', () {
    testWidgets(
      'check illustration',
      (widgetTester) async {
        await widgetTester.pumpWidget(const ProviderScope(
          child: MaterialApp(
            home: SignUpScreen(),
          ),
        ));

        final illustration = find.byKey(const Key('sign_up_illustration'));
        expect(illustration, findsOneWidget);
      },
    );

    testWidgets(
      'check title',
      (widgetTester) async {
        await widgetTester.pumpWidget(const ProviderScope(
          child: MaterialApp(
            home: SignUpScreen(),
          ),
        ));

        final signUpTitle = find.byKey(const Key('sign_up_title'));
        expect(signUpTitle, findsOneWidget);
      },
    );

    testWidgets(
      'check 4 text field',
      (widgetTester) async {
        await widgetTester.pumpWidget(const ProviderScope(
          child: MaterialApp(
            home: SignUpScreen(),
          ),
        ));

        final signUpTextFormFieldName =
            find.byKey(const Key('sign_up_text_form_field_name'));

        final signUpTextFormFieldEmail =
            find.byKey(const Key('sign_up_text_form_field_email'));

        final signUpTextFormFieldPhone =
            find.byKey(const Key('sign_up_text_form_field_phone'));

        final signUpTextFormFieldPassword =
            find.byKey(const Key('sign_up_text_form_field_password'));

        expect(signUpTextFormFieldName, findsOneWidget);
        expect(signUpTextFormFieldEmail, findsOneWidget);
        expect(signUpTextFormFieldPhone, findsOneWidget);
        expect(signUpTextFormFieldPassword, findsOneWidget);
        expect(signUpTextFormFieldPassword, findsOneWidget);
      },
    );

    testWidgets(
      'check button sign up',
      (widgetTester) async {
        await widgetTester.pumpWidget(const ProviderScope(
          child: MaterialApp(
            home: SignUpScreen(),
          ),
        ));

        final signUpButton = find.byKey(const Key('sign_up_button'));
        expect(signUpButton, findsOneWidget);
      },
    );

    testWidgets(
      'check text sign in and button sign in',
      (widgetTester) async {
        await widgetTester.pumpWidget(const ProviderScope(
          child: MaterialApp(
            home: SignUpScreen(),
          ),
        ));

        final signInText = find.byKey(const Key('sign_in_text'));
        final signInTextButton = find.byKey(const Key('sign_in_text_button'));

        expect(signInText, findsOneWidget);
        expect(signInTextButton, findsOneWidget);
      },
    );
  });
}
