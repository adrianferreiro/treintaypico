import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:treintaypico/features/events/data/datasources/event_datasource.dart';
import 'package:treintaypico/features/events/data/datasources/firestore_event_datasource.dart';

final eventDatasourceProvider = Provider<EventDatasource>((ref) {
  return FirestoreEventDatasource();
});
