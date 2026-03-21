import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:treintaypico/core/domain/usecase/use_case.dart';
import 'package:treintaypico/core/network/errors/failures.dart';
import 'package:treintaypico/features/products/application/providers/product_providers.dart';
import 'package:treintaypico/features/products/domain/repositories/product_repository.dart';

final createProductUseCaseProvider = Provider<CreateProductUseCase>((ref) {
  final repo = ref.read(productRepositoryProvider);
  return CreateProductUseCase(repository: repo);
});

class CreateProductUseCase extends UseCase<void, CreateProductParams> {
  final ProductRepository repository;

  CreateProductUseCase({required this.repository});

  @override
  Future<Either<Failure, void>> call(CreateProductParams params) {
    return repository.createProduct(
      name: params.name,
      price: params.price,
      categoryId: params.categoryId,
      imageUrl: params.imageUrl,
    );
  }
}

class CreateProductParams {
  final String name;
  final int price;
  final String categoryId;
  final String? imageUrl;

  const CreateProductParams({
    required this.name,
    required this.price,
    required this.categoryId,
    this.imageUrl,
  });
}
