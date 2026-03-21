import 'package:treintaypico/features/categories/data/models/category_model.dart';
import 'package:treintaypico/features/categories/domain/entities/category_entity.dart';

extension CategoryMapper on CategoryModel {
  CategoryEntity toEntity() {
    return CategoryEntity(
      id: id,
      name: name,
      venueId: venueId,
      order: order,
      isActive: isActive,
      imageUrl: imageUrl,
    );
  }
}

extension CategoryModelListMapper on List<CategoryModel> {
  List<CategoryEntity> toEntityList() => map((e) => e.toEntity()).toList();
}
