import 'order_item_model.dart';

class OrderModel {
  final String id;
  final String eventId;
  final String userId;
  final String userName;
  final String companyId;
  final List<OrderItemModel> items;
  final int totalAmount;
  final String status;
  final bool isPaid;
  final String? paymentMethod;
  final String orderNumber;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deliveredAt;

  const OrderModel({
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

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'],
      eventId: json['event_id'],
      userId: json['user_id'],
      userName: json['user_name'] ?? 'Cliente',
      companyId: json['company_id'],
      items: (json['items'] as List<dynamic>)
          .map((e) => OrderItemModel.fromJson(e))
          .toList(),
      totalAmount: json['total_amount'],
      status: json['status'],
      isPaid: json['isPaid'],
      paymentMethod: json['payment_method'],
      orderNumber: json['order_number'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      deliveredAt: json['delivered_at'] != null
          ? DateTime.parse(json['delivered_at'])
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
