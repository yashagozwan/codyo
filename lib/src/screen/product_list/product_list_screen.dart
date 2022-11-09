import 'package:codyo/src/screen/product_list/widget/product_empty.dart';
import 'package:codyo/src/screen/product_list/widget/product_grid.dart';
import 'package:codyo/src/screen/product_list/widget/product_news.dart';
import 'package:codyo/src/screen/product_list/widget/product_title.dart';
import 'package:codyo/src/util/finite_state.dart';
import 'package:codyo/src/view_model/product_list_view_model.dart';
import 'package:codyo/src/widget/cool_loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ProductListScreen extends ConsumerStatefulWidget {
  const ProductListScreen({super.key});

  @override
  ConsumerState<ProductListScreen> createState() {
    return _ProductListScreenState();
  }
}

class _ProductListScreenState extends ConsumerState<ProductListScreen> {
  final _search = TextEditingController();

  Future<void> _initial() async {
    Future(() async {
      final viewModel = ref.read(productListViewModel);
      if (viewModel.searchValue.isNotEmpty) {
        _search.text = viewModel.searchValue;
        return;
      }
      viewModel.getNewThreeProducts();
      viewModel.getProducts();
    });
  }

  @override
  void initState() {
    super.initState();
    _initial();
  }

  @override
  void dispose() {
    super.dispose();
    _search.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black54),
        leading: Consumer(
          builder: (context, ref, child) {
            final viewModel = ref.watch(productListViewModel);
            if (viewModel.searchValue.isNotEmpty) {
              return IconButton(
                onPressed: () {
                  ref.read(productListViewModel).searchProducts('');
                  ref.read(productListViewModel).setSearchValue('');
                  _search.clear();
                },
                icon: const Icon(Icons.arrow_back),
              );
            }
            return Center(
              child: SvgPicture.asset(
                'asset/svg/logos.svg',
                width: 40,
                height: 40,
                key: const Key('logo_app'),
              ),
            );
          },
        ),
        title: TextField(
          key: const Key('product_list_text_field_search'),
          controller: _search,
          textInputAction: TextInputAction.search,
          onSubmitted: (value) {
            ref.read(productListViewModel).searchProducts(value);
            ref.read(productListViewModel).setSearchValue(value);
          },
          keyboardType: TextInputType.url,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.all(0),
            prefixIcon: const Icon(Icons.search),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(
                color: Colors.grey.shade300,
                width: 1,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(
                color: Colors.blue.shade300,
                width: 1,
              ),
            ),
            hintText: 'Search Product',
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Consumer(
        builder: (context, ref, child) {
          final viewModel = ref.watch(productListViewModel);

          switch (viewModel.stateAction) {
            case StateAction.idle:
              if (viewModel.products.isEmpty) {
                return const ProductEmpty(
                  key: Key('product_list_product_empty'),
                );
              }

              return ListView(
                physics: const BouncingScrollPhysics(),
                children: [
                  const SizedBox(height: 16),
                  _newProducts(viewModel),
                  ProductTitle(
                    title: viewModel.searchValue.isEmpty
                        ? 'All Products'
                        : 'Result Search',
                  ),
                  const SizedBox(height: 8),
                  const ProductGrid(),
                ],
              );

            case StateAction.loading:
              return const CoolLoading();
            case StateAction.error:
              return const SizedBox.shrink();
          }
        },
      ),
    );
  }

  Widget _newProducts(ProductListNotifier viewModel) {
    if (viewModel.searchValue.isEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: const [
          ProductTitle(title: 'New product'),
          SizedBox(height: 16),
          ProductNews(),
          SizedBox(height: 16),
        ],
      );
    }

    return const SizedBox.shrink();
  }
}
