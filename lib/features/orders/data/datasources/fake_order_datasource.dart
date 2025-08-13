import 'package:treintaypico/core/network/exceptions/exceptions.dart';
import 'package:treintaypico/features/orders/data/datasources/order_datasource.dart';
import 'package:treintaypico/features/orders/data/models/order_item_model.dart';
import 'package:treintaypico/features/orders/data/models/order_model.dart';

class FakeOrderDatasource implements OrderDatasource {
  @override
  Future<OrderModel> getOrderById(String id) async {
    await Future.delayed(const Duration(milliseconds: 300)); // simula red

    if (id == '404') throw NotFoundException();

    final now = DateTime.now();
    String two(int n) => n.toString().padLeft(2, '0');
    final orderNumber = 'ORD-${now.year}${two(now.month)}${two(now.day)}-001';

    return OrderModel(
      id: id,
      eventId: 'event_789',
      userId: 'user_123',
      companyId: 'company_456',
      items: const [
        OrderItemModel(
          categoryId: 'cat_beer',
          productName: 'Heineken 470',
          quantity: 2,
          unitPrice: 2500,
          subtotal: 5000,
        ),
        OrderItemModel(
          categoryId: 'cat_cocktail',
          productName: 'Gin Tonic',
          quantity: 1,
          unitPrice: 6000,
          subtotal: 6000,
        ),
      ],
      totalAmount: 11000,
      isOrderActive: true,
      status: 'pending', // mapea a OrderStatus.pending en el mapper
      isPaid: false,
      paymentMethod: null, // o 'cash' | 'card' | 'transfer'
      orderNumber: orderNumber,
      createdAt: now,
      updatedAt: now,
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
