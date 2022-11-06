import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class CoolLoading extends StatelessWidget {
  const CoolLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: DottedBorder(
        color: Colors.grey.shade500,
        padding: const EdgeInsets.all(14),
        borderType: BorderType.RRect,
        radius: const Radius.circular(14),
        dashPattern: const [5, 12],
        child: Container(
          width: 200,
          height: 200,
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
          ),
          child: Lottie.asset(
            'asset/lottie/loading_v2.json',
            repeat: true,
          ),
        ),
      ),
    );
  }
}
