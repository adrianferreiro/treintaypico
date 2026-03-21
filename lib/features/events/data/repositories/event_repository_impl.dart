import 'package:dartz/dartz.dart';
import 'package:treintaypico/core/network/errors/failures.dart';
import 'package:treintaypico/features/events/data/datasources/event_datasource.dart';
import 'package:treintaypico/features/events/data/mappers/event_mapper.dart';
import 'package:treintaypico/features/events/domain/entities/event_entity.dart';
import 'package:treintaypico/features/events/domain/repositories/event_repository.dart';

class EventRepositoryImpl implements EventRepository {
  final EventDatasource datasource;

  EventRepositoryImpl({required this.datasource});

  @override
  Future<Either<Failure, List<EventEntity>>> getEventsByCompany(String companyId) async {
    try {
      final models = await datasource.getEventsByCompany(companyId);
      return Right(models.toEntityList());
    } catch (e) {
      return Left(ApiFailure(message: 'Error al cargar eventos: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> toggleEventAvailable({
    required String id,
    required bool isAvailable,
  }) async {
    try {
      await datasource.toggleEventAvailable(id: id, isAvailable: isAvailable);
      return const Right(null);
    } catch (e) {
      return Left(ApiFailure(message: 'Error al cambiar estado del evento'));
    }
  }

  @override
  Future<Either<Failure, void>> updateProductOverride({
    required String eventId,
    required String productId,
    required int price,
    required bool enabled,
  }) async {
    try {
      await datasource.updateProductOverride(
        eventId: eventId,
        productId: productId,
        price: price,
        enabled: enabled,
      );
      return const Right(null);
    } catch (e) {
      return Left(ApiFailure(message: 'Error al actualizar precio del evento'));
    }
  }

  @override
  Future<Either<Failure, void>> createEvent({
    required String name,
    required DateTime date,
    required String companyId,
    required String venueId,
    required String frontpage,
    required String logo,
    required List<String> categories,
  }) async {
    try {
      await datasource.createEvent(
        name: name,
        date: date,
        companyId: companyId,
        venueId: venueId,
        frontpage: frontpage,
        logo: logo,
        categories: categories,
      );
      return const Right(null);
    } catch (e) {
      return Left(ApiFailure(message: 'Error al crear evento: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> updateEventCategories({
    required String eventId,
    required List<String> categories,
  }) async {
    try {
      await datasource.updateEventCategories(
        eventId: eventId,
        categories: categories,
      );
      return const Right(null);
    } catch (e) {
      return Left(ApiFailure(message: 'Error al actualizar categorías del evento'));
    }
  }
}
