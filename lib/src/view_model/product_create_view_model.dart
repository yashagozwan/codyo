import 'package:codyo/src/model/product_model.dart';
import 'package:codyo/src/service/geo_locator_service.dart';
import 'package:codyo/src/service/product_service.dart';
import 'package:codyo/src/service/shared_service.dart';
import 'package:codyo/src/util/error_message.dart';
import 'package:codyo/src/util/finite_state.dart';
import 'package:flutter/material.dart' show ChangeNotifier;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProductCreateNotifier extends ChangeNotifier
    with FiniteState, ErrorMessage {
  final _geoLocatorService = GeoLocatorService();
  final _productService = ProductService();
  final _sharedService = SharedService();

  XFile? xFile;
  int price = 0;
  String title = '';
  String description = '';

  void setXFile(XFile? newXFile) {
    xFile = newXFile;
    notifyListeners();
  }

  void setPrice(int newPrice) {
    price = newPrice;
    notifyListeners();
  }

  void setTitle(String newTitle) {
    title = newTitle;
    notifyListeners();
  }

  void setDescription(String newDescription) {
    description = newDescription;
    notifyListeners();
  }

  Future<Position> determinePosition() async {
    return await _geoLocatorService.determinePosition();
  }

  Future<void> createProduct(Product product) async {
    if (xFile == null) return;

    final userId = await _sharedService.getUserId();
    if (userId == null) return;

    setState(StateAction.loading);
    try {
      final imageUrl = await _productService.uploadImageProduct(xFile!);
      product.imageUrl = imageUrl;
      product.userId = userId;
      await _productService.createProduct(product);
      setState(StateAction.idle);
    } on PostgrestException {
      setState(StateAction.error);
      rethrow;
    }
  }
}

final productCreateViewModel = ChangeNotifierProvider<ProductCreateNotifier>(
  (ref) {
    return ProductCreateNotifier();
  },
);
