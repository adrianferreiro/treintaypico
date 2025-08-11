import 'package:treintaypico/features/orders/domain/entities/order_item_entity.dart';
import 'package:treintaypico/features/orders/domain/enums/order_status.dart';
import 'package:treintaypico/features/orders/domain/enums/payments_methods.dart';

class OrderEntity {
  final String id;
  final String eventId;
  final String userId;
  final String companyId;
  final List<OrderItemEntity> items;
  final int totalAmount;
  final bool isOrderActive;
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
    required this.companyId,
    required this.items,
    required this.totalAmount,
    required this.isOrderActive,
    required this.status,
    required this.isPaid,
    this.paymentMethod,
    required this.orderNumber,
    required this.createdAt,
    required this.updatedAt,
    this.deliveredAt,
  });
}
