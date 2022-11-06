import 'package:codyo/src/exception/auth_exception.dart';
import 'package:codyo/src/model/sign_in_model.dart';
import 'package:codyo/src/model/user_model.dart';
import 'package:codyo/src/service/auth_service.dart';
import 'package:codyo/src/util/util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/supabase_flutter.dart'
    show PostgrestException, Supabase;

void main() {
  group('Auth Service', () {
    late final AuthService authService;

    setUpAll(() async {
      await dotenv.load(fileName: 'asset/.env');
      await Supabase.initialize(
        url: dotenv.env['URL'].toString(),
        anonKey: dotenv.env['API_KEY'].toString(),
      );

      authService = AuthService();
    });

    test('Sign Up', () async {
      try {
        final user = User(
          name: 'Yasha Gozwan Shuhada',
          email: 'yasha@gmail.com',
          password: '123456',
          phone: '087875336077',
        );

        final result = await authService.signUp(user);
        expect(result, true);
      } on AuthException catch (error) {
        debugPrint(error.message);
      } on PostgrestException catch (error) {
        debugPrint(error.message);
      }
    });

    test('Sign In', () async {
      try {
        final signIn = SignIn(email: 'yasha@gmail.com', password: '123456');
        final result = await authService.signIn(signIn);
        expect(result, true);
      } on AuthException catch (error) {
        debugPrint(error.message);
      } on PostgrestException catch (error) {
        debugPrint(error.message);
      }
    });
  });
}
