import 'package:cached_network_image/cached_network_image.dart';
import 'package:codyo/src/model/product_model.dart';
import 'package:codyo/src/screen/home/home_screen.dart';
import 'package:codyo/src/util/finite_state.dart';
import 'package:codyo/src/util/screen_route.dart';
import 'package:codyo/src/util/util.dart';
import 'package:codyo/src/view_model/product_me_sold_view_model.dart';
import 'package:codyo/src/widget/cool_loading.dart';
import 'package:codyo/src/widget/empty_product.dart';
import 'package:codyo/src/widget/text_pro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';

class ProductMeSoldScreen extends ConsumerStatefulWidget {
  const ProductMeSoldScreen({super.key});

  @override
  ConsumerState<ProductMeSoldScreen> createState() {
    return _ProductMeSoldScreenState();
  }
}

class _ProductMeSoldScreenState extends ConsumerState<ProductMeSoldScreen> {
  Future<void> _initial() async {
    Future(() async {
      final viewModel = ref.read(productMeSoldViewModel);
      viewModel.getSoldProductByUserId();
      viewModel.setSomethingChange(false);
    });
  }

  @override
  void initState() {
    super.initState();
    _initial();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final viewModel = ref.watch(productMeSoldViewModel);
        if (viewModel.isSomethingChange) {
          Navigator.pop(context);
          Navigator.pushReplacement(
            context,
            ScreenRoute(
              screen: const HomeScreen(),
            ),
          );
          return true;
        } else {
          return true;
        }
      },
      child: Scaffold(
        backgroundColor: Colors.grey.shade100,
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              final viewModel = ref.watch(productMeSoldViewModel);
              if (viewModel.isSomethingChange) {
                Navigator.pop(context);
                Navigator.pushReplacement(
                  context,
                  ScreenRoute(
                    screen: const HomeScreen(),
                  ),
                );
              } else {
                Navigator.pop(context);
              }
            },
            icon: const Icon(Icons.arrow_back),
          ),
          backgroundColor: Colors.white,
          title: const TextPro('Sold Items'),
          iconTheme: const IconThemeData(
            color: Colors.black54,
          ),
          titleTextStyle: const TextStyle(
            color: Colors.black54,
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
          elevation: 0.5,
        ),
        body: Consumer(
          builder: (context, ref, child) {
            final viewModel = ref.watch(productMeSoldViewModel);
            switch (viewModel.stateAction) {
              case StateAction.idle:
                return _buildListProduct(viewModel.products);
              case StateAction.loading:
                return const CoolLoading();
              case StateAction.error:
                return const SizedBox.shrink();
            }
          },
        ),
      ),
    );
  }

  Widget _buildListProduct(Iterable<Product> products) {
    if (products.isEmpty) {
      return const EmptyProduct();
    }

    return ListView.separated(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(16),
      itemBuilder: (context, index) {
        final product = products.elementAt(index);
        return Container(
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: const EdgeInsets.all(14),
                decoration: const BoxDecoration(
                  color: Colors.green,
                ),
                child: TextPro(
                  'FROM ${Util.dateFormatterFull(product.createdAt)}',
                  color: Colors.white,
                ),
              ),
              Opacity(
                opacity: 0.4,
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
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
                      Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextPro(
                              Util.currencyFormatter(product.price),
                              fontWeight: FontWeight.w600,
                              fontSize: 18,
                            ),
                            const SizedBox(height: 8),
                            TextPro(
                              product.title,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                            const SizedBox(height: 4),
                            TextPro(
                              product.description,
                              height: 1.5,
                              maxLines: 2,
                              textOverflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
              const Divider(color: Colors.grey),
              Padding(
                padding: const EdgeInsets.only(bottom: 8, right: 14),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                              content: Container(
                                child: Lottie.asset(
                                  'asset/lottie/delete.json',
                                  width: 100,
                                  height: 100,
                                ),
                              ),
                              actions: [
                                TextButton(
                                  style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Text('No'),
                                ),
                                Consumer(
                                  builder: (context, ref, child) {
                                    final viewModel =
                                        ref.read(productMeSoldViewModel);

                                    return TextButton(
                                      style: ElevatedButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                      ),
                                      onPressed: () {
                                        viewModel.setSomethingChange(true);
                                        Navigator.pop(context);
                                        viewModel.removeProduct(product);
                                      },
                                      child: const Text('Yes'),
                                    );
                                  },
                                )
                              ],
                            );
                          },
                        );
                      },
                      child: const Text('Delete'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
      separatorBuilder: (context, index) => const SizedBox(height: 16),
      itemCount: products.length,
    );
  }
}
