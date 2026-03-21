import 'package:dartz/dartz.dart';
import 'package:treintaypico/core/network/errors/failures.dart';
import 'package:treintaypico/features/categories/data/datasources/category_datasource.dart';
import 'package:treintaypico/features/categories/data/mappers/category_mapper.dart';
import 'package:treintaypico/features/categories/domain/entities/category_entity.dart';
import 'package:treintaypico/features/categories/domain/repositories/category_repository.dart';

class CategoryRepositoryImpl implements CategoryRepository {
  final CategoryDatasource datasource;

  CategoryRepositoryImpl({required this.datasource});

  @override
  Future<Either<Failure, List<CategoryEntity>>> getCategoriesByVenue(String venueId) async {
    try {
      final models = await datasource.getCategoriesByVenue(venueId);
      return Right(models.toEntityList());
    } catch (e) {
      return Left(ApiFailure(message: 'Error al cargar categorías: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> createCategory({
    required String name,
    required String venueId,
    required int order,
    String? imageUrl,
  }) async {
    try {
      await datasource.createCategory(
        name: name,
        venueId: venueId,
        order: order,
        imageUrl: imageUrl,
      );
      return const Right(null);
    } catch (e) {
      return Left(ApiFailure(message: 'Error al crear categoría'));
    }
  }

  @override
  Future<Either<Failure, void>> updateCategory({
    required String id,
    required String name,
    String? imageUrl,
  }) async {
    try {
      await datasource.updateCategory(id: id, name: name, imageUrl: imageUrl);
      return const Right(null);
    } catch (e) {
      return Left(ApiFailure(message: 'Error al actualizar categoría'));
    }
  }

  @override
  Future<Either<Failure, void>> toggleCategoryActive({
    required String id,
    required bool isActive,
  }) async {
    try {
      await datasource.toggleCategoryActive(id: id, isActive: isActive);
      return const Right(null);
    } catch (e) {
      return Left(ApiFailure(message: 'Error al cambiar estado de categoría'));
    }
  }
}
