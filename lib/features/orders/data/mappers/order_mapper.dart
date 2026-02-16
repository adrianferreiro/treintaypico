import 'package:treintaypico/features/orders/data/models/order_item_model.dart';
import 'package:treintaypico/features/orders/data/models/order_model.dart';
import 'package:treintaypico/features/orders/domain/entities/order_entity.dart';
import 'package:treintaypico/features/orders/domain/entities/order_item_entity.dart';

extension OrderItemMapper on OrderItemModel {
  OrderItemEntity toEntity() {
    return OrderItemEntity(
      productId: productId,
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
      userName: userName,
      companyId: companyId,
      items: items.map((e) => e.toEntity()).toList(),
      totalAmount: totalAmount,
      status: OrderStatus.values.byName(status),
      isPaid: isPaid,
      paymentMethod: paymentMethod != null
          ? PaymentMethod.values.byName(paymentMethod!)
          : null,
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
