import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:treintaypico/core/domain/usecase/use_case.dart';
import 'package:treintaypico/core/network/errors/failures.dart';
import 'package:treintaypico/features/orders/application/providers/order_providers.dart';
import 'package:treintaypico/features/orders/domain/entities/order_entity.dart';
import 'package:treintaypico/features/orders/domain/repositories/order_repository.dart';

final getOrderByIdUseCaseProvider = Provider<GetOrderByIdUseCase>((ref) {
  final repo = ref.read(orderRepositoryProvider);
  return GetOrderByIdUseCase(repository: repo);
});

class GetOrderByIdUseCase extends UseCase<OrderEntity, OrderParams> {
  final OrderRepository repository;

  GetOrderByIdUseCase({required this.repository});

  @override
  Future<Either<Failure, OrderEntity>> call(OrderParams params) {
    return repository.getOrderById(params.orderId);
  }
}

class OrderParams {
  final String orderId;

  const OrderParams({required this.orderId});
}
