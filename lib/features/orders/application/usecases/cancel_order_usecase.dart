import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:treintaypico/core/domain/usecase/use_case.dart';
import 'package:treintaypico/core/network/errors/failures.dart';
import 'package:treintaypico/features/orders/application/usecases/get_order_by_id_usecase.dart';
import 'package:treintaypico/features/orders/domain/repositories/order_repository.dart';
import 'package:treintaypico/features/orders/application/providers/order_providers.dart';

final cancelOrderUseCaseProvider = Provider<CancelOrderUseCase>((ref) {
  final repo = ref.read(orderRepositoryProvider);
  return CancelOrderUseCase(repository: repo);
});

class CancelOrderUseCase extends UseCase<void, OrderParams> {
  final OrderRepository repository;

  CancelOrderUseCase({required this.repository});

  @override
  Future<Either<Failure, void>> call(OrderParams params) {
    return repository.cancelOrder(params.orderId);
  }
}
