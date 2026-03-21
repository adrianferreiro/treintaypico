import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:treintaypico/features/events/data/models/event_model.dart';

abstract class EventDatasource {
  Future<List<EventModel>> getEventsByCompany(String companyId, {Source? source});
  Future<void> toggleEventAvailable({
    required String id,
    required bool isAvailable,
  });
  Future<void> updateProductOverride({
    required String eventId,
    required String productId,
    required int price,
    required bool enabled,
  });
  Future<void> createEvent({
    required String name,
    required DateTime date,
    required String companyId,
    required String venueId,
    required String frontpage,
    required String logo,
    required List<String> categories,
  });
  Future<void> updateEventCategories({
    required String eventId,
    required List<String> categories,
  });
}
