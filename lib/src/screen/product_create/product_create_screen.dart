import 'package:codyo/src/screen/product_create/widget/create_stucture.dart';
import 'package:codyo/src/view_model/product_create_view_model.dart';
import 'package:codyo/src/widget/cool_loading.dart';
import 'package:codyo/src/widget/text_pro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:lottie/lottie.dart';

class ProductCreateScreen extends ConsumerStatefulWidget {
  const ProductCreateScreen({super.key});

  @override
  ConsumerState<ProductCreateScreen> createState() {
    return _ProductCreateScreenState();
  }
}

class _ProductCreateScreenState extends ConsumerState<ProductCreateScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        leading: Lottie.asset('asset/lottie/sell_v2.json'),
        titleTextStyle: const TextStyle(
          color: Colors.black54,
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
        title: const TextPro('Let\'s sell something'),
        elevation: 0.5,
        backgroundColor: Colors.white,
      ),
      body: FutureBuilder<Position>(
        future: ref.read(productCreateViewModel).determinePosition(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final position = snapshot.data!;
            return CreateStructure(position: position);
          } else {
            return const CoolLoading();
          }
        },
      ),
    );
  }
}
