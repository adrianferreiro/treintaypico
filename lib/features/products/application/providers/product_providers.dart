import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:treintaypico/features/products/application/controllers/product_controller.dart';
import 'package:treintaypico/features/products/application/states/product_state.dart';
import 'package:treintaypico/features/products/application/usecases/create_product_usecase.dart';
import 'package:treintaypico/features/products/application/usecases/get_products_usecase.dart';
import 'package:treintaypico/features/products/application/usecases/toggle_product_usecase.dart';
import 'package:treintaypico/features/products/application/usecases/update_product_usecase.dart';
import 'package:treintaypico/features/products/data/datasources/product_datasource_provider.dart';
import 'package:treintaypico/features/products/data/repositories/product_repository_impl.dart';
import 'package:treintaypico/features/products/domain/repositories/product_repository.dart';

final productRepositoryProvider = Provider<ProductRepository>((ref) {
  final datasource = ref.read(productDatasourceProvider);
  return ProductRepositoryImpl(datasource: datasource);
});

final productControllerProvider =
    StateNotifierProvider<ProductController, ProductState>((ref) {
  return ProductController(
    getProductsUseCase: ref.read(getProductsUseCaseProvider),
    createProductUseCase: ref.read(createProductUseCaseProvider),
    updateProductUseCase: ref.read(updateProductUseCaseProvider),
    toggleProductUseCase: ref.read(toggleProductUseCaseProvider),
  );
});
