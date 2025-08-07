import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:treintaypico/core/domain/usecase/use_case.dart';
import 'package:treintaypico/core/network/errors/failures.dart';
import 'package:treintaypico/features/orders/domain/repositories/order_repository.dart';
import 'package:treintaypico/features/orders/application/providers/order_providers.dart';

final markOrderAsPaidUseCaseProvider = Provider<MarkOrderAsPaidUseCase>((ref) {
  final repo = ref.read(orderRepositoryProvider);
  return MarkOrderAsPaidUseCase(repository: repo);
});

class MarkOrderAsPaidParams {
  final String orderId;
  final String paymentMethod;

  const MarkOrderAsPaidParams({
    required this.orderId,
    required this.paymentMethod,
  });
}

class MarkOrderAsPaidUseCase extends UseCase<void, MarkOrderAsPaidParams> {
  final OrderRepository repository;

  MarkOrderAsPaidUseCase({required this.repository});

  @override
  Future<Either<Failure, void>> call(MarkOrderAsPaidParams params) {
    return repository.markOrderAsPaid(
      orderId: params.orderId,
      paymentMethod: params.paymentMethod,
    );
  }
}
