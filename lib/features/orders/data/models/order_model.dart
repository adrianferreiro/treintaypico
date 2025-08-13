import 'package:cloud_firestore/cloud_firestore.dart';
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

  // Constructor desde DocumentSnapshot de Firebase
  factory OrderModel.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return OrderModel(
      id: doc.id, // El ID viene del documento
      eventId: data['event_id'] as String,
      userId: data['user_id'] as String,
      companyId: data['company_id'] as String,
      items: (data['items'] as List<dynamic>)
          .map((e) => OrderItemModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      totalAmount: (data['total_amount'] as num).toInt(),
      isOrderActive: data['isOrderActive'] as bool? ?? true,
      status: data['status'] as String,
      isPaid: data['isPaid'] as bool? ?? false,
      paymentMethod: data['payment_method'] as String?,
      orderNumber: data['order_number'] as String,
      createdAt: _parseTimestamp(data['created_at']),
      updatedAt: _parseTimestamp(data['updated_at']),
      deliveredAt: data['delivered_at'] != null
          ? _parseTimestamp(data['delivered_at'])
          : null,
    );
  }

  // Helper method para manejar diferentes tipos de timestamp
  static DateTime _parseTimestamp(dynamic timestamp) {
    if (timestamp is Timestamp) {
      return timestamp.toDate();
    } else if (timestamp is String) {
      return DateTime.parse(timestamp);
    } else if (timestamp is int) {
      return DateTime.fromMillisecondsSinceEpoch(timestamp);
    } else {
      throw ArgumentError('Invalid timestamp format: $timestamp');
    }
  }

  // Constructor desde JSON (mantener para compatibilidad)
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
      isOrderActive: json['isOrderActive'] as bool? ?? true,
      status: json['status'] as String,
      isPaid: json['isPaid'] as bool? ?? false,
      paymentMethod: json['payment_method'] as String?,
      orderNumber: json['order_number'] as String,
      createdAt: json['created_at'] is String
          ? DateTime.parse(json['created_at'] as String)
          : _parseTimestamp(json['created_at']),
      updatedAt: json['updated_at'] is String
          ? DateTime.parse(json['updated_at'] as String)
          : _parseTimestamp(json['updated_at']),
      deliveredAt: json['delivered_at'] != null
          ? (json['delivered_at'] is String
                ? DateTime.parse(json['delivered_at'] as String)
                : _parseTimestamp(json['delivered_at']))
          : null,
    );
  }

  // Convertir a Map para Firebase (sin el ID)
  Map<String, dynamic> toFirestore() {
    return {
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
      'created_at': Timestamp.fromDate(createdAt),
      'updated_at': Timestamp.fromDate(updatedAt),
      'delivered_at': deliveredAt != null
          ? Timestamp.fromDate(deliveredAt!)
          : null,
    };
  }

  // Mantener toJson para compatibilidad
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
