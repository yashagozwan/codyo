import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class UploadLoading extends StatelessWidget {
  const UploadLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return DottedBorder(
      borderType: BorderType.RRect,
      radius: const Radius.circular(14),
      padding: const EdgeInsets.all(14),
      dashPattern: const [6, 12],
      color: Colors.grey.shade400,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          color: Colors.grey.shade100,
        ),
        width: MediaQuery.of(context).size.width,
        height: 200,
        child: Lottie.asset('asset/lottie/upload_v2.json'),
      ),
    );
  }
}
