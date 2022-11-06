import 'package:cached_network_image/cached_network_image.dart';
import 'package:codyo/src/model/product_model.dart';
import 'package:codyo/src/util/finite_state.dart';
import 'package:codyo/src/util/util.dart';
import 'package:codyo/src/view_model/product_me_view_model.dart';
import 'package:codyo/src/widget/cool_loading.dart';
import 'package:codyo/src/widget/text_pro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProductMeScreen extends ConsumerStatefulWidget {
  const ProductMeScreen({super.key});

  @override
  ConsumerState<ProductMeScreen> createState() {
    return _ProductMeScreenState();
  }
}

class _ProductMeScreenState extends ConsumerState<ProductMeScreen> {
  late final ProductMeNotifier viewModel;

  Future<void> _initial() async {
    viewModel = ref.read(productMeViewModel);

    Future(() async {
      viewModel.getProductsByUserId();
    });
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
        elevation: 0.5,
        title: const TextPro('My Items'),
        iconTheme: const IconThemeData(
          color: Colors.black54,
        ),
        titleTextStyle: const TextStyle(
          color: Colors.black54,
          fontWeight: FontWeight.w600,
        ),
      ),
      body: Consumer(
        builder: (context, ref, child) {
          final viewModelWatcher = ref.watch(productMeViewModel);
          switch (viewModelWatcher.stateAction) {
            case StateAction.idle:
              return _buildProductList(viewModelWatcher.products);
            case StateAction.loading:
              return const CoolLoading();
            case StateAction.error:
              return const SizedBox.shrink();
          }
        },
      ),
    );
  }

  Widget _buildProductList(Iterable<Product> products) {
    return ListView.separated(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(16),
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products.elementAt(index);
        return Container(
          decoration: const BoxDecoration(
            border: Border(
              left: BorderSide(
                color: Colors.blue,
                width: 3,
              ),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: const EdgeInsets.all(14),
                color: Colors.grey.shade100,
                child: TextPro(
                  Util.dateFormatter(product.createdAt),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(14),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: CachedNetworkImage(
                        imageUrl: product.imageUrl,
                        width: 60,
                        height: 60,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
      separatorBuilder: (context, index) => const SizedBox(height: 16),
    );
  }
}
