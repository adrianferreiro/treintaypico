import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:treintaypico/core/domain/usecase/use_case.dart';
import 'package:treintaypico/core/network/errors/failures.dart';
import 'package:treintaypico/features/categories/application/providers/category_providers.dart';
import 'package:treintaypico/features/categories/domain/repositories/category_repository.dart';

final createCategoryUseCaseProvider = Provider<CreateCategoryUseCase>((ref) {
  final repo = ref.read(categoryRepositoryProvider);
  return CreateCategoryUseCase(repository: repo);
});

class CreateCategoryUseCase extends UseCase<void, CreateCategoryParams> {
  final CategoryRepository repository;

  CreateCategoryUseCase({required this.repository});

  @override
  Future<Either<Failure, void>> call(CreateCategoryParams params) {
    return repository.createCategory(
      name: params.name,
      venueId: params.venueId,
      order: params.order,
      imageUrl: params.imageUrl,
    );
  }
}

class CreateCategoryParams {
  final String name;
  final String venueId;
  final int order;
  final String? imageUrl;

  const CreateCategoryParams({
    required this.name,
    required this.venueId,
    required this.order,
    this.imageUrl,
  });
}
