import 'order_item_entity.dart';

enum OrderStatus { pending, confirmed, paid, delivered, cancelled }

enum PaymentMethod { cash, card, transfer }

class OrderEntity {
  final String id;
  final String eventId;
  final String userId;
  final String userName;
  final String companyId;
  final List<OrderItemEntity> items;
  final int totalAmount;
  final OrderStatus status;
  final bool isPaid;
  final PaymentMethod? paymentMethod;
  final String orderNumber;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deliveredAt;

  const OrderEntity({
    required this.id,
    required this.eventId,
    required this.userId,
    required this.userName,
    required this.companyId,
    required this.items,
    required this.totalAmount,
    required this.status,
    required this.isPaid,
    this.paymentMethod,
    required this.orderNumber,
    required this.createdAt,
    required this.updatedAt,
    this.deliveredAt,
  });
}
