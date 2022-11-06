import 'package:codyo/src/model/user_model.dart';
import 'package:codyo/src/service/user_service.dart';
import 'package:codyo/src/util/error_message.dart';
import 'package:codyo/src/util/finite_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart' show PostgrestException;

class ProfileUpdateViewModel extends ChangeNotifier
    with FiniteState, ErrorMessage {
  final _userService = UserService();

  XFile? xFile;

  void setXFile(XFile? newXFile) {
    xFile = newXFile;
    notifyListeners();
  }

  Future<bool> updateUser(User user) async {
    setState(StateAction.loading);
    try {
      if (xFile != null) {
        final avatarUrl = await _userService.uploadAvatar(xFile!);
        user.avatarUrl = avatarUrl;
      }

      await _userService.updateUser(user);
      setState(StateAction.idle);
      return true;
    } on PostgrestException {
      setState(StateAction.error);
      return false;
    }
  }
}

final profileUpdateViewModel = ChangeNotifierProvider<ProfileUpdateViewModel>(
    (ref) => ProfileUpdateViewModel());
