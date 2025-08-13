import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:treintaypico/core/providers/firebase_providers.dart';
import 'package:treintaypico/features/orders/data/datasources/firebase_order_datasource.dart';
import 'package:treintaypico/features/orders/data/datasources/order_datasource.dart';

final orderDatasourceProvider = Provider<OrderDatasource>((ref) {
  final firestore = ref.watch(firestoreProvider);
  return FirebaseOrderDatasource(firestore);
});
