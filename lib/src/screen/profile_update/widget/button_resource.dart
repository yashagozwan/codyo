import 'package:codyo/src/widget/text_pro.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';

class ButtonResource extends StatelessWidget {
  final void Function() onPressed;
  final Color backgroundColor;
  final Color borderColor;
  final Icon icon;
  final TextPro text;
  final Color? splashColor;

  const ButtonResource({
    super.key,
    required this.onPressed,
    required this.text,
    required this.icon,
    required this.backgroundColor,
    required this.borderColor,
    this.splashColor,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        DottedBorder(
          borderType: BorderType.RRect,
          color: borderColor,
          padding: const EdgeInsets.all(4),
          radius: const Radius.circular(14),
          child: Container(
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [icon, const SizedBox(height: 4), text],
            ),
          ),
        ),
        Positioned.fill(
          child: Material(
            borderRadius: BorderRadius.circular(14),
            clipBehavior: Clip.hardEdge,
            color: Colors.transparent,
            child: InkWell(
              onTap: onPressed,
              splashColor: splashColor,
            ),
          ),
        )
      ],
    );
  }
}
