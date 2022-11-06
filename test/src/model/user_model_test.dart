import 'package:codyo/src/model/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('User Model', () {
    test('User and toPostgres', () {
      final user = User(
        id: 10,
        name: 'Yasha Gozwan Shuhada',
        email: 'yasha@gmail.com',
        phone: '087875336077',
        password: '123456',
        createdAt: DateTime.now().millisecondsSinceEpoch,
      );
      debugPrint(user.toPostgres().toString());
      expect(user.name, 'Yasha Gozwan Shuhada');
    });
  });
}
