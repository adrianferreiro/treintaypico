import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:treintaypico/core/domain/usecase/use_case.dart';
import 'package:treintaypico/core/network/errors/failures.dart';
import 'package:treintaypico/features/events/application/providers/event_providers.dart';
import 'package:treintaypico/features/events/domain/repositories/event_repository.dart';

final toggleEventUseCaseProvider = Provider<ToggleEventUseCase>((ref) {
  final repo = ref.read(eventRepositoryProvider);
  return ToggleEventUseCase(repository: repo);
});

class ToggleEventUseCase extends UseCase<void, ToggleEventParams> {
  final EventRepository repository;

  ToggleEventUseCase({required this.repository});

  @override
  Future<Either<Failure, void>> call(ToggleEventParams params) {
    return repository.toggleEventAvailable(
      id: params.id,
      isAvailable: params.isAvailable,
    );
  }
}

class ToggleEventParams {
  final String id;
  final bool isAvailable;

  const ToggleEventParams({
    required this.id,
    required this.isAvailable,
  });
}
