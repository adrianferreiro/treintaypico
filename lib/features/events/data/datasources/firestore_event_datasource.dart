import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:treintaypico/features/events/data/datasources/event_datasource.dart';
import 'package:treintaypico/features/events/data/models/event_model.dart';

class FirestoreEventDatasource implements EventDatasource {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<List<EventModel>> getEventsByCompany(String companyId, {Source? source}) async {
    final query = await _firestore
        .collection('events')
        .where('companyId', isEqualTo: companyId)
        .get(source != null ? GetOptions(source: source) : null);

    final events = query.docs.map((doc) {
      final data = doc.data();
      // Parse Firestore Timestamp for date
      final dateValue = data['date'];
      if (dateValue is Timestamp) {
        data['date'] = dateValue.toDate().toIso8601String();
      }
      return EventModel.fromJson(doc.id, data);
    }).toList();

    // Sort client-side to avoid requiring a composite index
    events.sort((a, b) => b.date.compareTo(a.date));
    return events;
  }

  @override
  Future<void> toggleEventAvailable({
    required String id,
    required bool isAvailable,
  }) async {
    await _firestore.collection('events').doc(id).update({
      'isAvailable': isAvailable,
    });
  }

  @override
  Future<void> updateProductOverride({
    required String eventId,
    required String productId,
    required int price,
    required bool enabled,
  }) async {
    // Use dot-notation for nested map updates
    await _firestore.collection('events').doc(eventId).update({
      'productOverrides.$productId.price': price,
      'productOverrides.$productId.enabled': enabled,
    });
  }

  @override
  Future<void> createEvent({
    required String name,
    required DateTime date,
    required String companyId,
    required String venueId,
    required String frontpage,
    required String logo,
    required List<String> categories,
  }) async {
    await _firestore.collection('events').add({
      'name': name,
      'date': Timestamp.fromDate(date),
      'companyId': companyId,
      'venueId': venueId,
      'isAvailable': false,
      'productOverrides': {},
      'frontpage': frontpage,
      'logo': logo,
      'categories': categories,
    });
  }

  @override
  Future<void> updateEventCategories({
    required String eventId,
    required List<String> categories,
  }) async {
    await _firestore.collection('events').doc(eventId).update({
      'categories': categories,
    });
  }
}
