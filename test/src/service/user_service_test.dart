import 'package:codyo/src/service/user_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() {
  group('UserService', () {
    late final UserService userService;

    setUpAll(() async {
      await dotenv.load(fileName: 'asset/.env');
      await Supabase.initialize(
        url: dotenv.env['URL'].toString(),
        anonKey: dotenv.env['API_KEY'].toString(),
      );

      userService = UserService();
    });

    test('Get user by id', () async {
      try {
        const userId = 3;
        final result = await userService.getUserById(userId);
      } on PostgrestException catch (e) {
        debugPrint(e.message);
      }
    });
  });
}
