import 'package:treintaypico/core/network/exceptions/exceptions.dart';
import 'package:treintaypico/features/orders/data/datasources/order_datasource.dart';
import 'package:treintaypico/features/orders/data/models/order_item_model.dart';
import 'package:treintaypico/features/orders/data/models/order_model.dart';

class FakeOrderDatasource implements OrderDatasource {
  @override
  Future<OrderModel> getOrderById(String id) async {
    await Future.delayed(const Duration(milliseconds: 300)); // simula red

    if (id == '404') throw NotFoundException();

    return OrderModel(
      id: id,
      eventId: 'event_789',
      userId: 'user_123',
      userName: 'Cliente Test',
      companyId: 'company_456',
      items: [
        OrderItemModel(
          productId: 'product_001',
          productName: 'Lata Heineken 280ml',
          quantity: 2,
          unitPrice: 250,
          subtotal: 500,
        ),
        OrderItemModel(
          productId: 'product_002',
          productName: 'Gin Tonic',
          quantity: 1,
          unitPrice: 6000,
          subtotal: 6000,
        ),
      ],
      totalAmount: 6500,
      status: 'pending',
      isPaid: false,
      paymentMethod: null,
      orderNumber: 'ORD-20240806-001',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      deliveredAt: null,
    );
  }

  @override
  Future<void> cancelOrder(String orderId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    // simulación simple
  }

  @override
  Future<void> markOrderAsPaid({
    required String orderId,
    required String paymentMethod,
  }) async {
    await Future.delayed(const Duration(milliseconds: 300));
    // simulación simple
  }
}
