import 'package:treintaypico/features/orders/domain/entities/order_entity.dart';

sealed class OrderState {}

final class OrderInitial extends OrderState {}

final class OrderLoading extends OrderState {}

final class OrderLoaded extends OrderState {
  final OrderEntity order;
  OrderLoaded(this.order);
}

final class OrderSuccess extends OrderState {
  final String message;
  OrderSuccess(this.message);
}

final class OrderError extends OrderState {
  final String message;
  OrderError(this.message);
}
