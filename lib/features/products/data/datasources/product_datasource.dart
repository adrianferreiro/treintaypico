import 'package:treintaypico/features/products/data/models/product_model.dart';

abstract class ProductDatasource {
  Future<List<ProductModel>> getProductsByCategory(String categoryId);
  Future<void> createProduct({
    required String name,
    required int price,
    required String categoryId,
    String? imageUrl,
  });
  Future<void> updateProduct({
    required String id,
    required String name,
    required int price,
    String? imageUrl,
  });
  Future<void> toggleProductActive({
    required String id,
    required bool isActive,
  });
}
