import 'package:flutter/material.dart';

class ScreenRoute<T> extends PageRouteBuilder {
  Widget screen;
  T? arguments;
  ScreenRoute({
    required this.screen,
    this.arguments,
  }) : super(
          settings: RouteSettings(
            arguments: arguments,
          ),
          pageBuilder: (_, __, ___) => screen,
          transitionsBuilder: (_, animation, __, child) {
            return SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(-1.0, 0),
                end: const Offset(0.0, 0.0),
              ).animate(CurvedAnimation(parent: animation, curve: Curves.ease)),
              child: child,
            );
          },
          transitionDuration: const Duration(milliseconds: 300),
        );
}
