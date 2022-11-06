import 'package:codyo/src/exception/auth_exception.dart';
import 'package:codyo/src/model/sign_in_model.dart';
import 'package:codyo/src/service/auth_service.dart';
import 'package:codyo/src/util/error_message.dart';
import 'package:codyo/src/util/finite_state.dart';
import 'package:flutter/material.dart' show ChangeNotifier;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart' show PostgrestException;

class SignInNotifier extends ChangeNotifier with FiniteState, ErrorMessage {
  final _authService = AuthService();

  void cleaning() {
    setState(StateAction.idle);
    setErrorMessage('');
  }

  Future<bool> signIn(SignIn signIn) async {
    setState(StateAction.loading);
    try {
      final result = await _authService.signIn(signIn);
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

final signInViewModel =
    ChangeNotifierProvider<SignInNotifier>((ref) => SignInNotifier());
