import 'package:codyo/src/model/product_model.dart';
import 'package:codyo/src/widget/text_pro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProductUpdateScreen extends ConsumerStatefulWidget {
  final Product product;

  const ProductUpdateScreen({
    super.key,
    required this.product,
  });

  @override
  ConsumerState<ProductUpdateScreen> createState() {
    return _ProductUpdateScreenState();
  }
}

class _ProductUpdateScreenState extends ConsumerState<ProductUpdateScreen> {
  late final Product _product;

  Future<void> _initial() async {
    _product = widget.product;
    Future(() async {});
  }

  @override
  void initState() {
    super.initState();
    _initial();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black54),
        titleTextStyle: const TextStyle(
          color: Colors.black54,
          fontWeight: FontWeight.w600,
          fontSize: 18,
        ),
        title: const TextPro('Edit Item'),
        backgroundColor: Colors.white,
        elevation: 0.5,
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        children: [],
      ),
    );
  }

  Widget _imagePreview() {
    return SizedBox();
  }

  Widget _buildForms() {
    return Form(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [],
      ),
    );
  }
}
