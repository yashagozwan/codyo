import 'package:cached_network_image/cached_network_image.dart';
import 'package:codyo/src/model/product_model.dart';
import 'package:codyo/src/screen/product_detail/product_detail_screen.dart';
import 'package:codyo/src/util/finite_state.dart';
import 'package:codyo/src/util/screen_route.dart';
import 'package:codyo/src/util/util.dart';
import 'package:codyo/src/view_model/product_favorite_view_model.dart';
import 'package:codyo/src/widget/cool_loading.dart';
import 'package:codyo/src/widget/empty_product.dart';
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
  Future<void> _initial() async {
    Future(() async {
      final viewModel = ref.read(productFavoriteViewModel);
      viewModel.getFavoriteProductByUserId();
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
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        leading: Lottie.asset('asset/lottie/favorite_v1.json'),
        titleTextStyle: const TextStyle(
          color: Colors.black54,
          fontWeight: FontWeight.w600,
          fontSize: 18,
        ),
        title: const TextPro('Favorite Items'),
        elevation: 0.5,
        backgroundColor: Colors.white,
      ),
      body: Consumer(
        builder: (context, ref, child) {
          final viewModel = ref.watch(productFavoriteViewModel);
          switch (viewModel.stateAction) {
            case StateAction.idle:
              return _buildFavoriteProductList(viewModel.products);
            case StateAction.loading:
              return const CoolLoading();
            case StateAction.error:
              return const SizedBox.shrink();
          }
        },
      ),
    );
  }

  Widget _buildFavoriteProductList(Iterable<Product> products) {
    if (products.isEmpty) {
      return const EmptyProduct();
    }

    return ListView.separated(
      padding: const EdgeInsets.all(14),
      itemBuilder: (context, index) {
        final product = products.elementAt(index);
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              ScreenRoute(
                screen: ProductDetailScreen(
                  product: product,
                ),
              ),
            );
          },
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: CachedNetworkImage(
                    imageUrl: product.imageUrl,
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextPro(
                        Util.currencyFormatter(product.price),
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                        maxLines: 2,
                        textOverflow: TextOverflow.ellipsis,
                        color: Colors.black54,
                      ),
                      const SizedBox(height: 4),
                      TextPro(
                        product.title,
                        fontWeight: FontWeight.w400,
                        maxLines: 2,
                        textOverflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: 50,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red.shade100,
                      elevation: 0,
                      padding: const EdgeInsets.all(0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: const Icon(
                      Icons.delete,
                      color: Colors.red,
                    ),
                    onPressed: () {
                      final viewModel = ref.read(productFavoriteViewModel);
                      viewModel
                          .removeFavoriteByProductIdAndByUserId(product.id);
                      Util.showToastError('Removed in favorites');
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
      separatorBuilder: (context, index) => const SizedBox(height: 14),
      itemCount: products.length,
    );
  }
}
