import 'package:codyo/src/model/user_model.dart';
import 'package:codyo/src/service/shared_service.dart';
import 'package:flutter/material.dart' show ChangeNotifier;
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SplashNotifier extends ChangeNotifier {
  final _sharedService = SharedService();

  Future<User?> getLoggedInUser() async {
    return await _sharedService.getLoggedInUser();
  }

  Future<int?> getUserId() async {
    return await _sharedService.getUserId();
  }
}

final splashViewModel =
    ChangeNotifierProvider<SplashNotifier>((ref) => SplashNotifier());
