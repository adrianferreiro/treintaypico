import 'package:treintaypico/features/categories/data/models/category_model.dart';

abstract class CategoryDatasource {
  Future<List<CategoryModel>> getCategoriesByVenue(String venueId);
  Future<void> createCategory({
    required String name,
    required String venueId,
    required int order,
    String? imageUrl,
  });
  Future<void> updateCategory({
    required String id,
    required String name,
    String? imageUrl,
  });
  Future<void> toggleCategoryActive({
    required String id,
    required bool isActive,
  });
}
