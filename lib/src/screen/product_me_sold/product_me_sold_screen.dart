import 'package:codyo/src/widget/text_pro.dart';
import 'package:flutter/material.dart';

class ProductMeSoldScreen extends StatefulWidget {
  const ProductMeSoldScreen({super.key});

  @override
  State<ProductMeSoldScreen> createState() => _ProductMeSoldScreenState();
}

class _ProductMeSoldScreenState extends State<ProductMeSoldScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const TextPro('Items Sold'),
        iconTheme: const IconThemeData(
          color: Colors.black54,
        ),
        titleTextStyle: const TextStyle(
          color: Colors.black54,
          fontWeight: FontWeight.w600,
        ),
        elevation: 0.5,
      ),
    );
  }
}
