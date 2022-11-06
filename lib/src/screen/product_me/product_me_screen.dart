import 'package:cached_network_image/cached_network_image.dart';
import 'package:codyo/src/model/product_model.dart';
import 'package:codyo/src/screen/home/home_screen.dart';
import 'package:codyo/src/screen/product_update/product_update_screen.dart';
import 'package:codyo/src/util/finite_state.dart';
import 'package:codyo/src/util/screen_route.dart';
import 'package:codyo/src/util/util.dart';
import 'package:codyo/src/view_model/product_me_view_model.dart';
import 'package:codyo/src/widget/cool_loading.dart';
import 'package:codyo/src/widget/text_pro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';

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
    Future(() async {
      viewModel = ref.read(productMeViewModel);
      viewModel.getProductsByUserId();
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
        final watcher = ref.watch(productMeViewModel);
        if (watcher.isSomethingChange) {
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
          leading: Consumer(
            builder: (context, ref, child) {
              final viewModelWatcher = ref.watch(productMeViewModel);
              return IconButton(
                onPressed: () {
                  if (viewModelWatcher.isSomethingChange) {
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
              );
            },
          ),
          backgroundColor: Colors.white,
          elevation: 0.5,
          title: const TextPro('My Items'),
          iconTheme: const IconThemeData(
            color: Colors.black54,
          ),
          titleTextStyle: const TextStyle(
            color: Colors.black54,
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
        body: Consumer(
          builder: (context, ref, child) {
            final viewModelWatcher = ref.watch(productMeViewModel);
            switch (viewModelWatcher.stateAction) {
              case StateAction.idle:
                return _buildProductList(
                  viewModelWatcher.products,
                );
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

  Widget _buildProductList(Iterable<Product> products) {
    return ListView.separated(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(16),
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products.elementAt(index);
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: Colors.blue.shade100.withOpacity(0.8),
                offset: const Offset(0, 0),
                blurRadius: 10,
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: const EdgeInsets.all(14),
                decoration: const BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(14),
                  ),
                ),
                child: TextPro(
                  "FROM ${Util.dateFormatterFull(product.createdAt)}",
                  color: Colors.white,
                ),
              ),
              Container(
                padding: const EdgeInsets.all(14),
                width: MediaQuery.of(context).size.width,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
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
                    const SizedBox(width: 12),
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextPro(
                            Util.currencyFormatter(product.price),
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.black54,
                          ),
                          const SizedBox(height: 8),
                          TextPro(
                            product.title,
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            maxLines: 1,
                            textOverflow: TextOverflow.ellipsis,
                            color: Colors.black54,
                          ),
                          const SizedBox(height: 4),
                          TextPro(
                            product.description,
                            maxLines: 2,
                            textOverflow: TextOverflow.ellipsis,
                            height: 1.2,
                            color: Colors.black54,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(
                color: Colors.grey,
                height: 4,
              ),
              Padding(
                padding: const EdgeInsets.only(
                  right: 12,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => _alertMarkSold(product),
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text('Mark Sold'),
                    ),
                    const SizedBox(width: 8),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          ScreenRoute(
                            screen: ProductUpdateScreen(
                              product: product,
                            ),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text('Edit'),
                    ),
                    const SizedBox(width: 8),
                    TextButton(
                      onPressed: () => _alertDelete(product),
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
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
    );
  }

  void _alertDelete(Product product) async {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const TextPro(
            'Delete This Item?',
            textAlign: TextAlign.center,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: CachedNetworkImage(
                      imageUrl: product.imageUrl,
                      width: MediaQuery.of(context).size.width,
                      height: 200,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: Align(
                      alignment: Alignment.topRight,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Lottie.asset(
                          'asset/lottie/delete.json',
                          width: 60,
                          height: 60,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('No'),
            ),
            Consumer(
              builder: (context, ref, child) {
                final viewModel = ref.watch(productMeViewModel);
                final button = TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    viewModel.removeProduct(product);
                    viewModel.setSomethingChange(true);
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('Yes'),
                );

                switch (viewModel.stateAction) {
                  case StateAction.idle:
                    return button;
                  case StateAction.loading:
                    return Transform.scale(
                      scale: 0.5,
                      child: const CircularProgressIndicator(),
                    );
                  case StateAction.error:
                    return const SizedBox.shrink();
                }
              },
            ),
          ],
        );
      },
    );
  }

  void _alertMarkSold(Product product) async {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const TextPro(
            'Mark Sold This Item?',
            textAlign: TextAlign.center,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: CachedNetworkImage(
                      imageUrl: product.imageUrl,
                      width: MediaQuery.of(context).size.width,
                      height: 200,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: Align(
                      alignment: Alignment.topRight,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Lottie.asset(
                          'asset/lottie/success.json',
                          width: 60,
                          height: 60,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('No'),
            ),
            Consumer(
              builder: (context, ref, child) {
                final viewModel = ref.watch(productMeViewModel);
                final button = TextButton(
                  onPressed: () {
                    viewModel.markSoldProduct(product);
                    Navigator.pop(context);
                    viewModel.setSomethingChange(true);
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('Yes'),
                );

                switch (viewModel.stateAction) {
                  case StateAction.idle:
                    return button;
                  case StateAction.loading:
                    return Transform.scale(
                      scale: 0.5,
                      child: const CircularProgressIndicator(),
                    );
                  case StateAction.error:
                    return const SizedBox.shrink();
                }
              },
            )
          ],
        );
      },
    );
  }
}
