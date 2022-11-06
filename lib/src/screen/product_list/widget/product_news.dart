import 'package:cached_network_image/cached_network_image.dart';
import 'package:codyo/src/screen/product_detail/product_detail_screen.dart';
import 'package:codyo/src/util/screen_route.dart';
import 'package:codyo/src/util/util.dart';
import 'package:codyo/src/view_model/product_list_view_model.dart';
import 'package:codyo/src/widget/text_pro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProductNews extends ConsumerStatefulWidget {
  const ProductNews({super.key});

  @override
  ConsumerState<ProductNews> createState() => _ProductNewsState();
}

class _ProductNewsState extends ConsumerState<ProductNews> {
  Future<void> _initial() async {}

  @override
  void initState() {
    super.initState();
    _initial();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final viewModel = ref.watch(productListViewModel);
        return SizedBox(
          height: 200,
          child: ListView.separated(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: viewModel.threeNewProducts.length,
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              final product = viewModel.threeNewProducts.elementAt(index);

              return ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: Stack(
                  children: [
                    CachedNetworkImage(imageUrl: product.imageUrl),
                    Positioned.fill(
                      child: Container(
                        padding: const EdgeInsets.all(14),
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            colors: [
                              Colors.black,
                              Colors.transparent,
                              Colors.transparent,
                            ],
                          ),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextPro(
                              product.title,
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                            const SizedBox(height: 12),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.green,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: TextPro(
                                Util.currencyFormatter(product.price),
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Positioned.fill(
                      child: Material(
                        borderRadius: BorderRadius.circular(14),
                        color: Colors.transparent,
                        child: InkWell(
                          splashColor: Colors.green.shade100.withOpacity(0.5),
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
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
            separatorBuilder: (_, __) => const SizedBox(width: 16),
          ),
        );
      },
    );
  }
}
