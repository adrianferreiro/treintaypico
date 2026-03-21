import 'package:treintaypico/features/products/data/models/product_model.dart';
import 'package:treintaypico/features/products/domain/entities/product_entity.dart';

extension ProductMapper on ProductModel {
  ProductEntity toEntity() {
    return ProductEntity(
      id: id,
      name: name,
      price: price,
      categoryId: categoryId,
      isActive: isActive,
      imageUrl: imageUrl,
    );
  }
}

extension ProductModelListMapper on List<ProductModel> {
  List<ProductEntity> toEntityList() => map((e) => e.toEntity()).toList();
}
