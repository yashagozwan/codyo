import 'package:codyo/src/constant/constant.dart';
import 'package:codyo/src/exception/auth_exception.dart';
import 'package:codyo/src/model/sign_in_model.dart';
import 'package:codyo/src/model/user_model.dart';
import 'package:codyo/src/service/shared_service.dart';
import 'package:codyo/src/util/util.dart';
import 'package:supabase_flutter/supabase_flutter.dart' show PostgrestException;

class AuthService {
  final SharedService _sharedService = SharedService();
  final _usersTable = 'users';

  Future<bool> signUp(User user) async {
    try {
      final checkEmail = await supabase
          .from(_usersTable)
          .select()
          .eq('email', user.email) as List;

      if (checkEmail.isNotEmpty) {
        throw AuthException(message: 'Email already registered');
      }

      final checkPhone = await supabase
          .from(_usersTable)
          .select()
          .eq('phone', user.phone) as List;

      if (checkPhone.isNotEmpty) {
        throw AuthException(message: 'Phone already registered');
      }

      await supabase.from(_usersTable).insert(user.toPostgres());
      return true;
    } on PostgrestException {
      rethrow;
    }
  }

  Future<bool> signIn(SignIn signIn) async {
    try {
      final users = await supabase
          .from(_usersTable)
          .select()
          .eq('email', signIn.email) as List;

      if (users.isEmpty) {
        throw AuthException(message: 'Invalid email or password');
      }

      final user = User.fromMap(users.first);
      final isValid = Util.verifyPassword(signIn.password, user.password);
      if (!isValid) {
        throw AuthException(message: 'Invalid email or password');
      }

      final result = await _sharedService.saveUser(user);
      final resultUserId = await _sharedService.saveUserId(user.id);
      return result && resultUserId;
    } on PostgrestException {
      rethrow;
    }
  }
}
