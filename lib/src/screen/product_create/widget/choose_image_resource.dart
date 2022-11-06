import 'package:codyo/src/widget/text_pro.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class ChooseImageResource extends StatelessWidget {
  final void Function() onPressed;

  const ChooseImageResource({
    super.key,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return DottedBorder(
      borderType: BorderType.RRect,
      radius: const Radius.circular(14),
      dashPattern: const [6, 6 * 2],
      strokeWidth: 1.5,
      color: Colors.grey.shade400,
      padding: const EdgeInsets.all(8),
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 250,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Opacity(
              opacity: 0.09,
              child: LottieBuilder.asset(
                'asset/lottie/upload_image.json',
                width: 100,
              ),
            ),
            TextPro(
              'Image from camera or gallery',
              color: Colors.grey.shade500,
              fontWeight: FontWeight.w300,
              fontSize: 18,
            ),
            const SizedBox(height: 16),
            Stack(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade100,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const TextPro(
                    'Choose Resource Image',
                    color: Colors.blue,
                  ),
                ),
                Positioned.fill(
                  child: Material(
                    borderRadius: BorderRadius.circular(14),
                    color: Colors.transparent,
                    clipBehavior: Clip.hardEdge,
                    child: InkWell(
                      splashColor: Colors.white.withOpacity(0.3),
                      onTap: onPressed,
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
