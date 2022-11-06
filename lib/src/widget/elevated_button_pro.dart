import 'package:flutter/material.dart';

class ElevatedButtonPro extends StatelessWidget {
  final Widget child;
  final void Function() onPressed;
  final double rounded;

  const ElevatedButtonPro({
    super.key,
    required this.onPressed,
    required this.child,
    this.rounded = 14,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.all(14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(rounded),
        ),
      ),
      child: child,
    );
  }
}
