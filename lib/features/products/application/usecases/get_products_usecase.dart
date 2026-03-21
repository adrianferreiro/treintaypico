import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:treintaypico/core/domain/usecase/use_case.dart';
import 'package:treintaypico/core/network/errors/failures.dart';
import 'package:treintaypico/features/products/application/providers/product_providers.dart';
import 'package:treintaypico/features/products/domain/entities/product_entity.dart';
import 'package:treintaypico/features/products/domain/repositories/product_repository.dart';

final getProductsUseCaseProvider = Provider<GetProductsUseCase>((ref) {
  final repo = ref.read(productRepositoryProvider);
  return GetProductsUseCase(repository: repo);
});

class GetProductsUseCase extends UseCase<List<ProductEntity>, GetProductsParams> {
  final ProductRepository repository;

  GetProductsUseCase({required this.repository});

  @override
  Future<Either<Failure, List<ProductEntity>>> call(GetProductsParams params) {
    return repository.getProductsByCategory(params.categoryId);
  }
}

class GetProductsParams {
  final String categoryId;
  const GetProductsParams({required this.categoryId});
}
