import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:treintaypico/core/domain/usecase/use_case.dart';
import 'package:treintaypico/core/network/errors/failures.dart';
import 'package:treintaypico/features/products/application/providers/product_providers.dart';
import 'package:treintaypico/features/products/domain/repositories/product_repository.dart';

final toggleProductUseCaseProvider = Provider<ToggleProductUseCase>((ref) {
  final repo = ref.read(productRepositoryProvider);
  return ToggleProductUseCase(repository: repo);
});

class ToggleProductUseCase extends UseCase<void, ToggleProductParams> {
  final ProductRepository repository;

  ToggleProductUseCase({required this.repository});

  @override
  Future<Either<Failure, void>> call(ToggleProductParams params) {
    return repository.toggleProductActive(
      id: params.id,
      isActive: params.isActive,
    );
  }
}

class ToggleProductParams {
  final String id;
  final bool isActive;

  const ToggleProductParams({
    required this.id,
    required this.isActive,
  });
}
