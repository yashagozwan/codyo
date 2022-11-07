import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class EmptyProduct extends StatelessWidget {
  const EmptyProduct({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: DottedBorder(
        borderType: BorderType.RRect,
        dashPattern: const [6, 12],
        radius: const Radius.circular(14),
        color: Colors.grey.shade300,
        padding: const EdgeInsets.all(14),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Lottie.asset(
            'asset/lottie/empty_product.json',
            height: 230,
          ),
        ),
      ),
    );
  }
}
