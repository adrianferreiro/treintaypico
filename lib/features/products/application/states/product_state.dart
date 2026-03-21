import 'package:treintaypico/features/products/domain/entities/product_entity.dart';

sealed class ProductState {}

final class ProductInitial extends ProductState {}

final class ProductLoading extends ProductState {}

final class ProductLoaded extends ProductState {
  final List<ProductEntity> products;
  ProductLoaded(this.products);
}

final class ProductError extends ProductState {
  final String message;
  ProductError(this.message);
}
