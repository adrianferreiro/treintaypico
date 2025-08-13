import 'package:treintaypico/features/orders/data/models/order_item_model.dart';
import 'package:treintaypico/features/orders/data/models/order_model.dart';
import 'package:treintaypico/features/orders/domain/entities/order_entity.dart';
import 'package:treintaypico/features/orders/domain/entities/order_item_entity.dart';
import 'package:treintaypico/features/orders/domain/enums/order_status.dart';
import 'package:treintaypico/features/orders/domain/enums/payments_methods.dart';

extension OrderItemMapper on OrderItemModel {
  OrderItemEntity toEntity() {
    return OrderItemEntity(
      categoryId: categoryId,
      productName: productName,
      quantity: quantity,
      unitPrice: unitPrice,
      subtotal: subtotal,
    );
  }
}

extension OrderMapper on OrderModel {
  OrderEntity toEntity() {
    return OrderEntity(
      id: id,
      eventId: eventId,
      userId: userId,
      companyId: companyId,
      items: items.map((e) => e.toEntity()).toList(),
      totalAmount: totalAmount,
      isOrderActive: isOrderActive,
      status: _statusFromString(status),
      isPaid: isPaid,
      paymentMethod: _paymentFromString(paymentMethod),
      orderNumber: orderNumber,
      createdAt: createdAt,
      updatedAt: updatedAt,
      deliveredAt: deliveredAt,
    );
  }
}

extension OrderModelListMapper on List<OrderModel> {
  List<OrderEntity> toEntityList() => map((e) => e.toEntity()).toList();
}

// ---------- Helpers de mapeo seguro ----------

OrderStatus _statusFromString(String raw) {
  final v = raw.trim().toLowerCase();
  for (final s in OrderStatus.values) {
    if (s.name == v) return s;
  }
  // Fallback razonable si backend envía algo inesperado
  return OrderStatus.pending;
}

PaymentMethod? _paymentFromString(String? raw) {
  if (raw == null) return null;
  final v = raw.trim().toLowerCase();
  for (final p in PaymentMethod.values) {
    if (p.name == v) return p;
  }
  // Si llega un método desconocido, devolvemos null
  return null;
}
