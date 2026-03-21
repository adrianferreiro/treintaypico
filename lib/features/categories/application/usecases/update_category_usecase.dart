import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:treintaypico/core/domain/usecase/use_case.dart';
import 'package:treintaypico/core/network/errors/failures.dart';
import 'package:treintaypico/features/categories/application/providers/category_providers.dart';
import 'package:treintaypico/features/categories/domain/repositories/category_repository.dart';

final updateCategoryUseCaseProvider = Provider<UpdateCategoryUseCase>((ref) {
  final repo = ref.read(categoryRepositoryProvider);
  return UpdateCategoryUseCase(repository: repo);
});

class UpdateCategoryUseCase extends UseCase<void, UpdateCategoryParams> {
  final CategoryRepository repository;

  UpdateCategoryUseCase({required this.repository});

  @override
  Future<Either<Failure, void>> call(UpdateCategoryParams params) {
    return repository.updateCategory(
      id: params.id,
      name: params.name,
      imageUrl: params.imageUrl,
    );
  }
}

class UpdateCategoryParams {
  final String id;
  final String name;
  final String? imageUrl;

  const UpdateCategoryParams({
    required this.id,
    required this.name,
    this.imageUrl,
  });
}
