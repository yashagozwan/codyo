import 'package:codyo/src/widget/text_pro.dart';
import 'package:flutter/material.dart';

class ProductTitle extends StatelessWidget {
  final String title;
  const ProductTitle({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: TextPro(
        title,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}
