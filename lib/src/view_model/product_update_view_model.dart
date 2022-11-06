import 'package:codyo/src/model/product_model.dart';
import 'package:codyo/src/util/error_message.dart';
import 'package:codyo/src/util/finite_state.dart';
import 'package:flutter/material.dart' show ChangeNotifier;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProductUpdateNotifier extends ChangeNotifier
    with FiniteState, ErrorMessage {
  XFile? xFile;

  void setXFile(XFile? newXFile) {
    xFile = newXFile;
    notifyListeners();
  }

  Future<void> updateProduct() async {
    try {} on PostgrestException {
      rethrow;
    }
  }
}

final productUpdateViewModel = ChangeNotifierProvider<ProductUpdateNotifier>(
  (ref) => ProductUpdateNotifier(),
);
