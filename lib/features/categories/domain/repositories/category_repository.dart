import 'package:dartz/dartz.dart';
import 'package:treintaypico/core/network/errors/failures.dart';
import 'package:treintaypico/features/categories/domain/entities/category_entity.dart';

abstract class CategoryRepository {
  Future<Either<Failure, List<CategoryEntity>>> getCategoriesByVenue(String venueId);
  Future<Either<Failure, void>> createCategory({
    required String name,
    required String venueId,
    required int order,
    String? imageUrl,
  });
  Future<Either<Failure, void>> updateCategory({
    required String id,
    required String name,
    String? imageUrl,
  });
  Future<Either<Failure, void>> toggleCategoryActive({
    required String id,
    required bool isActive,
  });
}
