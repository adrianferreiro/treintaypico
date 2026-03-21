import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:treintaypico/core/domain/usecase/use_case.dart';
import 'package:treintaypico/core/network/errors/failures.dart';
import 'package:treintaypico/features/events/application/providers/event_providers.dart';
import 'package:treintaypico/features/events/domain/entities/event_entity.dart';
import 'package:treintaypico/features/events/domain/repositories/event_repository.dart';

final getEventsUseCaseProvider = Provider<GetEventsUseCase>((ref) {
  final repo = ref.read(eventRepositoryProvider);
  return GetEventsUseCase(repository: repo);
});

class GetEventsUseCase extends UseCase<List<EventEntity>, GetEventsParams> {
  final EventRepository repository;

  GetEventsUseCase({required this.repository});

  @override
  Future<Either<Failure, List<EventEntity>>> call(GetEventsParams params) {
    return repository.getEventsByCompany(params.companyId);
  }
}

class GetEventsParams {
  final String companyId;
  const GetEventsParams({required this.companyId});
}
