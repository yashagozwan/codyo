import 'package:codyo/src/model/product_model.dart';
import 'package:codyo/src/util/util.dart';
import 'package:codyo/src/view_model/product_favorite_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';

import '../../../util/finite_state.dart';

class ProductFavoriteButton extends ConsumerStatefulWidget {
  final Product product;
  const ProductFavoriteButton({
    super.key,
    required this.product,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _ProductFavoriteButtonState();
  }
}

class _ProductFavoriteButtonState extends ConsumerState<ProductFavoriteButton> {
  late final Product _product;

  Future<void> _initial() async {
    _product = widget.product;
    Future(() async {
      final viewModel = ref.read(productFavoriteViewModel);
      viewModel.getUserId();
      viewModel.checkFavoriteSaveable(_product.id);
    });
  }

  @override
  void initState() {
    super.initState();
    _initial();
  }

  @override
  Widget build(BuildContext context) {
    return getButton();
  }

  Widget getButton() {
    final viewModel = ref.watch(productFavoriteViewModel);
    final isSaveable = viewModel.isSaveable;

    if (viewModel.userId == _product.userId) {
      return const SizedBox.shrink();
    }

    void saveToFavorite() async {
      if (!isSaveable) {
        viewModel.removeFavoriteByProductIdAndByUserId(_product.id);
        Util.showToastError('Removed in favorites');
      }

      final result = await viewModel.createFavorite(_product.id);
      if (result) Util.showToastSuccess('Saved in favorites');
    }

    switch (viewModel.stateAction) {
      case StateAction.idle:
        return Padding(
          padding: const EdgeInsets.all(8),
          child: SizedBox(
            width: 40,
            height: 40,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black12,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                padding: const EdgeInsets.all(0),
              ),
              onPressed: saveToFavorite,
              child: getAnimateIcon(),
            ),
          ),
        );
      case StateAction.loading:
        return Container(
          width: 40,
          height: 40,
          margin: const EdgeInsets.all(8),
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
          ),
          child: const CircularProgressIndicator(),
        );
      case StateAction.error:
        return const SizedBox.shrink();
    }
  }

  Widget getAnimateIcon() {
    final viewModel = ref.watch(productFavoriteViewModel);
    final isSaveable = viewModel.isSaveable;

    if (isSaveable) {
      return Transform.scale(
        scale: 1.3,
        child: Lottie.asset('asset/lottie/favorite_v1.json'),
      );
    }

    return Transform.scale(
      scale: 0.8,
      child: Lottie.asset('asset/lottie/success.json'),
    );
  }
}
