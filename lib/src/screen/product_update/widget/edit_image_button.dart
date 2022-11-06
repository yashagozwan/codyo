import 'package:flutter/material.dart';

class EditImageButton extends StatelessWidget {
  final void Function() onPressed;
  const EditImageButton({
    super.key,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 60,
      height: 60,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black38,
          padding: const EdgeInsets.all(0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        onPressed: onPressed,
        child: const Icon(
          Icons.edit,
          color: Colors.black54,
        ),
      ),
    );
  }
}
