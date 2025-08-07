import 'package:treintaypico/features/orders/data/models/order_model.dart';

abstract class OrderDatasource {
  Future<OrderModel> getOrderById(String id);
  Future<void> markOrderAsPaid({
    required String orderId,
    required String paymentMethod,
  });
  Future<void> cancelOrder(String orderId);
}
