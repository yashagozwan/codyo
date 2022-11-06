import 'package:flutter/material.dart' show ChangeNotifier;

mixin ErrorMessage on ChangeNotifier {
  String errorMessage = '';

  void setErrorMessage(String message) {
    errorMessage = message;
    notifyListeners();
  }
}
