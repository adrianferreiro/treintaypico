import 'package:dartz/dartz.dart';
import 'package:treintaypico/core/domain/usecase/use_case.dart';
import 'package:treintaypico/core/network/errors/failures.dart';
import 'package:treintaypico/features/events/domain/repositories/event_repository.dart';

class UpdateEventCategoriesUseCase extends UseCase<void, UpdateEventCategoriesParams> {
  final EventRepository repository;

  UpdateEventCategoriesUseCase({required this.repository});

  @override
  Future<Either<Failure, void>> call(UpdateEventCategoriesParams params) {
    return repository.updateEventCategories(
      eventId: params.eventId,
      categories: params.categories,
    );
  }
}

class UpdateEventCategoriesParams {
  final String eventId;
  final List<String> categories;

  const UpdateEventCategoriesParams({
    required this.eventId,
    required this.categories,
  });
}
