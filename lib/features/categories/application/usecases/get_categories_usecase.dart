import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:treintaypico/core/domain/usecase/use_case.dart';
import 'package:treintaypico/core/network/errors/failures.dart';
import 'package:treintaypico/features/categories/application/providers/category_providers.dart';
import 'package:treintaypico/features/categories/domain/entities/category_entity.dart';
import 'package:treintaypico/features/categories/domain/repositories/category_repository.dart';

final getCategoriesUseCaseProvider = Provider<GetCategoriesUseCase>((ref) {
  final repo = ref.read(categoryRepositoryProvider);
  return GetCategoriesUseCase(repository: repo);
});

class GetCategoriesUseCase extends UseCase<List<CategoryEntity>, GetCategoriesParams> {
  final CategoryRepository repository;

  GetCategoriesUseCase({required this.repository});

  @override
  Future<Either<Failure, List<CategoryEntity>>> call(GetCategoriesParams params) {
    return repository.getCategoriesByVenue(params.venueId);
  }
}

class GetCategoriesParams {
  final String venueId;
  const GetCategoriesParams({required this.venueId});
}
