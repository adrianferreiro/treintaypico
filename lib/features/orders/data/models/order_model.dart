import 'order_item_model.dart';

class OrderModel {
  final String id;
  final String eventId;
  final String userId;
  final String companyId;
  final List<OrderItemModel> items;
  final int totalAmount;
  final bool isOrderActive;
  final String status; // 'pending' | 'confirmed' | ...
  final bool isPaid;
  final String? paymentMethod; // 'cash' | 'card' | 'transfer' | null
  final String orderNumber;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deliveredAt;

  const OrderModel({
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

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'] as String,
      eventId: json['event_id'] as String,
      userId: json['user_id'] as String,
      companyId: json['company_id'] as String,
      items: (json['items'] as List<dynamic>)
          .map((e) => OrderItemModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      totalAmount: (json['total_amount'] as num).toInt(),
      isOrderActive: json['isOrderActive'] as bool,
      status: json['status'] as String,
      isPaid: json['isPaid'] as bool,
      paymentMethod: json['payment_method'] as String?,
      orderNumber: json['order_number'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      deliveredAt: json['delivered_at'] != null
          ? DateTime.parse(json['delivered_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'event_id': eventId,
      'user_id': userId,
      'company_id': companyId,
      'items': items.map((e) => e.toJson()).toList(),
      'total_amount': totalAmount,
      'isOrderActive': isOrderActive,
      'status': status,
      'isPaid': isPaid,
      'payment_method': paymentMethod,
      'order_number': orderNumber,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'delivered_at': deliveredAt?.toIso8601String(),
    };
  }
}
