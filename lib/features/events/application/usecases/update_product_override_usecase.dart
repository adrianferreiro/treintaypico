import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:treintaypico/core/domain/usecase/use_case.dart';
import 'package:treintaypico/core/network/errors/failures.dart';
import 'package:treintaypico/features/events/application/providers/event_providers.dart';
import 'package:treintaypico/features/events/domain/repositories/event_repository.dart';

final updateProductOverrideUseCaseProvider = Provider<UpdateProductOverrideUseCase>((ref) {
  final repo = ref.read(eventRepositoryProvider);
  return UpdateProductOverrideUseCase(repository: repo);
});

class UpdateProductOverrideUseCase extends UseCase<void, UpdateProductOverrideParams> {
  final EventRepository repository;

  UpdateProductOverrideUseCase({required this.repository});

  @override
  Future<Either<Failure, void>> call(UpdateProductOverrideParams params) {
    return repository.updateProductOverride(
      eventId: params.eventId,
      productId: params.productId,
      price: params.price,
      enabled: params.enabled,
    );
  }
}

class UpdateProductOverrideParams {
  final String eventId;
  final String productId;
  final int price;
  final bool enabled;

  const UpdateProductOverrideParams({
    required this.eventId,
    required this.productId,
    required this.price,
    required this.enabled,
  });
}
