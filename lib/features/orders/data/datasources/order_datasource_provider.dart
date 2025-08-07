import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:treintaypico/features/orders/data/datasources/order_datasource.dart';
import 'package:treintaypico/features/orders/data/datasources/fake_order_datasource.dart';

final orderDatasourceProvider = Provider<OrderDatasource>((ref) {
  return FakeOrderDatasource();
});
