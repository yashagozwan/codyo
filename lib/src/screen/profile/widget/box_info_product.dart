import 'package:flutter/material.dart';

class BoxInfoProduct extends StatelessWidget {
  final Icon icon;
  final Widget content;
  final Color color;
  final void Function()? onPressed;
  final Color? splashColor;

  const BoxInfoProduct({
    super.key,
    required this.icon,
    required this.content,
    required this.color,
    this.onPressed,
    this.splashColor,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
              width: 1,
              color: Colors.grey.shade200,
            ),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Column(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                ),
                child: icon,
              ),
              const SizedBox(height: 8),
              content,
            ],
          ),
        ),
        Positioned.fill(
          child: Material(
            borderRadius: BorderRadius.circular(14),
            clipBehavior: Clip.hardEdge,
            color: Colors.transparent,
            child: InkWell(
              splashColor: splashColor,
              onTap: onPressed,
            ),
          ),
        )
      ],
    );
  }
}
