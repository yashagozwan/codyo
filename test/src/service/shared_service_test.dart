import 'package:codyo/src/model/user_model.dart';
import 'package:codyo/src/service/shared_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Shared Service', () {
    late final SharedService sharedService;

    setUpAll(() {
      sharedService = SharedService();
    });

    test('Save User ...', () async {
      final user = User(
        id: 1,
        name: 'Yasha Gozwan Shuhada',
        email: 'yasha@gmail.com',
        phone: '081315467648',
        password: '123456',
        avatarUrl: 'google.com',
        createdAt: DateTime.now().millisecondsSinceEpoch,
      );
      final result = await sharedService.saveUser(user);
      debugPrint(result.toString());
      expect(result, true);
    });

    test('Get Logged In User...', () async {
      final user = await sharedService.getLoggedInUser();
      debugPrint(user.toString());

      if (user == null) {
        expect(user, null);
      } else {
        expect(user.name, 'Yasha Gozwan Shuhada');
      }
    });

    test('Remove user', () async {
      final result = await sharedService.removeUser();
      final resultUserId = await sharedService.removeUserId();
      debugPrint(result.toString());
      if (result) {
        expect(result, true);
        expect(resultUserId, true);
      } else {
        expect(result, false);
        expect(resultUserId, false);
      }
    });
  });
}
