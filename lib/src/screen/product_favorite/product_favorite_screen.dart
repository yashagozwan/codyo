import 'package:codyo/src/widget/text_pro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';

class ProductFavoriteScreen extends ConsumerStatefulWidget {
  const ProductFavoriteScreen({super.key});

  @override
  ConsumerState<ProductFavoriteScreen> createState() {
    return _ProductFavoriteScreenState();
  }
}

class _ProductFavoriteScreenState extends ConsumerState<ProductFavoriteScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Lottie.asset('asset/lottie/favorite_v1.json'),
        titleTextStyle: const TextStyle(
          color: Colors.black54,
          fontWeight: FontWeight.w600,
          fontSize: 18,
        ),
        title: const TextPro('Favorite'),
        elevation: 0.5,
        backgroundColor: Colors.white,
      ),
    );
  }
}
