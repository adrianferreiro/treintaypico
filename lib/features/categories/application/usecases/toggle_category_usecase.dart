import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:treintaypico/core/domain/usecase/use_case.dart';
import 'package:treintaypico/core/network/errors/failures.dart';
import 'package:treintaypico/features/categories/application/providers/category_providers.dart';
import 'package:treintaypico/features/categories/domain/repositories/category_repository.dart';

final toggleCategoryUseCaseProvider = Provider<ToggleCategoryUseCase>((ref) {
  final repo = ref.read(categoryRepositoryProvider);
  return ToggleCategoryUseCase(repository: repo);
});

class ToggleCategoryUseCase extends UseCase<void, ToggleCategoryParams> {
  final CategoryRepository repository;

  ToggleCategoryUseCase({required this.repository});

  @override
  Future<Either<Failure, void>> call(ToggleCategoryParams params) {
    return repository.toggleCategoryActive(
      id: params.id,
      isActive: params.isActive,
    );
  }
}

class ToggleCategoryParams {
  final String id;
  final bool isActive;

  const ToggleCategoryParams({
    required this.id,
    required this.isActive,
  });
}
