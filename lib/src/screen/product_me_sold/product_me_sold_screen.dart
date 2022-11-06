import 'package:codyo/src/util/finite_state.dart';
import 'package:codyo/src/view_model/product_me_sold_view_model.dart';
import 'package:codyo/src/widget/text_pro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProductMeSoldScreen extends ConsumerStatefulWidget {
  const ProductMeSoldScreen({super.key});

  @override
  ConsumerState<ProductMeSoldScreen> createState() {
    return _ProductMeSoldScreenState();
  }
}

class _ProductMeSoldScreenState extends ConsumerState<ProductMeSoldScreen> {
  Future<void> _initial() async {
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
      body: Consumer(
        builder: (context, ref, child) {
          final viewModel = ref.watch(productMeSoldViewModel);

          switch (viewModel.stateAction) {
            case StateAction.idle:
              break;
            case StateAction.loading:
              break;
            case StateAction.error:
              break;
          }
        },
      ),
    );
  }
}
