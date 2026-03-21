import 'package:dartz/dartz.dart';
import 'package:treintaypico/core/network/errors/failures.dart';
import 'package:treintaypico/features/products/domain/entities/product_entity.dart';

abstract class ProductRepository {
  Future<Either<Failure, List<ProductEntity>>> getProductsByCategory(String categoryId);
  Future<Either<Failure, void>> createProduct({
    required String name,
    required int price,
    required String categoryId,
    String? imageUrl,
  });
  Future<Either<Failure, void>> updateProduct({
    required String id,
    required String name,
    required int price,
    String? imageUrl,
  });
  Future<Either<Failure, void>> toggleProductActive({
    required String id,
    required bool isActive,
  });
}
