import 'package:codyo/src/model/product_model.dart';
import 'package:codyo/src/service/product_service.dart';
import 'package:codyo/src/util/error_message.dart';
import 'package:codyo/src/util/finite_state.dart';
import 'package:flutter/material.dart' show ChangeNotifier;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProductUpdateNotifier extends ChangeNotifier
    with FiniteState, ErrorMessage {
  final _productService = ProductService();

  XFile? xFile;

  void setXFile(XFile? newXFile) {
    xFile = newXFile;
    notifyListeners();
  }

  Future<void> updateProduct(Product product) async {
    setState(StateAction.loading);
    try {
      if (xFile != null) {
        final imageUrl = await _productService.uploadImageProduct(xFile!);
        product.imageUrl = imageUrl;
      }
      await _productService.updateProduct(product);
      setState(StateAction.idle);
    } on PostgrestException {
      setState(StateAction.error);
      rethrow;
    }
  }
}

final productUpdateViewModel = ChangeNotifierProvider<ProductUpdateNotifier>(
  (ref) => ProductUpdateNotifier(),
);
