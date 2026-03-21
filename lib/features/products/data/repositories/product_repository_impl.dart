import 'package:dartz/dartz.dart';
import 'package:treintaypico/core/network/errors/failures.dart';
import 'package:treintaypico/features/products/data/datasources/product_datasource.dart';
import 'package:treintaypico/features/products/data/mappers/product_mapper.dart';
import 'package:treintaypico/features/products/domain/entities/product_entity.dart';
import 'package:treintaypico/features/products/domain/repositories/product_repository.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductDatasource datasource;

  ProductRepositoryImpl({required this.datasource});

  @override
  Future<Either<Failure, List<ProductEntity>>> getProductsByCategory(String categoryId) async {
    try {
      final models = await datasource.getProductsByCategory(categoryId);
      return Right(models.toEntityList());
    } catch (e) {
      return Left(ApiFailure(message: 'Error al cargar productos: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> createProduct({
    required String name,
    required int price,
    required String categoryId,
    String? imageUrl,
  }) async {
    try {
      await datasource.createProduct(
        name: name,
        price: price,
        categoryId: categoryId,
        imageUrl: imageUrl,
      );
      return const Right(null);
    } catch (e) {
      return Left(ApiFailure(message: 'Error al crear producto'));
    }
  }

  @override
  Future<Either<Failure, void>> updateProduct({
    required String id,
    required String name,
    required int price,
    String? imageUrl,
  }) async {
    try {
      await datasource.updateProduct(id: id, name: name, price: price, imageUrl: imageUrl);
      return const Right(null);
    } catch (e) {
      return Left(ApiFailure(message: 'Error al actualizar producto'));
    }
  }

  @override
  Future<Either<Failure, void>> toggleProductActive({
    required String id,
    required bool isActive,
  }) async {
    try {
      await datasource.toggleProductActive(id: id, isActive: isActive);
      return const Right(null);
    } catch (e) {
      return Left(ApiFailure(message: 'Error al cambiar estado de producto'));
    }
  }
}
