import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:treintaypico/core/domain/usecase/use_case.dart';
import 'package:treintaypico/core/network/errors/failures.dart';
import 'package:treintaypico/features/products/application/providers/product_providers.dart';
import 'package:treintaypico/features/products/domain/repositories/product_repository.dart';

final updateProductUseCaseProvider = Provider<UpdateProductUseCase>((ref) {
  final repo = ref.read(productRepositoryProvider);
  return UpdateProductUseCase(repository: repo);
});

class UpdateProductUseCase extends UseCase<void, UpdateProductParams> {
  final ProductRepository repository;

  UpdateProductUseCase({required this.repository});

  @override
  Future<Either<Failure, void>> call(UpdateProductParams params) {
    return repository.updateProduct(
      id: params.id,
      name: params.name,
      price: params.price,
      imageUrl: params.imageUrl,
    );
  }
}

class UpdateProductParams {
  final String id;
  final String name;
  final int price;
  final String? imageUrl;

  const UpdateProductParams({
    required this.id,
    required this.name,
    required this.price,
    this.imageUrl,
  });
}
