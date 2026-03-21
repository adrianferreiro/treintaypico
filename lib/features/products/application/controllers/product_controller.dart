import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:treintaypico/features/products/application/states/product_state.dart';
import 'package:treintaypico/features/products/application/usecases/create_product_usecase.dart';
import 'package:treintaypico/features/products/application/usecases/get_products_usecase.dart';
import 'package:treintaypico/features/products/application/usecases/toggle_product_usecase.dart';
import 'package:treintaypico/features/products/application/usecases/update_product_usecase.dart';

class ProductController extends StateNotifier<ProductState> {
  final GetProductsUseCase getProductsUseCase;
  final CreateProductUseCase createProductUseCase;
  final UpdateProductUseCase updateProductUseCase;
  final ToggleProductUseCase toggleProductUseCase;

  String? _currentCategoryId;

  ProductController({
    required this.getProductsUseCase,
    required this.createProductUseCase,
    required this.updateProductUseCase,
    required this.toggleProductUseCase,
  }) : super(ProductInitial());

  Future<void> loadProducts(String categoryId) async {
    _currentCategoryId = categoryId;
    state = ProductLoading();
    final result = await getProductsUseCase(
      GetProductsParams(categoryId: categoryId),
    );
    state = result.fold(
      (failure) => ProductError(failure.message),
      (products) => ProductLoaded(products),
    );
  }

  Future<void> createProduct({
    required String name,
    required int price,
    required String categoryId,
    String? imageUrl,
  }) async {
    final result = await createProductUseCase(
      CreateProductParams(
        name: name,
        price: price,
        categoryId: categoryId,
        imageUrl: imageUrl,
      ),
    );
    result.fold(
      (failure) => state = ProductError(failure.message),
      (_) => loadProducts(_currentCategoryId ?? categoryId),
    );
  }

  Future<void> updateProduct({
    required String id,
    required String name,
    required int price,
    String? imageUrl,
  }) async {
    final result = await updateProductUseCase(
      UpdateProductParams(id: id, name: name, price: price, imageUrl: imageUrl),
    );
    result.fold(
      (failure) => state = ProductError(failure.message),
      (_) {
        if (_currentCategoryId != null) loadProducts(_currentCategoryId!);
      },
    );
  }

  Future<void> toggleProductActive({
    required String id,
    required bool isActive,
  }) async {
    final result = await toggleProductUseCase(
      ToggleProductParams(id: id, isActive: isActive),
    );
    result.fold(
      (failure) => state = ProductError(failure.message),
      (_) {
        if (_currentCategoryId != null) loadProducts(_currentCategoryId!);
      },
    );
  }

  void resetState() {
    state = ProductInitial();
  }
}
