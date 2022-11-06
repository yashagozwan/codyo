import 'package:flutter/material.dart' show ChangeNotifier;

enum StateAction {
  idle,
  loading,
  error,
}

mixin FiniteState on ChangeNotifier {
  StateAction stateAction = StateAction.idle;

  void setState(StateAction newState) {
    stateAction = newState;
    notifyListeners();
  }
}
