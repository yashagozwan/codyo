import 'package:codyo/src/widget/text_pro.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';

class ResourceButton extends StatelessWidget {
  final void Function() onPressed;
  final String title;
  final Icon icon;

  const ResourceButton({
    super.key,
    required this.onPressed,
    required this.title,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return DottedBorder(
      borderType: BorderType.RRect,
      padding: const EdgeInsets.all(4),
      radius: const Radius.circular(14),
      color: Colors.grey.shade400,
      dashPattern: const [6, 12],
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.circular(8),
            ),
            child: icon,
          ),
          const SizedBox(width: 16),
          TextPro(
            title,
            color: Colors.black54,
            fontWeight: FontWeight.w600,
          ),
          const Expanded(
            child: SizedBox.shrink(),
          ),
          TextButton(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const TextPro('Open'),
          ),
        ],
      ),
    );
  }
}
