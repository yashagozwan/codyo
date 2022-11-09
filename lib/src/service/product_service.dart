import 'package:codyo/src/constant/constant.dart';
import 'package:codyo/src/model/product_model.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProductService {
  final _productsTable = 'products';

  Future<String> uploadImageProduct(XFile xFile) async {
    try {
      final fileBytes = await xFile.readAsBytes();
      final fileExt = xFile.name.split('.').last;
      final fileName = '${DateTime.now().millisecondsSinceEpoch}.$fileExt';
      final filepath = fileName;

      await supabase.storage.from(_productsTable).uploadBinary(
            filepath,
            fileBytes,
            fileOptions: FileOptions(contentType: xFile.mimeType),
          );

      return supabase.storage.from(_productsTable).getPublicUrl(filepath);
    } on PostgrestException {
      rethrow;
    }
  }

  Future<bool> createProduct(Product product) async {
    try {
      await supabase.from(_productsTable).insert(product.toPostgres());
      return true;
    } on PostgrestException {
      rethrow;
    }
  }

  Future<Iterable<Product>> getProducts() async {
    try {
      final dynamicProducts = await supabase
          .from(_productsTable)
          .select()
          .eq('isSold', false)
          .order('createdAt', ascending: false) as Iterable;

      return dynamicProducts.map((product) => Product.fromMap(product));
    } on PostgrestException {
      rethrow;
    }
  }

  Future<Iterable<Product>> getNewThreeProducts() async {
    try {
      final dynamicProducts = await supabase
          .from(_productsTable)
          .select()
          .eq('isSold', false)
          .limit(3)
          .order('createdAt', ascending: false) as Iterable;

      return dynamicProducts.map((product) => Product.fromMap(product));
    } on PostgrestException {
      rethrow;
    }
  }

  Future<Iterable<Product>> getProductByUserId(int userId) async {
    try {
      final products = await supabase
          .from(_productsTable)
          .select()
          .eq('userId', userId)
          .filter('isSold', 'eq', false)
          .order('createdAt', ascending: false) as Iterable;

      return products.map((product) => Product.fromMap(product));
    } on PostgrestException {
      rethrow;
    }
  }

  Future<Iterable<Product>> getSoldProductByUserId(int userId) async {
    try {
      final products = await supabase
          .from(_productsTable)
          .select()
          .eq('userId', userId)
          .filter('isSold', 'eq', true)
          .order('createdAt', ascending: false) as Iterable;

      return products.map((product) => Product.fromMap(product));
    } on PostgrestException {
      rethrow;
    }
  }

  Future<Iterable<Product>> searchProducts(String search) async {
    try {
      final products = await supabase
          .from(_productsTable)
          .select()
          .ilike('title', '%$search%')
          .filter('isSold', 'eq', false) as Iterable;

      return products.map((product) => Product.fromMap(product));
    } on PostgrestException {
      rethrow;
    }
  }

  Future<void> updateProduct(Product product) async {
    try {
      await supabase
          .from(_productsTable)
          .update(product.toPostgresUpdate())
          .eq('id', product.id);
    } on PostgrestException {
      rethrow;
    }
  }

  Future<void> removeProduct(Product product) async {
    try {
      await supabase.from(_productsTable).delete().eq('id', product.id);
    } on PostgrestException {
      rethrow;
    }
  }
}
