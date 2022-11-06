import 'package:codyo/src/exception/auth_exception.dart';
import 'package:codyo/src/model/user_model.dart';
import 'package:codyo/src/service/auth_service.dart';
import 'package:codyo/src/util/error_message.dart';
import 'package:codyo/src/util/finite_state.dart';
import 'package:flutter/material.dart' show ChangeNotifier;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart' show PostgrestException;

class SignUpNotifier extends ChangeNotifier with FiniteState, ErrorMessage {
  final _authService = AuthService();

  void cleaning() {
    setState(StateAction.idle);
    setErrorMessage('');
  }

  Future<bool> signUp(User user) async {
    setState(StateAction.loading);
    try {
      final result = await _authService.signUp(user);
      setErrorMessage('');
      setState(StateAction.idle);
      return result;
    } on AuthException catch (e) {
      setErrorMessage(e.message);
      setState(StateAction.error);
      return false;
    } on PostgrestException catch (e) {
      setErrorMessage(e.message);
      setState(StateAction.error);
      return false;
    }
  }
}

final signUpViewModel = ChangeNotifierProvider((ref) => SignUpNotifier());
