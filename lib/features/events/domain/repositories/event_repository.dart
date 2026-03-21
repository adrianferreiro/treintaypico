import 'package:dartz/dartz.dart';
import 'package:treintaypico/core/network/errors/failures.dart';
import 'package:treintaypico/features/events/domain/entities/event_entity.dart';

abstract class EventRepository {
  Future<Either<Failure, List<EventEntity>>> getEventsByCompany(String companyId);
  Future<Either<Failure, void>> toggleEventAvailable({
    required String id,
    required bool isAvailable,
  });
  Future<Either<Failure, void>> updateProductOverride({
    required String eventId,
    required String productId,
    required int price,
    required bool enabled,
  });
  Future<Either<Failure, void>> createEvent({
    required String name,
    required DateTime date,
    required String companyId,
    required String venueId,
    required String frontpage,
    required String logo,
    required List<String> categories,
  });
  Future<Either<Failure, void>> updateEventCategories({
    required String eventId,
    required List<String> categories,
  });
}
